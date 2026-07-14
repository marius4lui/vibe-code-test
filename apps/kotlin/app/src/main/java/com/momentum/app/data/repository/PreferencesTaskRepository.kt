package com.momentum.app.data.repository

import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.booleanPreferencesKey
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.stringPreferencesKey
import com.momentum.app.data.error.MomentumStorageException
import com.momentum.app.data.error.TaskStorageReadException
import com.momentum.app.data.error.TaskStorageWriteException
import com.momentum.app.data.local.TaskStorageCodec
import com.momentum.app.domain.model.MomentumTask
import com.momentum.app.domain.model.TaskCategory
import com.momentum.app.domain.model.TaskDraft
import com.momentum.app.domain.model.TaskPriority
import com.momentum.app.domain.repository.DuplicateTaskException
import com.momentum.app.domain.repository.TaskNotFoundException
import com.momentum.app.domain.repository.TaskRepository
import com.momentum.app.domain.repository.TaskRepositoryException
import com.momentum.app.domain.validation.TaskValidationException
import com.momentum.app.domain.validation.TaskValidator
import java.time.Clock
import java.time.LocalDate
import java.time.LocalTime
import java.util.UUID
import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.flow.distinctUntilChanged
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.map

class PreferencesTaskRepository(
    private val dataStore: DataStore<Preferences>,
    private val validator: TaskValidator = TaskValidator(),
    private val clock: Clock = Clock.systemDefaultZone(),
    private val idFactory: () -> String = { UUID.randomUUID().toString() },
) : TaskRepository {
    private val codec = TaskStorageCodec()

    override fun observeTasks(): Flow<List<MomentumTask>> =
        dataStore.data
            .map { preferences -> codec.decode(preferences[TASKS_JSON_KEY]) }
            .catch { cause ->
                when (cause) {
                    is CancellationException -> throw cause
                    is MomentumStorageException -> throw cause
                    else -> throw TaskStorageReadException(cause)
                }
            }
            .distinctUntilChanged()

    override suspend fun listTasks(): List<MomentumTask> = observeTasks().first()

    override suspend fun initializeIfNeeded(): Boolean {
        var initializedByThisCall = false
        try {
            dataStore.edit { preferences ->
                if (preferences[INITIAL_SEED_COMPLETED_KEY] == true) return@edit

                val currentTasks = codec.decode(preferences[TASKS_JSON_KEY])
                val tasksToPersist = currentTasks.ifEmpty {
                    createDefaultSeed(
                        today = LocalDate.now(clock),
                        nowEpochMillis = clock.millis(),
                    )
                }
                preferences[TASKS_JSON_KEY] = codec.encode(tasksToPersist)
                preferences[INITIAL_SEED_COMPLETED_KEY] = true
                initializedByThisCall = true
            }
        } catch (cause: CancellationException) {
            throw cause
        } catch (cause: MomentumStorageException) {
            throw cause
        } catch (cause: Exception) {
            throw TaskStorageWriteException("initialisiert", cause)
        }
        return initializedByThisCall
    }

    override suspend fun create(draft: TaskDraft): MomentumTask {
        val validated = validator.validateOrThrow(draft)
        val now = clock.millis()
        val task =
            MomentumTask(
                id = idFactory(),
                title = validated.title,
                description = validated.description,
                category = validated.category,
                priority = validated.priority,
                dueDate = validated.dueDate,
                dueTime = validated.dueTime,
                isCompleted = false,
                completedOn = null,
                createdAtEpochMillis = now,
                updatedAtEpochMillis = now,
            )

        return mutateTasks(operation = "erstellt") { tasks ->
            if (tasks.any { it.id == task.id }) throw DuplicateTaskException(task.id)
            TaskMutation(tasks = tasks + task, result = task)
        }
    }

    override suspend fun update(taskId: String, draft: TaskDraft): MomentumTask {
        val validated = validator.validateOrThrow(draft)
        return mutateTasks(operation = "aktualisiert") { tasks ->
            val index = tasks.indexOfFirst { it.id == taskId }
            if (index == -1) throw TaskNotFoundException(taskId)

            val updated =
                tasks[index].copy(
                    title = validated.title,
                    description = validated.description,
                    category = validated.category,
                    priority = validated.priority,
                    dueDate = validated.dueDate,
                    dueTime = validated.dueTime,
                    updatedAtEpochMillis = maxOf(clock.millis(), tasks[index].createdAtEpochMillis),
                )
            TaskMutation(
                tasks = tasks.toMutableList().apply { this[index] = updated },
                result = updated,
            )
        }
    }

    override suspend fun delete(taskId: String): MomentumTask =
        mutateTasks(operation = "gelöscht") { tasks ->
            val deleted =
                tasks.firstOrNull { it.id == taskId } ?: throw TaskNotFoundException(taskId)
            TaskMutation(
                tasks = tasks.filterNot { it.id == taskId },
                result = deleted,
            )
        }

    override suspend fun restore(task: MomentumTask): MomentumTask =
        mutateTasks(operation = "wiederhergestellt") { tasks ->
            if (tasks.any { it.id == task.id }) throw DuplicateTaskException(task.id)
            TaskMutation(tasks = tasks + task, result = task)
        }

    override suspend fun setCompleted(taskId: String, completed: Boolean): MomentumTask =
        mutateTasks(operation = if (completed) "abgeschlossen" else "wieder geöffnet") { tasks ->
            val index = tasks.indexOfFirst { it.id == taskId }
            if (index == -1) throw TaskNotFoundException(taskId)
            val current = tasks[index]
            if (current.isCompleted == completed) {
                return@mutateTasks TaskMutation(tasks = tasks, result = current)
            }

            val updated =
                current.copy(
                    isCompleted = completed,
                    completedOn = if (completed) LocalDate.now(clock) else null,
                    updatedAtEpochMillis = maxOf(clock.millis(), current.createdAtEpochMillis),
                )
            TaskMutation(
                tasks = tasks.toMutableList().apply { this[index] = updated },
                result = updated,
            )
        }

    override suspend fun deleteAll() {
        try {
            dataStore.edit { preferences ->
                preferences[TASKS_JSON_KEY] = codec.encode(emptyList())
                // A deliberate reset must not cause the sample tasks to return on the next startup.
                preferences[INITIAL_SEED_COMPLETED_KEY] = true
            }
        } catch (cause: CancellationException) {
            throw cause
        } catch (cause: MomentumStorageException) {
            throw cause
        } catch (cause: Exception) {
            throw TaskStorageWriteException("gelöscht", cause)
        }
    }

    private suspend fun <T> mutateTasks(
        operation: String,
        mutation: (List<MomentumTask>) -> TaskMutation<T>,
    ): T {
        var outcome: TaskMutation<T>? = null
        try {
            dataStore.edit { preferences ->
                val currentTasks = codec.decode(preferences[TASKS_JSON_KEY])
                val next = mutation(currentTasks)
                preferences[TASKS_JSON_KEY] = codec.encode(next.tasks)
                outcome = next
            }
        } catch (cause: CancellationException) {
            throw cause
        } catch (cause: TaskRepositoryException) {
            throw cause
        } catch (cause: TaskValidationException) {
            throw cause
        } catch (cause: MomentumStorageException) {
            throw cause
        } catch (cause: Exception) {
            throw TaskStorageWriteException(operation, cause)
        }
        return checkNotNull(outcome) { "DataStore hat die Mutation '$operation' nicht ausgeführt." }
            .result
    }

    private fun createDefaultSeed(today: LocalDate, nowEpochMillis: Long): List<MomentumTask> =
        listOf(
            seedTask(
                id = "00000000-0000-4000-8000-000000000001",
                title = "Prioritäten für heute festlegen",
                description = "Die drei wichtigsten Ergebnisse für heute notieren.",
                category = TaskCategory.WORK,
                priority = TaskPriority.HIGH,
                dueDate = today,
                dueTime = LocalTime.of(9, 0),
                completedOn = today,
                nowEpochMillis = nowEpochMillis,
            ),
            seedTask(
                id = "00000000-0000-4000-8000-000000000002",
                title = "Posteingang leeren",
                description = null,
                category = TaskCategory.WORK,
                priority = TaskPriority.MEDIUM,
                dueDate = today.minusDays(1),
                dueTime = LocalTime.of(17, 30),
                completedOn = today.minusDays(1),
                nowEpochMillis = nowEpochMillis,
            ),
            seedTask(
                id = "00000000-0000-4000-8000-000000000003",
                title = "30 Minuten bewegen",
                description = "Spaziergang, Lauf oder eine kurze Trainingseinheit.",
                category = TaskCategory.HEALTH,
                priority = TaskPriority.HIGH,
                dueDate = today,
                dueTime = LocalTime.of(18, 0),
                completedOn = null,
                nowEpochMillis = nowEpochMillis,
            ),
            seedTask(
                id = "00000000-0000-4000-8000-000000000004",
                title = "Einkaufsliste vorbereiten",
                description = null,
                category = TaskCategory.PERSONAL,
                priority = TaskPriority.MEDIUM,
                dueDate = today,
                dueTime = null,
                completedOn = null,
                nowEpochMillis = nowEpochMillis,
            ),
            seedTask(
                id = "00000000-0000-4000-8000-000000000005",
                title = "Ein Kapitel lesen",
                description = "Den wichtigsten Gedanken anschließend kurz festhalten.",
                category = TaskCategory.LEARNING,
                priority = TaskPriority.LOW,
                dueDate = today,
                dueTime = LocalTime.of(20, 0),
                completedOn = null,
                nowEpochMillis = nowEpochMillis,
            ),
        )

    private fun seedTask(
        id: String,
        title: String,
        description: String?,
        category: TaskCategory,
        priority: TaskPriority,
        dueDate: LocalDate,
        dueTime: LocalTime?,
        completedOn: LocalDate?,
        nowEpochMillis: Long,
    ) =
        MomentumTask(
            id = id,
            title = title,
            description = description,
            category = category,
            priority = priority,
            dueDate = dueDate,
            dueTime = dueTime,
            isCompleted = completedOn != null,
            completedOn = completedOn,
            createdAtEpochMillis = nowEpochMillis,
            updatedAtEpochMillis = nowEpochMillis,
        )

    private data class TaskMutation<T>(
        val tasks: List<MomentumTask>,
        val result: T,
    )

    private companion object {
        val TASKS_JSON_KEY = stringPreferencesKey("tasks_json")
        val INITIAL_SEED_COMPLETED_KEY = booleanPreferencesKey("initial_seed_completed")
    }
}

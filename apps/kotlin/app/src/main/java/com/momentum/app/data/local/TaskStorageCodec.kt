package com.momentum.app.data.local

import com.momentum.app.data.error.TaskStorageDecodingException
import com.momentum.app.data.error.TaskStorageEncodingException
import com.momentum.app.domain.model.MomentumTask
import com.momentum.app.domain.model.TaskCategory
import com.momentum.app.domain.model.TaskPriority
import java.time.DateTimeException
import java.time.LocalDate
import java.time.LocalTime
import java.util.UUID
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlinx.serialization.SerializationException
import kotlinx.serialization.json.Json

class TaskStorageCodec(
    private val json: Json = Json {
        encodeDefaults = true
        ignoreUnknownKeys = true
    }
) {
    fun decode(rawValue: String?): List<MomentumTask> {
        if (rawValue == null) return emptyList()
        if (rawValue.isBlank()) {
            throw TaskStorageDecodingException("Der JSON-Inhalt ist leer.")
        }

        val payload =
            try {
                json.decodeFromString<StoredTaskPayload>(rawValue)
            } catch (cause: SerializationException) {
                throw TaskStorageDecodingException("Der JSON-Inhalt ist nicht lesbar.", cause)
            } catch (cause: IllegalArgumentException) {
                throw TaskStorageDecodingException(
                    "Der JSON-Inhalt enthält ungültige Werte.",
                    cause,
                )
            }

        if (payload.schemaVersion != CURRENT_SCHEMA_VERSION) {
            throw TaskStorageDecodingException(
                "Speicherversion ${payload.schemaVersion} wird nicht unterstützt " +
                    "(erwartet: $CURRENT_SCHEMA_VERSION)."
            )
        }

        val tasks =
            payload.tasks.mapIndexed { index, storedTask ->
                storedTask.toDomain(index)
            }
        val duplicateId =
            tasks.groupingBy(MomentumTask::id).eachCount().entries.firstOrNull { it.value > 1 }?.key
        if (duplicateId != null) {
            throw TaskStorageDecodingException("Die Aufgaben-ID '$duplicateId' kommt mehrfach vor.")
        }
        return tasks
    }

    fun encode(tasks: List<MomentumTask>): String {
        validateForEncoding(tasks)
        return try {
            json.encodeToString(
                StoredTaskPayload(
                    schemaVersion = CURRENT_SCHEMA_VERSION,
                    tasks = tasks.map { task -> task.toStored() },
                )
            )
        } catch (cause: SerializationException) {
            throw TaskStorageEncodingException(
                "Der JSON-Inhalt konnte nicht erzeugt werden.",
                cause,
            )
        } catch (cause: IllegalArgumentException) {
            throw TaskStorageEncodingException(
                "Eine Aufgabe enthält einen nicht speicherbaren Wert.",
                cause,
            )
        }
    }

    private fun StoredTask.toDomain(index: Int): MomentumTask =
        try {
            val task =
                MomentumTask(
                    id = id,
                    title = title,
                    description = description,
                    category = categoryKey.toCategory(),
                    priority = priorityKey.toPriority(),
                    dueDate = LocalDate.ofEpochDay(dueDateEpochDay),
                    dueTime =
                        dueTimeMinutes?.let { minutes ->
                            LocalTime.ofSecondOfDay(minutes.toLong() * SECONDS_PER_MINUTE)
                        },
                    isCompleted = isCompleted,
                    completedOn = completedOnEpochDay?.let(LocalDate::ofEpochDay),
                    createdAtEpochMillis = createdAtEpochMillis,
                    updatedAtEpochMillis = updatedAtEpochMillis,
                )
            validateTask(task, "Eintrag ${index + 1}")
            task
        } catch (cause: TaskStorageDecodingException) {
            throw cause
        } catch (cause: DateTimeException) {
            throw TaskStorageDecodingException(
                "Eintrag ${index + 1} enthält ein ungültiges Datum oder eine ungültige Uhrzeit.",
                cause,
            )
        } catch (cause: IllegalArgumentException) {
            throw TaskStorageDecodingException(
                "Eintrag ${index + 1} enthält ungültige Werte.",
                cause,
            )
        }

    private fun MomentumTask.toStored(): StoredTask =
        StoredTask(
            id = id,
            title = title,
            description = description,
            categoryKey = category.toStorageKey(),
            priorityKey = priority.toStorageKey(),
            dueDateEpochDay = dueDate.toEpochDay(),
            dueTimeMinutes = dueTime?.let { it.hour * MINUTES_PER_HOUR + it.minute },
            isCompleted = isCompleted,
            completedOnEpochDay = completedOn?.toEpochDay(),
            createdAtEpochMillis = createdAtEpochMillis,
            updatedAtEpochMillis = updatedAtEpochMillis,
        )

    private fun validateForEncoding(tasks: List<MomentumTask>) {
        val duplicateId =
            tasks.groupingBy(MomentumTask::id).eachCount().entries.firstOrNull { it.value > 1 }?.key
        if (duplicateId != null) {
            throw TaskStorageEncodingException("Die Aufgaben-ID '$duplicateId' kommt mehrfach vor.")
        }
        tasks.forEachIndexed { index, task ->
            try {
                validateTask(task, "Eintrag ${index + 1}")
            } catch (cause: IllegalArgumentException) {
                throw TaskStorageEncodingException(
                    cause.message ?: "Eintrag ${index + 1} ist ungültig.",
                    cause,
                )
            }
        }
    }

    private fun validateTask(task: MomentumTask, label: String) {
        try {
            UUID.fromString(task.id)
        } catch (cause: IllegalArgumentException) {
            throw IllegalArgumentException("$label besitzt keine gültige UUID.", cause)
        }
        require(task.title.isNotBlank()) { "$label besitzt keinen Titel." }
        require(task.title.length <= MAX_TITLE_LENGTH) { "$label besitzt einen zu langen Titel." }
        require(task.description == null || task.description.length <= MAX_DESCRIPTION_LENGTH) {
            "$label besitzt eine zu lange Beschreibung."
        }
        require(task.dueTime == null || (task.dueTime.second == 0 && task.dueTime.nano == 0)) {
            "$label besitzt eine Uhrzeit mit nicht speicherbaren Sekunden."
        }
        require(task.isCompleted == (task.completedOn != null)) {
            "$label besitzt einen widersprüchlichen Abschlussstatus."
        }
        require(task.updatedAtEpochMillis >= task.createdAtEpochMillis) {
            "$label wurde angeblich vor seiner Erstellung aktualisiert."
        }
    }

    private fun TaskCategory.toStorageKey(): String =
        when (this) {
            TaskCategory.WORK -> CATEGORY_WORK
            TaskCategory.PERSONAL -> CATEGORY_PERSONAL
            TaskCategory.HEALTH -> CATEGORY_HEALTH
            TaskCategory.LEARNING -> CATEGORY_LEARNING
        }

    private fun String.toCategory(): TaskCategory =
        when (this) {
            CATEGORY_WORK -> TaskCategory.WORK
            CATEGORY_PERSONAL -> TaskCategory.PERSONAL
            CATEGORY_HEALTH -> TaskCategory.HEALTH
            CATEGORY_LEARNING -> TaskCategory.LEARNING
            else -> throw TaskStorageDecodingException("Unbekannter Kategorieschlüssel '$this'.")
        }

    private fun TaskPriority.toStorageKey(): String =
        when (this) {
            TaskPriority.LOW -> PRIORITY_LOW
            TaskPriority.MEDIUM -> PRIORITY_MEDIUM
            TaskPriority.HIGH -> PRIORITY_HIGH
        }

    private fun String.toPriority(): TaskPriority =
        when (this) {
            PRIORITY_LOW -> TaskPriority.LOW
            PRIORITY_MEDIUM -> TaskPriority.MEDIUM
            PRIORITY_HIGH -> TaskPriority.HIGH
            else -> throw TaskStorageDecodingException("Unbekannter Prioritätsschlüssel '$this'.")
        }

    private companion object {
        const val CURRENT_SCHEMA_VERSION = 1
        const val MINUTES_PER_HOUR = 60
        const val SECONDS_PER_MINUTE = 60L
        const val MAX_TITLE_LENGTH = 80
        const val MAX_DESCRIPTION_LENGTH = 500

        const val CATEGORY_WORK = "work"
        const val CATEGORY_PERSONAL = "personal"
        const val CATEGORY_HEALTH = "health"
        const val CATEGORY_LEARNING = "learning"
        const val PRIORITY_LOW = "low"
        const val PRIORITY_MEDIUM = "medium"
        const val PRIORITY_HIGH = "high"
    }
}

@Serializable
private data class StoredTaskPayload(
    @SerialName("schema_version") val schemaVersion: Int,
    @SerialName("tasks") val tasks: List<StoredTask>,
)

@Serializable
private data class StoredTask(
    @SerialName("id") val id: String,
    @SerialName("title") val title: String,
    @SerialName("description") val description: String? = null,
    @SerialName("category") val categoryKey: String,
    @SerialName("priority") val priorityKey: String,
    @SerialName("due_date_epoch_day") val dueDateEpochDay: Long,
    @SerialName("due_time_minutes") val dueTimeMinutes: Int? = null,
    @SerialName("is_completed") val isCompleted: Boolean,
    @SerialName("completed_on_epoch_day") val completedOnEpochDay: Long? = null,
    @SerialName("created_at_epoch_millis") val createdAtEpochMillis: Long,
    @SerialName("updated_at_epoch_millis") val updatedAtEpochMillis: Long,
)

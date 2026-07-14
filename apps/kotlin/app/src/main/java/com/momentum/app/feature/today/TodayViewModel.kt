package com.momentum.app.feature.today

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewModelScope
import androidx.lifecycle.viewmodel.initializer
import androidx.lifecycle.viewmodel.viewModelFactory
import com.momentum.app.domain.logic.StreakCalculator
import com.momentum.app.domain.model.MomentumTask
import com.momentum.app.domain.model.TaskCategory
import com.momentum.app.domain.model.TaskPriority
import com.momentum.app.domain.repository.TaskRepository
import com.momentum.app.domain.repository.TaskRepositoryException
import java.io.IOException
import java.time.Clock
import java.time.LocalDate
import java.time.LocalTime
import java.time.format.DateTimeFormatter
import java.util.Locale
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.launch

sealed interface TodayUiState {
    data object Loading : TodayUiState

    data class Content(
        val greeting: String,
        val formattedDate: String,
        val tasks: List<MomentumTask>,
        val completedCount: Int,
        val progress: Float,
        val streakDays: Int,
        val categories: List<TodayCategorySummary>,
        val userMessage: String? = null,
    ) : TodayUiState {
        val taskCount: Int = tasks.size
    }

    data class Error(val message: String) : TodayUiState
}

data class TodayCategorySummary(
    val category: TaskCategory,
    val taskCount: Int,
    val completedCount: Int,
)

class TodayViewModel(
    private val taskRepository: TaskRepository,
    private val clock: Clock = Clock.systemDefaultZone(),
) : ViewModel() {
    private val _uiState = MutableStateFlow<TodayUiState>(TodayUiState.Loading)
    val uiState: StateFlow<TodayUiState> = _uiState.asStateFlow()

    private val pendingTaskIds = mutableSetOf<String>()
    private var observationJob: Job? = null

    init {
        observeTasks()
    }

    fun retry() {
        observeTasks()
    }

    fun setCompleted(taskId: String, completed: Boolean) {
        mutateTask(taskId, fallbackMessage = "Der Aufgabenstatus konnte nicht geändert werden.") {
            taskRepository.setCompleted(taskId, completed)
        }
    }

    fun deleteTask(taskId: String) {
        mutateTask(taskId, fallbackMessage = "Die Aufgabe konnte nicht gelöscht werden.") {
            taskRepository.delete(taskId)
        }
    }

    fun clearUserMessage() {
        val current = _uiState.value
        if (current is TodayUiState.Content && current.userMessage != null) {
            _uiState.value = current.copy(userMessage = null)
        }
    }

    private fun observeTasks() {
        observationJob?.cancel()
        observationJob = viewModelScope.launch {
            _uiState.value = TodayUiState.Loading
            taskRepository
                .observeTasks()
                .catch { error ->
                    _uiState.value = TodayUiState.Error(error.toUserMessage())
                }
                .collect { tasks ->
                    val retainedMessage = (_uiState.value as? TodayUiState.Content)?.userMessage
                    _uiState.value = tasks.toContentState(retainedMessage)
                }
        }
    }

    private fun mutateTask(
        taskId: String,
        fallbackMessage: String,
        mutation: suspend () -> Unit,
    ) {
        if (!pendingTaskIds.add(taskId)) return

        viewModelScope.launch {
            try {
                mutation()
            } catch (error: Exception) {
                val message =
                    when (error) {
                        is TaskRepositoryException -> error.message ?: fallbackMessage
                        is IOException -> "Die Änderung konnte nicht lokal gespeichert werden."
                        else -> fallbackMessage
                    }
                val current = _uiState.value
                _uiState.value =
                    if (current is TodayUiState.Content) {
                        current.copy(userMessage = message)
                    } else {
                        TodayUiState.Error(message)
                    }
            } finally {
                pendingTaskIds.remove(taskId)
            }
        }
    }

    private fun List<MomentumTask>.toContentState(userMessage: String?): TodayUiState.Content {
        val today = LocalDate.now(clock)
        val todayTasks =
            asSequence().filter { it.dueDate == today }.sortedWith(todayTaskComparator).toList()
        val completedCount = todayTasks.count(MomentumTask::isCompleted)
        val categorySummaries =
            TaskCategory.entries.map { category ->
                val categoryTasks = todayTasks.filter { it.category == category }
                TodayCategorySummary(
                    category = category,
                    taskCount = categoryTasks.size,
                    completedCount = categoryTasks.count(MomentumTask::isCompleted),
                )
            }

        return TodayUiState.Content(
            greeting = greetingFor(LocalTime.now(clock)),
            formattedDate =
                today.format(dayFormatter).replaceFirstChar { character ->
                    if (character.isLowerCase()) character.titlecase(Locale.GERMAN)
                    else character.toString()
                },
            tasks = todayTasks,
            completedCount = completedCount,
            progress = if (todayTasks.isEmpty()) 0f else completedCount.toFloat() / todayTasks.size,
            streakDays = StreakCalculator.currentStreak(this, today),
            categories = categorySummaries,
            userMessage = userMessage,
        )
    }

    private fun Throwable.toUserMessage(): String =
        when (this) {
            is TaskRepositoryException -> message ?: "Deine Aufgaben konnten nicht geladen werden."
            is IOException -> "Die lokal gespeicherten Aufgaben konnten nicht gelesen werden."
            else -> "Deine Aufgaben konnten nicht geladen werden. Bitte versuche es erneut."
        }

    companion object {
        private val dayFormatter = DateTimeFormatter.ofPattern("EEEE, d. MMMM", Locale.GERMAN)

        private val todayTaskComparator =
            compareBy<MomentumTask> { it.isCompleted }
                .thenBy { it.dueTime ?: LocalTime.MAX }
                .thenByDescending { it.priority.sortWeight }
                .thenBy { it.title.lowercase(Locale.GERMAN) }

        fun factory(
            taskRepository: TaskRepository,
            clock: Clock = Clock.systemDefaultZone(),
        ): ViewModelProvider.Factory = viewModelFactory {
            initializer { TodayViewModel(taskRepository, clock) }
        }

        internal fun greetingFor(time: LocalTime): String =
            when (time.hour) {
                in 5..10 -> "Guten Morgen"
                in 11..17 -> "Guten Tag"
                in 18..22 -> "Guten Abend"
                else -> "Hallo"
            }
    }
}

private val TaskPriority.sortWeight: Int
    get() =
        when (this) {
            TaskPriority.LOW -> 0
            TaskPriority.MEDIUM -> 1
            TaskPriority.HIGH -> 2
        }

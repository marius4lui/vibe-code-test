package com.momentum.app.feature.tasks

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewModelScope
import androidx.lifecycle.viewmodel.initializer
import androidx.lifecycle.viewmodel.viewModelFactory
import com.momentum.app.domain.logic.TaskFilter
import com.momentum.app.domain.logic.TaskFilterEngine
import com.momentum.app.domain.logic.TaskStatusFilter
import com.momentum.app.domain.model.MomentumTask
import com.momentum.app.domain.model.TaskCategory
import com.momentum.app.domain.model.TaskPriority
import com.momentum.app.domain.repository.TaskRepository
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.flatMapLatest
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch

sealed interface TasksUiState {
    data object Loading : TasksUiState

    data class Content(
        val tasks: List<MomentumTask>,
        val totalTaskCount: Int,
        val filter: TaskFilter,
    ) : TasksUiState {
        val hasActiveFilters: Boolean
            get() =
                filter.query.isNotBlank() ||
                    filter.status != TaskStatusFilter.ALL ||
                    filter.category != null ||
                    filter.priority != null

        val activeFilterCount: Int
            get() =
                listOf(
                        filter.status != TaskStatusFilter.ALL,
                        filter.category != null,
                        filter.priority != null,
                    )
                    .count { it }
    }

    data class Error(val message: String) : TasksUiState
}

@OptIn(ExperimentalCoroutinesApi::class)
class TasksViewModel(private val repository: TaskRepository) : ViewModel() {
    private val filter = MutableStateFlow(TaskFilter())
    private val retrySignal = MutableStateFlow(0)

    val uiState =
        retrySignal
            .flatMapLatest {
                combine(repository.observeTasks(), filter) { tasks, activeFilter ->
                        val filtered =
                            TaskFilterEngine.apply(tasks, activeFilter)
                                .sortedWith(
                                    compareBy<MomentumTask> { it.dueDate }
                                        .thenBy { it.isCompleted }
                                        .thenBy { it.dueTime == null }
                                        .thenBy { it.dueTime }
                                        .thenByDescending { it.priority }
                                )
                        TasksUiState.Content(
                            tasks = filtered,
                            totalTaskCount = tasks.size,
                            filter = activeFilter,
                        ) as TasksUiState
                    }
                    .catch { error ->
                        emit(
                            TasksUiState.Error(
                                error.userMessage("Aufgaben konnten nicht geladen werden.")
                            )
                        )
                    }
            }
            .stateIn(
                scope = viewModelScope,
                started = SharingStarted.WhileSubscribed(5_000),
                initialValue = TasksUiState.Loading,
            )

    fun setQuery(query: String) {
        filter.value = filter.value.copy(query = query)
    }

    fun setStatus(status: TaskStatusFilter) {
        filter.value = filter.value.copy(status = status)
    }

    fun setCategory(category: TaskCategory?) {
        filter.value = filter.value.copy(category = category)
    }

    fun setPriority(priority: TaskPriority?) {
        filter.value = filter.value.copy(priority = priority)
    }

    fun clearFilters() {
        filter.value = TaskFilter()
    }

    fun retry() {
        retrySignal.value += 1
    }

    fun toggle(
        task: MomentumTask,
        onError: (String) -> Unit,
    ) {
        viewModelScope.launch {
            runCatching { repository.setCompleted(task.id, !task.isCompleted) }
                .onFailure { onError(it.userMessage("Aufgabe konnte nicht aktualisiert werden.")) }
        }
    }

    fun delete(
        task: MomentumTask,
        onDeleted: (MomentumTask) -> Unit,
        onError: (String) -> Unit,
    ) {
        viewModelScope.launch {
            runCatching { repository.delete(task.id) }
                .onSuccess(onDeleted)
                .onFailure { onError(it.userMessage("Aufgabe konnte nicht gelöscht werden.")) }
        }
    }

    fun restore(
        task: MomentumTask,
        onError: (String) -> Unit,
    ) {
        viewModelScope.launch {
            runCatching { repository.restore(task) }
                .onFailure {
                    onError(it.userMessage("Aufgabe konnte nicht wiederhergestellt werden."))
                }
        }
    }

    companion object {
        fun factory(repository: TaskRepository): ViewModelProvider.Factory = viewModelFactory {
            initializer { TasksViewModel(repository) }
        }
    }
}

private fun Throwable.userMessage(fallback: String): String =
    message?.takeIf { it.isNotBlank() } ?: fallback

package com.momentum.app.feature.editor

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewModelScope
import androidx.lifecycle.viewmodel.initializer
import androidx.lifecycle.viewmodel.viewModelFactory
import com.momentum.app.domain.model.MomentumTask
import com.momentum.app.domain.model.TaskCategory
import com.momentum.app.domain.model.TaskDraft
import com.momentum.app.domain.model.TaskPriority
import com.momentum.app.domain.repository.TaskRepository
import com.momentum.app.domain.validation.TaskField
import com.momentum.app.domain.validation.TaskValidationError
import com.momentum.app.domain.validation.TaskValidator
import java.time.LocalDate
import java.time.LocalTime
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

sealed interface TaskEditorUiState {
    data object Loading : TaskEditorUiState

    data class Ready(
        val title: String = "",
        val description: String = "",
        val category: TaskCategory? = null,
        val priority: TaskPriority = TaskPriority.MEDIUM,
        val dueDate: LocalDate = LocalDate.now(),
        val dueTime: LocalTime? = null,
        val errors: Map<TaskField, TaskValidationError> = emptyMap(),
        val validationAttempt: Int = 0,
        val isSaving: Boolean = false,
        val isDirty: Boolean = false,
        val isEditMode: Boolean = false,
    ) : TaskEditorUiState

    data class Error(val message: String) : TaskEditorUiState
}

class TaskEditorViewModel(
    private val repository: TaskRepository,
    private val taskId: String?,
    private val validator: TaskValidator = TaskValidator(),
) : ViewModel() {
    private val _uiState = MutableStateFlow<TaskEditorUiState>(TaskEditorUiState.Loading)
    val uiState = _uiState.asStateFlow()

    init {
        load()
    }

    fun load() {
        if (taskId == null) {
            _uiState.value = TaskEditorUiState.Ready()
            return
        }
        _uiState.value = TaskEditorUiState.Loading
        viewModelScope.launch {
            runCatching { repository.listTasks().firstOrNull { it.id == taskId } }
                .onSuccess { task ->
                    _uiState.value =
                        if (task == null) {
                            TaskEditorUiState.Error("Diese Aufgabe wurde nicht gefunden.")
                        } else {
                            TaskEditorUiState.Ready(
                                title = task.title,
                                description = task.description.orEmpty(),
                                category = task.category,
                                priority = task.priority,
                                dueDate = task.dueDate,
                                dueTime = task.dueTime,
                                isEditMode = true,
                            )
                        }
                }
                .onFailure { error ->
                    _uiState.value =
                        TaskEditorUiState.Error(
                            error.message ?: "Aufgabe konnte nicht geladen werden."
                        )
                }
        }
    }

    fun setTitle(value: String) = update(TaskField.TITLE) { copy(title = value) }

    fun setDescription(value: String) = update(TaskField.DESCRIPTION) { copy(description = value) }

    fun setCategory(value: TaskCategory) = update(TaskField.CATEGORY) { copy(category = value) }

    fun setPriority(value: TaskPriority) = update(TaskField.PRIORITY) { copy(priority = value) }

    fun setDueDate(value: LocalDate) = update(TaskField.DUE_DATE) { copy(dueDate = value) }

    fun setDueTime(value: LocalTime?) = update(null) { copy(dueTime = value) }

    fun save(
        onSuccess: (MomentumTask) -> Unit,
        onError: (String) -> Unit,
        onValidationError: (String) -> Unit,
    ) {
        val state = _uiState.value as? TaskEditorUiState.Ready ?: return
        val draft = state.toDraft()
        val validation = validator.validate(draft)
        if (!validation.isValid) {
            _uiState.value =
                state.copy(
                    errors = validation.errors.associateBy(TaskValidationError::field),
                    validationAttempt = state.validationAttempt + 1,
                )
            onValidationError("Bitte prüfe die markierten Felder.")
            return
        }

        _uiState.value = state.copy(isSaving = true, errors = emptyMap())
        viewModelScope.launch {
            runCatching {
                    if (taskId == null) repository.create(draft)
                    else repository.update(taskId, draft)
                }
                .onSuccess { task ->
                    val current = _uiState.value as? TaskEditorUiState.Ready
                    if (current != null)
                        _uiState.value = current.copy(isSaving = false, isDirty = false)
                    onSuccess(task)
                }
                .onFailure { error ->
                    val current = _uiState.value as? TaskEditorUiState.Ready
                    if (current != null) _uiState.value = current.copy(isSaving = false)
                    onError(error.message ?: "Aufgabe konnte nicht gespeichert werden.")
                }
        }
    }

    fun delete(
        onSuccess: (MomentumTask) -> Unit,
        onError: (String) -> Unit,
    ) {
        val id = taskId ?: return
        val state = _uiState.value as? TaskEditorUiState.Ready ?: return
        _uiState.value = state.copy(isSaving = true)
        viewModelScope.launch {
            runCatching { repository.delete(id) }
                .onSuccess(onSuccess)
                .onFailure { error ->
                    _uiState.value = state.copy(isSaving = false)
                    onError(error.message ?: "Aufgabe konnte nicht gelöscht werden.")
                }
        }
    }

    private fun update(
        field: TaskField?,
        transform: TaskEditorUiState.Ready.() -> TaskEditorUiState.Ready,
    ) {
        val state = _uiState.value as? TaskEditorUiState.Ready ?: return
        val updatedErrors = if (field == null) state.errors else state.errors - field
        _uiState.value = state.transform().copy(errors = updatedErrors, isDirty = true)
    }

    companion object {
        fun factory(
            repository: TaskRepository,
            taskId: String?,
        ): ViewModelProvider.Factory = viewModelFactory {
            initializer { TaskEditorViewModel(repository, taskId) }
        }
    }
}

private fun TaskEditorUiState.Ready.toDraft() =
    TaskDraft(
        title = title,
        description = description,
        category = category,
        priority = priority,
        dueDate = dueDate,
        dueTime = dueTime,
    )

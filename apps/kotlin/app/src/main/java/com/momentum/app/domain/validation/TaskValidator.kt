package com.momentum.app.domain.validation

import com.momentum.app.domain.model.TaskDraft
import com.momentum.app.domain.model.ValidatedTaskDraft

enum class TaskField {
    TITLE,
    DESCRIPTION,
    CATEGORY,
    PRIORITY,
    DUE_DATE,
}

enum class TaskValidationCode {
    REQUIRED,
    TOO_LONG,
}

data class TaskValidationError(
    val field: TaskField,
    val code: TaskValidationCode,
    val message: String,
)

data class TaskValidationResult(
    val value: ValidatedTaskDraft?,
    val errors: List<TaskValidationError>,
) {
    val isValid: Boolean
        get() = errors.isEmpty()

    fun errorFor(field: TaskField): TaskValidationError? = errors.firstOrNull { it.field == field }
}

class TaskValidationException(val validationErrors: List<TaskValidationError>) :
    IllegalArgumentException(
        validationErrors.joinToString(
            prefix = "Ungültige Aufgabe: ",
            separator = "; ",
            transform = TaskValidationError::message,
        )
    )

class TaskValidator {
    fun validate(draft: TaskDraft): TaskValidationResult {
        val title = draft.title?.trim().orEmpty()
        val description = draft.description?.trim()?.takeIf(String::isNotEmpty)
        val errors = buildList {
            if (title.isEmpty()) {
                add(
                    TaskValidationError(
                        TaskField.TITLE,
                        TaskValidationCode.REQUIRED,
                        "Bitte gib einen Titel ein.",
                    )
                )
            } else if (title.length > MAX_TITLE_LENGTH) {
                add(
                    TaskValidationError(
                        TaskField.TITLE,
                        TaskValidationCode.TOO_LONG,
                        "Der Titel darf höchstens $MAX_TITLE_LENGTH Zeichen lang sein.",
                    )
                )
            }

            if (description != null && description.length > MAX_DESCRIPTION_LENGTH) {
                add(
                    TaskValidationError(
                        TaskField.DESCRIPTION,
                        TaskValidationCode.TOO_LONG,
                        "Die Beschreibung darf höchstens $MAX_DESCRIPTION_LENGTH Zeichen lang sein.",
                    )
                )
            }

            if (draft.category == null) {
                add(
                    TaskValidationError(
                        TaskField.CATEGORY,
                        TaskValidationCode.REQUIRED,
                        "Bitte wähle eine Kategorie.",
                    )
                )
            }
            if (draft.priority == null) {
                add(
                    TaskValidationError(
                        TaskField.PRIORITY,
                        TaskValidationCode.REQUIRED,
                        "Bitte wähle eine Priorität.",
                    )
                )
            }
            if (draft.dueDate == null) {
                add(
                    TaskValidationError(
                        TaskField.DUE_DATE,
                        TaskValidationCode.REQUIRED,
                        "Bitte wähle ein Datum.",
                    )
                )
            }
        }

        val value =
            if (errors.isEmpty()) {
                ValidatedTaskDraft(
                    title = title,
                    description = description,
                    category = requireNotNull(draft.category),
                    priority = requireNotNull(draft.priority),
                    dueDate = requireNotNull(draft.dueDate),
                    dueTime = draft.dueTime?.withSecond(0)?.withNano(0),
                )
            } else {
                null
            }

        return TaskValidationResult(value = value, errors = errors)
    }

    fun validateOrThrow(draft: TaskDraft): ValidatedTaskDraft {
        val result = validate(draft)
        return result.value ?: throw TaskValidationException(result.errors)
    }

    companion object {
        const val MAX_TITLE_LENGTH = 80
        const val MAX_DESCRIPTION_LENGTH = 500
    }
}

package com.momentum.app.domain.model

import java.time.LocalDate
import java.time.LocalTime

data class TaskDraft(
    val title: String? = null,
    val description: String? = null,
    val category: TaskCategory? = null,
    val priority: TaskPriority? = null,
    val dueDate: LocalDate? = null,
    val dueTime: LocalTime? = null,
)

data class ValidatedTaskDraft(
    val title: String,
    val description: String?,
    val category: TaskCategory,
    val priority: TaskPriority,
    val dueDate: LocalDate,
    val dueTime: LocalTime?,
)

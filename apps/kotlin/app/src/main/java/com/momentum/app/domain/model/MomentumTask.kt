package com.momentum.app.domain.model

import java.time.LocalDate
import java.time.LocalTime

data class MomentumTask(
    val id: String,
    val title: String,
    val description: String?,
    val category: TaskCategory,
    val priority: TaskPriority,
    val dueDate: LocalDate,
    val dueTime: LocalTime?,
    val isCompleted: Boolean,
    val completedOn: LocalDate?,
    val createdAtEpochMillis: Long,
    val updatedAtEpochMillis: Long,
)

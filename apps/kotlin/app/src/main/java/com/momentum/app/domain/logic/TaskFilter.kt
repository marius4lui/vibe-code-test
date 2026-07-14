package com.momentum.app.domain.logic

import com.momentum.app.domain.model.MomentumTask
import com.momentum.app.domain.model.TaskCategory
import com.momentum.app.domain.model.TaskPriority

enum class TaskStatusFilter {
    ALL,
    OPEN,
    COMPLETED,
}

data class TaskFilter(
    val query: String = "",
    val status: TaskStatusFilter = TaskStatusFilter.ALL,
    val category: TaskCategory? = null,
    val priority: TaskPriority? = null,
)

object TaskFilterEngine {
    fun apply(tasks: List<MomentumTask>, filter: TaskFilter): List<MomentumTask> {
        val query = filter.query.trim()
        return tasks.filter { task ->
            matchesQuery(task, query) &&
                matchesStatus(task, filter.status) &&
                (filter.category == null || task.category == filter.category) &&
                (filter.priority == null || task.priority == filter.priority)
        }
    }

    private fun matchesQuery(task: MomentumTask, query: String): Boolean =
        query.isEmpty() ||
            task.title.contains(query, ignoreCase = true) ||
            task.description?.contains(query, ignoreCase = true) == true

    private fun matchesStatus(task: MomentumTask, status: TaskStatusFilter): Boolean =
        when (status) {
            TaskStatusFilter.ALL -> true
            TaskStatusFilter.OPEN -> !task.isCompleted
            TaskStatusFilter.COMPLETED -> task.isCompleted
        }
}

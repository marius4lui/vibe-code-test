package com.momentum.app.domain.logic

import com.momentum.app.domain.model.MomentumTask
import com.momentum.app.domain.model.TaskCategory
import com.momentum.app.domain.model.TaskPriority
import java.time.LocalDate
import org.junit.Assert.assertEquals
import org.junit.Test

class TaskFilterEngineTest {
    private val today = LocalDate.of(2026, 7, 14)

    @Test
    fun `query status category and priority are combined`() {
        val matching =
            task(
                id = "00000000-0000-4000-8000-000000000001",
                title = "Planung",
                description = "Kundenprojekt Momentum",
                category = TaskCategory.WORK,
                priority = TaskPriority.HIGH,
                completed = false,
            )
        val tasks =
            listOf(
                matching,
                task(
                    id = "00000000-0000-4000-8000-000000000002",
                    title = "Momentum Workout",
                    category = TaskCategory.HEALTH,
                    priority = TaskPriority.HIGH,
                    completed = false,
                ),
                task(
                    id = "00000000-0000-4000-8000-000000000003",
                    title = "Momentum Review",
                    category = TaskCategory.WORK,
                    priority = TaskPriority.HIGH,
                    completed = true,
                ),
                task(
                    id = "00000000-0000-4000-8000-000000000004",
                    title = "Momentum Ablage",
                    category = TaskCategory.WORK,
                    priority = TaskPriority.LOW,
                    completed = false,
                ),
            )

        val result =
            TaskFilterEngine.apply(
                tasks,
                TaskFilter(
                    query = "  momentum ",
                    status = TaskStatusFilter.OPEN,
                    category = TaskCategory.WORK,
                    priority = TaskPriority.HIGH,
                ),
            )

        assertEquals(listOf(matching), result)
    }

    @Test
    fun `empty filter preserves repository order`() {
        val tasks =
            listOf(
                task("00000000-0000-4000-8000-000000000001", "Zweite"),
                task("00000000-0000-4000-8000-000000000002", "Erste"),
            )

        assertEquals(tasks, TaskFilterEngine.apply(tasks, TaskFilter()))
    }

    private fun task(
        id: String,
        title: String,
        description: String? = null,
        category: TaskCategory = TaskCategory.PERSONAL,
        priority: TaskPriority = TaskPriority.MEDIUM,
        completed: Boolean = false,
    ) =
        MomentumTask(
            id = id,
            title = title,
            description = description,
            category = category,
            priority = priority,
            dueDate = today,
            dueTime = null,
            isCompleted = completed,
            completedOn = if (completed) today else null,
            createdAtEpochMillis = 1L,
            updatedAtEpochMillis = 1L,
        )
}

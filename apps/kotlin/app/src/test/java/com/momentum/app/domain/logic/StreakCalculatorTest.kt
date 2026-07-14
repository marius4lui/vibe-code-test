package com.momentum.app.domain.logic

import com.momentum.app.domain.model.MomentumTask
import com.momentum.app.domain.model.TaskCategory
import com.momentum.app.domain.model.TaskPriority
import java.time.LocalDate
import org.junit.Assert.assertEquals
import org.junit.Test

class StreakCalculatorTest {
    private val today = LocalDate.of(2026, 7, 14)

    @Test
    fun `today and consecutive previous days form streak`() {
        val tasks =
            listOf(
                completedTask("00000000-0000-4000-8000-000000000001", today),
                completedTask("00000000-0000-4000-8000-000000000002", today.minusDays(1)),
                completedTask("00000000-0000-4000-8000-000000000003", today.minusDays(2)),
                completedTask("00000000-0000-4000-8000-000000000004", today.minusDays(4)),
            )

        assertEquals(3, StreakCalculator.currentStreak(tasks, today))
    }

    @Test
    fun `unfinished current day does not break yesterdays streak`() {
        val tasks =
            listOf(
                completedTask("00000000-0000-4000-8000-000000000001", today.minusDays(1)),
                completedTask("00000000-0000-4000-8000-000000000002", today.minusDays(2)),
            )

        assertEquals(2, StreakCalculator.currentStreak(tasks, today))
    }

    @Test
    fun `gap before yesterday yields zero`() {
        val tasks =
            listOf(completedTask("00000000-0000-4000-8000-000000000001", today.minusDays(2)))

        assertEquals(0, StreakCalculator.currentStreak(tasks, today))
    }

    private fun completedTask(id: String, completedOn: LocalDate) =
        MomentumTask(
            id = id,
            title = "Erledigt",
            description = null,
            category = TaskCategory.PERSONAL,
            priority = TaskPriority.MEDIUM,
            dueDate = completedOn,
            dueTime = null,
            isCompleted = true,
            completedOn = completedOn,
            createdAtEpochMillis = 1L,
            updatedAtEpochMillis = 1L,
        )
}

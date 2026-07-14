package com.momentum.app.domain.logic

import com.momentum.app.domain.model.MomentumTask
import java.time.LocalDate

object StreakCalculator {
    /**
     * Counts consecutive local calendar days with at least one completed task. A day that is still
     * in progress does not break yesterday's streak.
     */
    fun currentStreak(tasks: List<MomentumTask>, today: LocalDate): Int {
        val completionDays =
            tasks
                .asSequence()
                .filter(MomentumTask::isCompleted)
                .mapNotNull(MomentumTask::completedOn)
                .filterNot { it.isAfter(today) }
                .toHashSet()

        if (completionDays.isEmpty()) return 0

        var day = if (today in completionDays) today else today.minusDays(1)
        var streak = 0
        while (day in completionDays) {
            streak += 1
            day = day.minusDays(1)
        }
        return streak
    }
}

package com.momentum.app.ui.util

import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.luminance
import com.momentum.app.domain.model.MomentumTask
import com.momentum.app.domain.model.TaskCategory
import com.momentum.app.domain.model.TaskPriority
import java.time.LocalDate
import java.time.format.DateTimeFormatter
import java.time.format.FormatStyle
import java.util.Locale

val TaskCategory.label: String
    get() =
        when (this) {
            TaskCategory.WORK -> "Arbeit"
            TaskCategory.PERSONAL -> "Persönlich"
            TaskCategory.HEALTH -> "Gesundheit"
            TaskCategory.LEARNING -> "Lernen"
        }

val TaskCategory.symbol: String
    get() =
        when (this) {
            TaskCategory.WORK -> "W"
            TaskCategory.PERSONAL -> "P"
            TaskCategory.HEALTH -> "G"
            TaskCategory.LEARNING -> "L"
        }

val TaskPriority.label: String
    get() =
        when (this) {
            TaskPriority.LOW -> "Niedrig"
            TaskPriority.MEDIUM -> "Mittel"
            TaskPriority.HIGH -> "Hoch"
        }

val TaskPriority.symbol: String
    get() =
        when (this) {
            TaskPriority.LOW -> "↓"
            TaskPriority.MEDIUM -> "–"
            TaskPriority.HIGH -> "!"
        }

data class SemanticColors(
    val foreground: Color,
    val container: Color,
)

@Composable
fun categoryColors(category: TaskCategory): SemanticColors {
    val dark = androidx.compose.material3.MaterialTheme.colorScheme.background.luminance() < 0.35f
    return when (category) {
        TaskCategory.WORK ->
            if (dark) {
                SemanticColors(Color(0xFFA8CDF0), Color(0xFF173C59))
            } else {
                SemanticColors(Color(0xFF245477), Color(0xFFD9EAF8))
            }
        TaskCategory.PERSONAL ->
            if (dark) {
                SemanticColors(Color(0xFFD9BCEC), Color(0xFF49315A))
            } else {
                SemanticColors(Color(0xFF68487E), Color(0xFFEEDDF7))
            }
        TaskCategory.HEALTH ->
            if (dark) {
                SemanticColors(Color(0xFFA5D8BD), Color(0xFF1C4938))
            } else {
                SemanticColors(Color(0xFF2F654E), Color(0xFFD8EFE2))
            }
        TaskCategory.LEARNING ->
            if (dark) {
                SemanticColors(Color(0xFFF2C77B), Color(0xFF503B13))
            } else {
                SemanticColors(Color(0xFF775113), Color(0xFFF9E7C4))
            }
    }
}

@Composable
fun priorityColors(priority: TaskPriority): SemanticColors {
    val scheme = androidx.compose.material3.MaterialTheme.colorScheme
    return when (priority) {
        TaskPriority.LOW ->
            SemanticColors(
                foreground = categoryColors(TaskCategory.WORK).foreground,
                container = categoryColors(TaskCategory.WORK).container,
            )
        TaskPriority.MEDIUM ->
            SemanticColors(
                foreground = categoryColors(TaskCategory.LEARNING).foreground,
                container = categoryColors(TaskCategory.LEARNING).container,
            )
        TaskPriority.HIGH ->
            SemanticColors(
                foreground = scheme.onErrorContainer,
                container = scheme.errorContainer,
            )
    }
}

private val localizedDateFormatter: DateTimeFormatter
    get() = DateTimeFormatter.ofLocalizedDate(FormatStyle.MEDIUM).withLocale(Locale.getDefault())

private val localizedTimeFormatter: DateTimeFormatter
    get() = DateTimeFormatter.ofPattern("HH:mm", Locale.getDefault())

fun LocalDate.relativeLabel(today: LocalDate = LocalDate.now()): String =
    when (this) {
        today -> "Heute"
        today.plusDays(1) -> "Morgen"
        today.minusDays(1) -> "Gestern"
        else -> format(localizedDateFormatter)
    }

fun MomentumTask.scheduleLabel(today: LocalDate = LocalDate.now()): String {
    val date = dueDate.relativeLabel(today)
    return dueTime?.let { "$date · ${it.format(localizedTimeFormatter)} Uhr" } ?: date
}

fun MomentumTask.timeLabel(): String? = dueTime?.let { "${it.format(localizedTimeFormatter)} Uhr" }

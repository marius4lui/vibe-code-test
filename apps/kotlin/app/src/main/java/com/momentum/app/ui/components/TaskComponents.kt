package com.momentum.app.ui.components

import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.animateContentSize
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.togetherWith
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.FlowRow
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.Edit
import androidx.compose.material.icons.filled.MoreVert
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Checkbox
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedCard
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.heading
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.semantics.stateDescription
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextDecoration
import androidx.compose.ui.unit.dp
import com.momentum.app.domain.model.MomentumTask
import com.momentum.app.domain.model.TaskCategory
import com.momentum.app.domain.model.TaskPriority
import com.momentum.app.ui.util.categoryColors
import com.momentum.app.ui.util.label
import com.momentum.app.ui.util.priorityColors
import com.momentum.app.ui.util.scheduleLabel
import com.momentum.app.ui.util.symbol

@Composable
fun SectionHeader(
    title: String,
    modifier: Modifier = Modifier,
    actionLabel: String? = null,
    onAction: (() -> Unit)? = null,
) {
    Row(
        modifier = modifier.fillMaxWidth(),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.SpaceBetween,
    ) {
        Text(
            text = title,
            modifier = Modifier.semantics { heading() },
            style = MaterialTheme.typography.titleLarge,
            fontWeight = FontWeight.SemiBold,
        )
        if (actionLabel != null && onAction != null) {
            TextButton(onClick = onAction) { Text(actionLabel) }
        }
    }
}

@Composable
fun CategoryPill(
    category: TaskCategory,
    modifier: Modifier = Modifier,
) {
    val colors = categoryColors(category)
    Surface(
        modifier = modifier,
        color = colors.container,
        contentColor = colors.foreground,
        shape = MaterialTheme.shapes.extraLarge,
    ) {
        Text(
            text = "${category.symbol}  ${category.label}",
            modifier = Modifier.padding(horizontal = 10.dp, vertical = 5.dp),
            style = MaterialTheme.typography.labelMedium,
            fontWeight = FontWeight.SemiBold,
        )
    }
}

@Composable
fun PriorityBadge(
    priority: TaskPriority,
    modifier: Modifier = Modifier,
) {
    val colors = priorityColors(priority)
    Surface(
        modifier = modifier,
        color = colors.container,
        contentColor = colors.foreground,
        shape = MaterialTheme.shapes.extraLarge,
    ) {
        Text(
            text = "${priority.symbol}  ${priority.label}",
            modifier = Modifier.padding(horizontal = 10.dp, vertical = 5.dp),
            style = MaterialTheme.typography.labelMedium,
            fontWeight = FontWeight.SemiBold,
        )
    }
}

@Composable
fun TaskCard(
    task: MomentumTask,
    onToggle: () -> Unit,
    onEdit: () -> Unit,
    onDelete: () -> Unit,
    modifier: Modifier = Modifier,
    showDate: Boolean = true,
) {
    var menuExpanded by remember { mutableStateOf(false) }

    OutlinedCard(
        modifier =
            modifier
                .fillMaxWidth()
                .animateContentSize(animationSpec = tween(180))
                .clickable(onClick = onEdit)
    ) {
        Row(
            modifier =
                Modifier.fillMaxWidth()
                    .padding(start = 4.dp, top = 10.dp, end = 4.dp, bottom = 10.dp),
            verticalAlignment = Alignment.Top,
        ) {
            Checkbox(
                checked = task.isCompleted,
                onCheckedChange = { onToggle() },
                modifier =
                    Modifier.size(48.dp).testTag("task_checkbox_${task.id}").semantics {
                        contentDescription =
                            if (task.isCompleted) {
                                "${task.title} erneut öffnen"
                            } else {
                                "${task.title} abschließen"
                            }
                        stateDescription = if (task.isCompleted) "Erledigt" else "Offen"
                    },
            )
            Column(modifier = Modifier.weight(1f).padding(top = 3.dp, bottom = 3.dp)) {
                AnimatedContent(
                    targetState = task.isCompleted,
                    transitionSpec = { fadeIn(tween(180)) togetherWith fadeOut(tween(120)) },
                    label = "task-completion",
                ) { completed ->
                    Text(
                        text = task.title,
                        style = MaterialTheme.typography.titleMedium,
                        color =
                            if (completed) {
                                MaterialTheme.colorScheme.onSurfaceVariant
                            } else {
                                MaterialTheme.colorScheme.onSurface
                            },
                        textDecoration = if (completed) TextDecoration.LineThrough else null,
                        maxLines = 2,
                    )
                }
                if (showDate) {
                    Spacer(Modifier.height(4.dp))
                    Text(
                        text = task.scheduleLabel(),
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                    )
                }
                Spacer(Modifier.height(10.dp))
                FlowRow(
                    horizontalArrangement = Arrangement.spacedBy(8.dp),
                    verticalArrangement = Arrangement.spacedBy(6.dp),
                ) {
                    CategoryPill(task.category)
                    PriorityBadge(task.priority)
                }
            }
            Box {
                IconButton(
                    onClick = { menuExpanded = true },
                    modifier = Modifier.testTag("task_overflow_${task.id}"),
                ) {
                    Icon(
                        Icons.Default.MoreVert,
                        contentDescription = "Weitere Aktionen für ${task.title}",
                    )
                }
                DropdownMenu(
                    expanded = menuExpanded,
                    onDismissRequest = { menuExpanded = false },
                ) {
                    DropdownMenuItem(
                        text = { Text("Bearbeiten") },
                        leadingIcon = { Icon(Icons.Default.Edit, contentDescription = null) },
                        onClick = {
                            menuExpanded = false
                            onEdit()
                        },
                    )
                    DropdownMenuItem(
                        text = { Text("Löschen") },
                        leadingIcon = { Icon(Icons.Default.Delete, contentDescription = null) },
                        onClick = {
                            menuExpanded = false
                            onDelete()
                        },
                    )
                }
            }
        }
    }
}

@Composable
fun DeleteTaskDialog(
    taskTitle: String,
    onConfirm: () -> Unit,
    onDismiss: () -> Unit,
) {
    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text("Aufgabe löschen?") },
        text = { Text("„$taskTitle“ wird dauerhaft aus deiner Liste entfernt.") },
        confirmButton = {
            TextButton(onClick = onConfirm) {
                Text("Löschen", color = MaterialTheme.colorScheme.error)
            }
        },
        dismissButton = { TextButton(onClick = onDismiss) { Text("Abbrechen") } },
    )
}

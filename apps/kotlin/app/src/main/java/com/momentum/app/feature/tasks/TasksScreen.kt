package com.momentum.app.feature.tasks

import androidx.compose.foundation.horizontalScroll
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.widthIn
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.rememberScrollState
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.Search
import androidx.compose.material3.AssistChip
import androidx.compose.material3.CenterAlignedTopAppBar
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.FilterChip
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarDuration
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.SnackbarResult
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.semantics.heading
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.momentum.app.domain.logic.TaskStatusFilter
import com.momentum.app.domain.model.MomentumTask
import com.momentum.app.domain.model.TaskCategory
import com.momentum.app.domain.model.TaskPriority
import com.momentum.app.ui.components.DeleteTaskDialog
import com.momentum.app.ui.components.EmptyState
import com.momentum.app.ui.components.ErrorState
import com.momentum.app.ui.components.LoadingState
import com.momentum.app.ui.components.TaskCard
import com.momentum.app.ui.util.label
import java.time.LocalDate
import kotlinx.coroutines.launch

private data class TaskGroup(
    val label: String,
    val tasks: List<MomentumTask>,
)

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun TasksScreen(
    viewModel: TasksViewModel,
    onAddTask: () -> Unit,
    onEditTask: (String) -> Unit,
    snackbarHostState: SnackbarHostState,
    modifier: Modifier = Modifier,
) {
    val state by viewModel.uiState.collectAsStateWithLifecycle()
    val scope = rememberCoroutineScope()
    var pendingDelete by remember { mutableStateOf<MomentumTask?>(null) }

    fun showError(message: String) {
        scope.launch { snackbarHostState.showSnackbar(message) }
    }

    Scaffold(
        modifier = modifier,
        topBar = {
            CenterAlignedTopAppBar(title = { Text("Aufgaben", fontWeight = FontWeight.Bold) })
        },
    ) { innerPadding ->
        when (val current = state) {
            TasksUiState.Loading -> LoadingState(Modifier.padding(innerPadding))
            is TasksUiState.Error ->
                ErrorState(
                    message = current.message,
                    onRetry = viewModel::retry,
                    modifier = Modifier.padding(innerPadding),
                )
            is TasksUiState.Content ->
                TasksContent(
                    state = current,
                    onQueryChange = viewModel::setQuery,
                    onStatusChange = viewModel::setStatus,
                    onCategoryChange = viewModel::setCategory,
                    onPriorityChange = viewModel::setPriority,
                    onClearFilters = viewModel::clearFilters,
                    onAddTask = onAddTask,
                    onToggle = { task -> viewModel.toggle(task, ::showError) },
                    onEditTask = onEditTask,
                    onDelete = { pendingDelete = it },
                    modifier = Modifier.padding(innerPadding),
                )
        }
    }

    pendingDelete?.let { task ->
        DeleteTaskDialog(
            taskTitle = task.title,
            onDismiss = { pendingDelete = null },
            onConfirm = {
                pendingDelete = null
                viewModel.delete(
                    task = task,
                    onError = ::showError,
                    onDeleted = { deleted ->
                        scope.launch {
                            val result =
                                snackbarHostState.showSnackbar(
                                    message = "Aufgabe gelöscht",
                                    actionLabel = "Rückgängig",
                                    duration = SnackbarDuration.Long,
                                )
                            if (result == SnackbarResult.ActionPerformed) {
                                viewModel.restore(deleted, ::showError)
                            }
                        }
                    },
                )
            },
        )
    }
}

@Composable
private fun TasksContent(
    state: TasksUiState.Content,
    onQueryChange: (String) -> Unit,
    onStatusChange: (TaskStatusFilter) -> Unit,
    onCategoryChange: (TaskCategory?) -> Unit,
    onPriorityChange: (TaskPriority?) -> Unit,
    onClearFilters: () -> Unit,
    onAddTask: () -> Unit,
    onToggle: (MomentumTask) -> Unit,
    onEditTask: (String) -> Unit,
    onDelete: (MomentumTask) -> Unit,
    modifier: Modifier = Modifier,
) {
    val groups = remember(state.tasks) { state.tasks.toGroups(LocalDate.now()) }
    Box(modifier = modifier.fillMaxSize(), contentAlignment = Alignment.TopCenter) {
        LazyColumn(
            modifier = Modifier.widthIn(max = 760.dp).fillMaxSize(),
            contentPadding = PaddingValues(start = 16.dp, top = 8.dp, end = 16.dp, bottom = 104.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp),
        ) {
            item(key = "search_and_filters") {
                Column {
                    Text(
                        text = "${state.totalTaskCount} Aufgaben insgesamt",
                        style = MaterialTheme.typography.labelLarge,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                    )
                    Spacer(Modifier.height(8.dp))
                    OutlinedTextField(
                        value = state.filter.query,
                        onValueChange = onQueryChange,
                        modifier = Modifier.fillMaxWidth().testTag("task_search_input"),
                        singleLine = true,
                        leadingIcon = { Icon(Icons.Default.Search, contentDescription = null) },
                        trailingIcon = {
                            if (state.filter.query.isNotEmpty()) {
                                IconButton(onClick = { onQueryChange("") }) {
                                    Icon(Icons.Default.Close, contentDescription = "Suche leeren")
                                }
                            }
                        },
                        label = { Text("Aufgaben durchsuchen") },
                        shape = MaterialTheme.shapes.large,
                    )
                    if (state.activeFilterCount > 0) {
                        Spacer(Modifier.height(8.dp))
                        AssistChip(
                            onClick = onClearFilters,
                            label = { Text("Filter zurücksetzen (${state.activeFilterCount})") },
                            modifier = Modifier.testTag("filter_button"),
                        )
                    }
                    Spacer(Modifier.height(8.dp))
                    FilterControls(
                        state = state,
                        onStatusChange = onStatusChange,
                        onCategoryChange = onCategoryChange,
                        onPriorityChange = onPriorityChange,
                    )
                    Spacer(Modifier.height(12.dp))
                    HorizontalDivider()
                }
            }

            if (state.tasks.isEmpty()) {
                item(key = "empty") {
                    EmptyState(
                        title =
                            if (state.totalTaskCount == 0) "Deine Liste ist startklar"
                            else "Keine passenden Aufgaben",
                        message =
                            if (state.totalTaskCount == 0) {
                                "Plane deinen nächsten Schritt und bring Momentum in deinen Tag."
                            } else {
                                "Ändere die Suche oder setze deine Filter zurück."
                            },
                        actionLabel =
                            if (state.totalTaskCount == 0) {
                                "Aufgabe erstellen"
                            } else {
                                "Filter zurücksetzen"
                            },
                        onAction = if (state.totalTaskCount == 0) onAddTask else onClearFilters,
                        modifier = Modifier.fillMaxWidth(),
                    )
                }
            } else {
                groups.forEach { group ->
                    item(key = "header_${group.label}") {
                        Text(
                            text = group.label,
                            style = MaterialTheme.typography.titleSmall,
                            color = MaterialTheme.colorScheme.primary,
                            fontWeight = FontWeight.Bold,
                            modifier =
                                Modifier.padding(top = 8.dp, bottom = 2.dp).semantics { heading() },
                        )
                    }
                    items(group.tasks, key = MomentumTask::id) { task ->
                        TaskCard(
                            task = task,
                            onToggle = { onToggle(task) },
                            onEdit = { onEditTask(task.id) },
                            onDelete = { onDelete(task) },
                        )
                    }
                }
            }
        }
    }
}

@Composable
private fun FilterControls(
    state: TasksUiState.Content,
    onStatusChange: (TaskStatusFilter) -> Unit,
    onCategoryChange: (TaskCategory?) -> Unit,
    onPriorityChange: (TaskPriority?) -> Unit,
) {
    Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
        Row(
            modifier = Modifier.fillMaxWidth().horizontalScroll(rememberScrollState()),
            horizontalArrangement = Arrangement.spacedBy(8.dp),
        ) {
            Text(
                text = "Status",
                style = MaterialTheme.typography.labelLarge,
                modifier = Modifier.align(Alignment.CenterVertically),
            )
            TaskStatusFilter.entries.forEach { status ->
                FilterChip(
                    selected = state.filter.status == status,
                    onClick = { onStatusChange(status) },
                    label = {
                        Text(
                            when (status) {
                                TaskStatusFilter.ALL -> "Alle"
                                TaskStatusFilter.OPEN -> "Offen"
                                TaskStatusFilter.COMPLETED -> "Erledigt"
                            }
                        )
                    },
                )
            }
        }
        Row(
            modifier = Modifier.fillMaxWidth().horizontalScroll(rememberScrollState()),
            horizontalArrangement = Arrangement.spacedBy(8.dp),
        ) {
            Text(
                text = "Kategorie",
                style = MaterialTheme.typography.labelLarge,
                modifier = Modifier.align(Alignment.CenterVertically),
            )
            FilterChip(
                selected = state.filter.category == null,
                onClick = { onCategoryChange(null) },
                label = { Text("Alle") },
            )
            TaskCategory.entries.forEach { category ->
                FilterChip(
                    selected = state.filter.category == category,
                    onClick = {
                        onCategoryChange(if (state.filter.category == category) null else category)
                    },
                    label = { Text(category.label) },
                )
            }
        }
        Row(
            modifier = Modifier.fillMaxWidth().horizontalScroll(rememberScrollState()),
            horizontalArrangement = Arrangement.spacedBy(8.dp),
        ) {
            Text(
                text = "Priorität",
                style = MaterialTheme.typography.labelLarge,
                modifier = Modifier.align(Alignment.CenterVertically),
            )
            FilterChip(
                selected = state.filter.priority == null,
                onClick = { onPriorityChange(null) },
                label = { Text("Alle") },
            )
            TaskPriority.entries.forEach { priority ->
                FilterChip(
                    selected = state.filter.priority == priority,
                    onClick = {
                        onPriorityChange(if (state.filter.priority == priority) null else priority)
                    },
                    label = { Text(priority.label) },
                )
            }
        }
    }
}

private fun List<MomentumTask>.toGroups(today: LocalDate): List<TaskGroup> {
    val overdue = filter { it.dueDate < today && !it.isCompleted }
    val remaining = this - overdue.toSet()
    return buildList {
        if (overdue.isNotEmpty()) add(TaskGroup("Überfällig", overdue))
        remaining.groupBy(MomentumTask::dueDate).forEach { (date, tasks) ->
            val label =
                when (date) {
                    today -> "Heute"
                    today.plusDays(1) -> "Morgen"
                    else ->
                        date.format(java.time.format.DateTimeFormatter.ofPattern("EEEE, d. MMMM"))
                }
            add(TaskGroup(label.replaceFirstChar { it.uppercase() }, tasks))
        }
    }
}

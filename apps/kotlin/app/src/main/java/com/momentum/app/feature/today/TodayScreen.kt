package com.momentum.app.feature.today

import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.animateContentSize
import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.togetherWith
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.BoxWithConstraints
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.statusBarsPadding
import androidx.compose.foundation.layout.widthIn
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.FilledTonalButton
import androidx.compose.material3.Icon
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.heading
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.momentum.app.domain.model.MomentumTask
import com.momentum.app.domain.model.TaskCategory
import com.momentum.app.ui.components.DeleteTaskDialog
import com.momentum.app.ui.components.EmptyState
import com.momentum.app.ui.components.ErrorState
import com.momentum.app.ui.components.LoadingState
import com.momentum.app.ui.components.SectionHeader
import com.momentum.app.ui.components.TaskCard
import com.momentum.app.ui.util.categoryColors
import com.momentum.app.ui.util.label
import com.momentum.app.ui.util.symbol

private val TodayMaxContentWidth = 840.dp

@Composable
fun TodayScreen(
    viewModel: TodayViewModel,
    onAddTask: () -> Unit,
    onShowAll: () -> Unit,
    onEditTask: (String) -> Unit,
    onCategorySelected: (TaskCategory) -> Unit,
    snackbarHostState: SnackbarHostState,
    modifier: Modifier = Modifier,
) {
    val state by viewModel.uiState.collectAsStateWithLifecycle()
    TodayScreen(
        state = state,
        onAddTask = onAddTask,
        onShowAll = onShowAll,
        onEditTask = onEditTask,
        onCategorySelected = onCategorySelected,
        onRetry = viewModel::retry,
        onToggleTask = { task -> viewModel.setCompleted(task.id, !task.isCompleted) },
        onDeleteTask = viewModel::deleteTask,
        onUserMessageShown = viewModel::clearUserMessage,
        snackbarHostState = snackbarHostState,
        modifier = modifier,
    )
}

@Composable
fun TodayScreen(
    state: TodayUiState,
    onAddTask: () -> Unit,
    onShowAll: () -> Unit,
    onEditTask: (String) -> Unit,
    onCategorySelected: (TaskCategory) -> Unit,
    onRetry: () -> Unit,
    onToggleTask: (MomentumTask) -> Unit,
    onDeleteTask: (String) -> Unit,
    onUserMessageShown: () -> Unit,
    snackbarHostState: SnackbarHostState,
    modifier: Modifier = Modifier,
) {
    when (state) {
        TodayUiState.Loading ->
            LoadingState(
                modifier = modifier,
                message = "Dein Tag wird vorbereitet",
            )

        is TodayUiState.Error ->
            ErrorState(
                message = state.message,
                onRetry = onRetry,
                modifier = modifier,
            )

        is TodayUiState.Content ->
            TodayContent(
                state = state,
                onAddTask = onAddTask,
                onShowAll = onShowAll,
                onEditTask = onEditTask,
                onCategorySelected = onCategorySelected,
                onToggleTask = onToggleTask,
                onDeleteTask = onDeleteTask,
                onUserMessageShown = onUserMessageShown,
                snackbarHostState = snackbarHostState,
                modifier = modifier,
            )
    }
}

@Composable
private fun TodayContent(
    state: TodayUiState.Content,
    onAddTask: () -> Unit,
    onShowAll: () -> Unit,
    onEditTask: (String) -> Unit,
    onCategorySelected: (TaskCategory) -> Unit,
    onToggleTask: (MomentumTask) -> Unit,
    onDeleteTask: (String) -> Unit,
    onUserMessageShown: () -> Unit,
    snackbarHostState: SnackbarHostState,
    modifier: Modifier = Modifier,
) {
    var deleteTaskId by rememberSaveable { mutableStateOf<String?>(null) }
    val taskToDelete = state.tasks.firstOrNull { it.id == deleteTaskId }

    LaunchedEffect(state.userMessage) {
        val message = state.userMessage ?: return@LaunchedEffect
        snackbarHostState.showSnackbar(message)
        onUserMessageShown()
    }

    LaunchedEffect(deleteTaskId, taskToDelete) {
        if (deleteTaskId != null && taskToDelete == null) deleteTaskId = null
    }

    if (taskToDelete != null) {
        DeleteTaskDialog(
            taskTitle = taskToDelete.title,
            onConfirm = {
                deleteTaskId = null
                onDeleteTask(taskToDelete.id)
            },
            onDismiss = { deleteTaskId = null },
        )
    }

    BoxWithConstraints(modifier = modifier.fillMaxSize().statusBarsPadding()) {
        val horizontalPadding = if (maxWidth < 380.dp) 16.dp else 24.dp

        LazyColumn(
            modifier =
                Modifier.widthIn(max = TodayMaxContentWidth)
                    .fillMaxWidth()
                    .align(Alignment.TopCenter)
                    .testTag("today_content"),
            contentPadding =
                PaddingValues(
                    start = horizontalPadding,
                    top = 24.dp,
                    end = horizontalPadding,
                    bottom = 104.dp,
                ),
            verticalArrangement = Arrangement.spacedBy(24.dp),
        ) {
            item(key = "greeting") {
                GreetingHeader(
                    greeting = state.greeting,
                    formattedDate = state.formattedDate,
                    onAddTask = onAddTask,
                )
            }

            item(key = "overview") {
                OverviewCards(
                    taskCount = state.taskCount,
                    completedCount = state.completedCount,
                    progress = state.progress,
                    streakDays = state.streakDays,
                )
            }

            item(key = "categories") {
                Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                    SectionHeader(title = "Kategorien")
                    CategoryOverview(
                        summaries = state.categories,
                        onCategorySelected = onCategorySelected,
                    )
                }
            }

            item(key = "task_header") {
                SectionHeader(
                    title = "Heute",
                    actionLabel = if (state.tasks.isNotEmpty()) "Alle Aufgaben" else null,
                    onAction = if (state.tasks.isNotEmpty()) onShowAll else null,
                )
            }

            if (state.tasks.isEmpty()) {
                item(key = "empty") {
                    Card(
                        colors =
                            CardDefaults.cardColors(
                                containerColor = MaterialTheme.colorScheme.surfaceContainerLow
                            )
                    ) {
                        EmptyState(
                            title = "Freier Kopf für heute",
                            message = "Plane deine nächste Aufgabe oder genieße den freien Raum.",
                            icon = Icons.Default.CheckCircle,
                            actionLabel = "Aufgabe hinzufügen",
                            onAction = onAddTask,
                            modifier = Modifier.fillMaxWidth(),
                        )
                    }
                }
            } else {
                items(
                    items = state.tasks,
                    key = MomentumTask::id,
                ) { task ->
                    TaskCard(
                        task = task,
                        onToggle = { onToggleTask(task) },
                        onEdit = { onEditTask(task.id) },
                        onDelete = { deleteTaskId = task.id },
                        showDate = false,
                        modifier = Modifier.animateItem(),
                    )
                }
            }
        }
    }
}

@Composable
private fun GreetingHeader(
    greeting: String,
    formattedDate: String,
    onAddTask: () -> Unit,
) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.spacedBy(16.dp),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        Column(modifier = Modifier.weight(1f)) {
            Text(
                text = greeting,
                modifier = Modifier.semantics { heading() },
                style = MaterialTheme.typography.headlineMedium,
                fontWeight = FontWeight.Bold,
            )
            Spacer(Modifier.height(4.dp))
            Text(
                text = formattedDate,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                style = MaterialTheme.typography.bodyLarge,
            )
        }
        FilledTonalButton(
            onClick = onAddTask,
            contentPadding = PaddingValues(horizontal = 16.dp, vertical = 12.dp),
        ) {
            Icon(Icons.Default.Add, contentDescription = null)
            Spacer(Modifier.size(8.dp))
            Text("Neu")
        }
    }
}

@Composable
private fun OverviewCards(
    taskCount: Int,
    completedCount: Int,
    progress: Float,
    streakDays: Int,
) {
    BoxWithConstraints {
        if (maxWidth >= 620.dp) {
            Row(horizontalArrangement = Arrangement.spacedBy(16.dp)) {
                ProgressCard(
                    taskCount = taskCount,
                    completedCount = completedCount,
                    progress = progress,
                    modifier = Modifier.weight(2f),
                )
                StreakCard(
                    streakDays = streakDays,
                    modifier = Modifier.weight(1f),
                )
            }
        } else {
            Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                ProgressCard(
                    taskCount = taskCount,
                    completedCount = completedCount,
                    progress = progress,
                )
                StreakCard(streakDays = streakDays)
            }
        }
    }
}

@Composable
private fun ProgressCard(
    taskCount: Int,
    completedCount: Int,
    progress: Float,
    modifier: Modifier = Modifier,
) {
    val animatedProgress by
        animateFloatAsState(
            targetValue = progress.coerceIn(0f, 1f),
            animationSpec = tween(durationMillis = 650),
            label = "today-progress",
        )

    Surface(
        modifier = modifier.fillMaxWidth().animateContentSize(),
        color = MaterialTheme.colorScheme.primaryContainer,
        contentColor = MaterialTheme.colorScheme.onPrimaryContainer,
        shape = MaterialTheme.shapes.extraLarge,
    ) {
        Column(Modifier.padding(22.dp)) {
            Text(
                text = "Dein Fortschritt",
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.SemiBold,
            )
            Spacer(Modifier.height(8.dp))
            Row(verticalAlignment = Alignment.Bottom) {
                AnimatedContent(
                    targetState = completedCount,
                    transitionSpec = { fadeIn(tween(220)) togetherWith fadeOut(tween(120)) },
                    label = "completed-count",
                ) { count ->
                    Text(
                        text = count.toString(),
                        style = MaterialTheme.typography.displaySmall,
                        fontWeight = FontWeight.Bold,
                    )
                }
                Text(
                    text = " von $taskCount erledigt",
                    modifier = Modifier.padding(bottom = 6.dp),
                    style = MaterialTheme.typography.bodyLarge,
                )
            }
            Spacer(Modifier.height(16.dp))
            LinearProgressIndicator(
                progress = { animatedProgress },
                modifier =
                    Modifier.fillMaxWidth()
                        .height(9.dp)
                        .clip(MaterialTheme.shapes.extraLarge)
                        .semantics {
                            contentDescription = "$completedCount von $taskCount Aufgaben erledigt"
                        },
                color = MaterialTheme.colorScheme.primary,
                trackColor = MaterialTheme.colorScheme.surface.copy(alpha = 0.55f),
                drawStopIndicator = {},
            )
        }
    }
}

@Composable
private fun StreakCard(
    streakDays: Int,
    modifier: Modifier = Modifier,
) {
    Surface(
        modifier = modifier.fillMaxWidth(),
        color = MaterialTheme.colorScheme.tertiaryContainer,
        contentColor = MaterialTheme.colorScheme.onTertiaryContainer,
        shape = MaterialTheme.shapes.extraLarge,
    ) {
        Column(Modifier.padding(22.dp)) {
            Text(
                text = "Aktuelle Serie",
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.SemiBold,
            )
            Spacer(Modifier.height(10.dp))
            Text(
                text = if (streakDays == 1) "1 Tag" else "$streakDays Tage",
                style = MaterialTheme.typography.headlineMedium,
                fontWeight = FontWeight.Bold,
            )
            Spacer(Modifier.height(4.dp))
            Text(
                text =
                    if (streakDays == 0) {
                        "Heute ist ein guter Anfang."
                    } else {
                        "Bleib in deinem Rhythmus."
                    },
                style = MaterialTheme.typography.bodyMedium,
            )
        }
    }
}

@Composable
private fun CategoryOverview(
    summaries: List<TodayCategorySummary>,
    onCategorySelected: (TaskCategory) -> Unit,
) {
    BoxWithConstraints {
        val columns = if (maxWidth >= 620.dp) 4 else 2
        Column(verticalArrangement = Arrangement.spacedBy(10.dp)) {
            summaries.chunked(columns).forEach { rowItems ->
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(10.dp),
                ) {
                    rowItems.forEach { summary ->
                        CategorySummaryCard(
                            summary = summary,
                            onClick = { onCategorySelected(summary.category) },
                            modifier = Modifier.weight(1f),
                        )
                    }
                    repeat(columns - rowItems.size) {
                        Spacer(Modifier.weight(1f))
                    }
                }
            }
        }
    }
}

@Composable
private fun CategorySummaryCard(
    summary: TodayCategorySummary,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
) {
    val colors = categoryColors(summary.category)
    Surface(
        modifier =
            modifier
                .clip(MaterialTheme.shapes.large)
                .clickable(
                    role = Role.Button,
                    onClickLabel = "${summary.category.label} anzeigen",
                    onClick = onClick,
                ),
        color = colors.container,
        contentColor = colors.foreground,
        shape = MaterialTheme.shapes.large,
    ) {
        Column(Modifier.padding(16.dp)) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically,
            ) {
                Text(
                    text = summary.category.symbol,
                    style = MaterialTheme.typography.labelLarge,
                    fontWeight = FontWeight.Bold,
                )
                Text(
                    text = summary.taskCount.toString(),
                    style = MaterialTheme.typography.headlineSmall,
                    fontWeight = FontWeight.Bold,
                )
            }
            Spacer(Modifier.height(12.dp))
            Text(
                text = summary.category.label,
                style = MaterialTheme.typography.titleSmall,
                fontWeight = FontWeight.SemiBold,
                maxLines = 1,
                overflow = TextOverflow.Ellipsis,
            )
            Text(
                text = "${summary.completedCount} erledigt",
                style = MaterialTheme.typography.bodySmall,
            )
        }
    }
}

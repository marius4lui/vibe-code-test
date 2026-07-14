package com.momentum.app.feature.editor

import android.app.DatePickerDialog
import android.app.TimePickerDialog
import android.text.format.DateFormat
import androidx.activity.compose.BackHandler
import androidx.compose.foundation.horizontalScroll
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.RowScope
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.imePadding
import androidx.compose.foundation.layout.navigationBars
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.layout.widthIn
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.DateRange
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.FilterChip
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.focus.FocusDirection
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalFocusManager
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.semantics.LiveRegionMode
import androidx.compose.ui.semantics.liveRegion
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardCapitalization
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.momentum.app.domain.model.TaskCategory
import com.momentum.app.domain.model.TaskPriority
import com.momentum.app.domain.validation.TaskField
import com.momentum.app.ui.components.DeleteTaskDialog
import com.momentum.app.ui.components.ErrorState
import com.momentum.app.ui.components.LoadingState
import com.momentum.app.ui.util.label
import java.time.LocalDate
import java.time.LocalTime
import java.time.format.DateTimeFormatter
import java.time.format.FormatStyle
import java.util.Locale
import kotlinx.coroutines.launch

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun TaskEditorScreen(
    viewModel: TaskEditorViewModel,
    onBack: () -> Unit,
    onSaved: (String) -> Unit,
    modifier: Modifier = Modifier,
) {
    val state by viewModel.uiState.collectAsStateWithLifecycle()
    val snackbarHostState = remember { SnackbarHostState() }
    val scope = rememberCoroutineScope()
    var showDiscardDialog by remember { mutableStateOf(false) }
    var showDeleteDialog by remember { mutableStateOf(false) }

    val ready = state as? TaskEditorUiState.Ready
    fun requestBack() {
        if (ready?.isDirty == true) showDiscardDialog = true else onBack()
    }
    fun showError(message: String) {
        scope.launch { snackbarHostState.showSnackbar(message) }
    }

    BackHandler(enabled = ready?.isDirty == true) { showDiscardDialog = true }

    Scaffold(
        modifier = modifier,
        topBar = {
            TopAppBar(
                title = {
                    Text(if (ready?.isEditMode == true) "Aufgabe bearbeiten" else "Neue Aufgabe")
                },
                navigationIcon = {
                    IconButton(onClick = ::requestBack) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = "Zurück")
                    }
                },
                actions = {
                    if (ready?.isEditMode == true) {
                        IconButton(
                            onClick = { showDeleteDialog = true },
                            enabled = !ready.isSaving,
                        ) {
                            Icon(Icons.Default.Delete, contentDescription = "Aufgabe löschen")
                        }
                    }
                },
            )
        },
        snackbarHost = { SnackbarHost(snackbarHostState) },
        bottomBar = {
            if (ready != null) {
                Surface(modifier = Modifier.navigationBarsPadding(), tonalElevation = 3.dp) {
                    Button(
                        onClick = {
                            viewModel.save(
                                onSuccess = {
                                    onSaved(
                                        if (ready.isEditMode) "Änderungen gespeichert"
                                        else "Aufgabe erstellt"
                                    )
                                },
                                onError = ::showError,
                                onValidationError = ::showError,
                            )
                        },
                        enabled = !ready.isSaving,
                        modifier =
                            Modifier.fillMaxWidth()
                                .padding(horizontal = 16.dp, vertical = 12.dp)
                                .height(52.dp)
                                .testTag("save_task_button"),
                    ) {
                        if (ready.isSaving) {
                            CircularProgressIndicator(
                                modifier = Modifier.height(22.dp),
                                strokeWidth = 2.dp,
                                color = MaterialTheme.colorScheme.onPrimary,
                            )
                        } else {
                            Text(
                                if (ready.isEditMode) "Änderungen speichern"
                                else "Aufgabe erstellen"
                            )
                        }
                    }
                }
            }
        },
        contentWindowInsets = WindowInsets.navigationBars,
    ) { innerPadding ->
        when (val current = state) {
            TaskEditorUiState.Loading -> LoadingState(Modifier.padding(innerPadding))
            is TaskEditorUiState.Error ->
                ErrorState(
                    message = current.message,
                    onRetry = viewModel::load,
                    modifier = Modifier.padding(innerPadding),
                )
            is TaskEditorUiState.Ready ->
                EditorForm(
                    state = current,
                    onTitleChange = viewModel::setTitle,
                    onDescriptionChange = viewModel::setDescription,
                    onCategoryChange = viewModel::setCategory,
                    onPriorityChange = viewModel::setPriority,
                    onDateChange = viewModel::setDueDate,
                    onTimeChange = viewModel::setDueTime,
                    modifier = Modifier.padding(innerPadding),
                )
        }
    }

    if (showDiscardDialog) {
        AlertDialog(
            onDismissRequest = { showDiscardDialog = false },
            title = { Text("Änderungen verwerfen?") },
            text = { Text("Deine Eingaben wurden noch nicht gespeichert.") },
            confirmButton = {
                TextButton(onClick = onBack) { Text("Verwerfen") }
            },
            dismissButton = {
                TextButton(onClick = { showDiscardDialog = false }) { Text("Weiter bearbeiten") }
            },
        )
    }

    if (showDeleteDialog && ready != null) {
        DeleteTaskDialog(
            taskTitle = ready.title,
            onDismiss = { showDeleteDialog = false },
            onConfirm = {
                showDeleteDialog = false
                viewModel.delete(
                    onSuccess = { onSaved("Aufgabe gelöscht") },
                    onError = ::showError,
                )
            },
        )
    }
}

@Composable
private fun EditorForm(
    state: TaskEditorUiState.Ready,
    onTitleChange: (String) -> Unit,
    onDescriptionChange: (String) -> Unit,
    onCategoryChange: (TaskCategory) -> Unit,
    onPriorityChange: (TaskPriority) -> Unit,
    onDateChange: (LocalDate) -> Unit,
    onTimeChange: (LocalTime?) -> Unit,
    modifier: Modifier = Modifier,
) {
    val context = LocalContext.current
    val focusManager = LocalFocusManager.current
    val scrollState = rememberScrollState()
    val dateFormatter = remember {
        DateTimeFormatter.ofLocalizedDate(FormatStyle.FULL).withLocale(Locale.getDefault())
    }
    val timeFormatter = remember {
        DateTimeFormatter.ofPattern(
            if (DateFormat.is24HourFormat(context)) "HH:mm" else "h:mm a",
            Locale.getDefault(),
        )
    }

    LaunchedEffect(state.validationAttempt) {
        if (state.validationAttempt > 0) scrollState.animateScrollTo(0)
    }

    Column(
        modifier =
            modifier
                .fillMaxSize()
                .imePadding()
                .verticalScroll(scrollState)
                .padding(horizontal = 16.dp, vertical = 20.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
    ) {
        Column(
            modifier = Modifier.widthIn(max = 720.dp).fillMaxWidth(),
            verticalArrangement = Arrangement.spacedBy(20.dp),
        ) {
            if (state.errors.isNotEmpty()) {
                Surface(
                    color = MaterialTheme.colorScheme.errorContainer,
                    contentColor = MaterialTheme.colorScheme.onErrorContainer,
                    shape = MaterialTheme.shapes.medium,
                    modifier =
                        Modifier.fillMaxWidth().semantics {
                            liveRegion = LiveRegionMode.Polite
                        },
                ) {
                    Text(
                        "Bitte prüfe die markierten Felder.",
                        modifier = Modifier.padding(14.dp),
                        style = MaterialTheme.typography.bodyMedium,
                    )
                }
            }
            Column {
                OutlinedTextField(
                    value = state.title,
                    onValueChange = onTitleChange,
                    modifier = Modifier.fillMaxWidth().testTag("task_title_input"),
                    label = { Text("Titel *") },
                    placeholder = { Text("Was möchtest du erledigen?") },
                    singleLine = true,
                    isError = state.errors.containsKey(TaskField.TITLE),
                    supportingText = {
                        Text(
                            text =
                                state.errors[TaskField.TITLE]?.message
                                    ?: "${state.title.length}/80 Zeichen",
                            color =
                                if (state.errors.containsKey(TaskField.TITLE)) {
                                    MaterialTheme.colorScheme.error
                                } else {
                                    MaterialTheme.colorScheme.onSurfaceVariant
                                },
                        )
                    },
                    keyboardOptions =
                        KeyboardOptions(
                            capitalization = KeyboardCapitalization.Sentences,
                            imeAction = ImeAction.Next,
                        ),
                    keyboardActions =
                        KeyboardActions(onNext = { focusManager.moveFocus(FocusDirection.Down) }),
                )
                OutlinedTextField(
                    value = state.description,
                    onValueChange = onDescriptionChange,
                    modifier = Modifier.fillMaxWidth().testTag("task_description_input"),
                    label = { Text("Beschreibung (optional)") },
                    minLines = 3,
                    maxLines = 6,
                    isError = state.errors.containsKey(TaskField.DESCRIPTION),
                    supportingText = {
                        Text(
                            text =
                                state.errors[TaskField.DESCRIPTION]?.message
                                    ?: "${state.description.length}/500 Zeichen",
                            color =
                                if (state.errors.containsKey(TaskField.DESCRIPTION)) {
                                    MaterialTheme.colorScheme.error
                                } else {
                                    MaterialTheme.colorScheme.onSurfaceVariant
                                },
                        )
                    },
                    keyboardOptions =
                        KeyboardOptions(
                            capitalization = KeyboardCapitalization.Sentences,
                            keyboardType = KeyboardType.Text,
                            imeAction = ImeAction.Done,
                        ),
                    keyboardActions = KeyboardActions(onDone = { focusManager.clearFocus() }),
                )
            }

            ChoiceSection(
                title = "Kategorie *",
                error = state.errors[TaskField.CATEGORY]?.message,
            ) {
                TaskCategory.entries.forEach { category ->
                    FilterChip(
                        selected = state.category == category,
                        onClick = { onCategoryChange(category) },
                        label = { Text(category.label) },
                        modifier = Modifier.testTag("category_${category.name.lowercase()}"),
                    )
                }
            }

            ChoiceSection(title = "Priorität *") {
                TaskPriority.entries.forEach { priority ->
                    FilterChip(
                        selected = state.priority == priority,
                        onClick = { onPriorityChange(priority) },
                        label = { Text(priority.label) },
                    )
                }
            }

            Column {
                Text("Termin", style = MaterialTheme.typography.titleMedium)
                Spacer(Modifier.height(10.dp))
                OutlinedButton(
                    onClick = {
                        DatePickerDialog(
                                context,
                                { _, year, month, day ->
                                    onDateChange(LocalDate.of(year, month + 1, day))
                                },
                                state.dueDate.year,
                                state.dueDate.monthValue - 1,
                                state.dueDate.dayOfMonth,
                            )
                            .show()
                    },
                    modifier = Modifier.fillMaxWidth(),
                ) {
                    Icon(Icons.Default.DateRange, contentDescription = null)
                    Spacer(Modifier.width(8.dp))
                    Text(state.dueDate.format(dateFormatter))
                }
                Spacer(Modifier.height(10.dp))
                Row(verticalAlignment = Alignment.CenterVertically) {
                    OutlinedButton(
                        onClick = {
                            val initial = state.dueTime ?: LocalTime.of(9, 0)
                            TimePickerDialog(
                                    context,
                                    { _, hour, minute -> onTimeChange(LocalTime.of(hour, minute)) },
                                    initial.hour,
                                    initial.minute,
                                    DateFormat.is24HourFormat(context),
                                )
                                .show()
                        },
                        modifier = Modifier.weight(1f),
                    ) {
                        Text(
                            state.dueTime?.let { it.format(timeFormatter) } ?: "Uhrzeit hinzufügen"
                        )
                    }
                    if (state.dueTime != null) {
                        IconButton(onClick = { onTimeChange(null) }) {
                            Icon(Icons.Default.Close, contentDescription = "Uhrzeit entfernen")
                        }
                    }
                }
            }
            Spacer(Modifier.height(12.dp))
        }
    }
}

@Composable
private fun ChoiceSection(
    title: String,
    error: String? = null,
    content: @Composable RowScope.() -> Unit,
) {
    Column {
        Text(title, style = MaterialTheme.typography.titleMedium)
        Spacer(Modifier.height(10.dp))
        Row(
            modifier = Modifier.fillMaxWidth().horizontalScroll(rememberScrollState()),
            horizontalArrangement = Arrangement.spacedBy(8.dp),
            content = content,
        )
        if (error != null) {
            Spacer(Modifier.height(6.dp))
            Text(
                error,
                modifier = Modifier.semantics { liveRegion = LiveRegionMode.Polite },
                color = MaterialTheme.colorScheme.error,
                style = MaterialTheme.typography.bodySmall,
            )
        }
    }
}

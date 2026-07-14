package com.momentum.app.feature.settings

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.layout.widthIn
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.CenterAlignedTopAppBar
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedCard
import androidx.compose.material3.RadioButton
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.semantics.heading
import androidx.compose.ui.semantics.role
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.momentum.app.domain.model.ThemeMode
import com.momentum.app.ui.components.ErrorState
import com.momentum.app.ui.components.LoadingState
import kotlinx.coroutines.launch

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SettingsScreen(
    viewModel: SettingsViewModel,
    modifier: Modifier = Modifier,
) {
    val state by viewModel.uiState.collectAsStateWithLifecycle()
    val snackbarHostState = remember { SnackbarHostState() }
    val scope = rememberCoroutineScope()
    var showDeleteAllDialog by remember { mutableStateOf(false) }

    fun showError(message: String) {
        scope.launch { snackbarHostState.showSnackbar(message) }
    }

    Scaffold(
        modifier = modifier,
        topBar = {
            CenterAlignedTopAppBar(title = { Text("Einstellungen", fontWeight = FontWeight.Bold) })
        },
        snackbarHost = { SnackbarHost(snackbarHostState) },
    ) { innerPadding ->
        when (val current = state) {
            SettingsUiState.Loading -> LoadingState(Modifier.padding(innerPadding))
            is SettingsUiState.Error ->
                ErrorState(
                    message = current.message,
                    onRetry = viewModel::retry,
                    modifier = Modifier.padding(innerPadding),
                )
            is SettingsUiState.Content ->
                SettingsContent(
                    state = current,
                    onThemeSelected = { viewModel.setThemeMode(it, ::showError) },
                    onDeleteAll = { showDeleteAllDialog = true },
                    onReplayOnboarding = { viewModel.replayOnboarding(::showError) },
                    modifier = Modifier.padding(innerPadding),
                )
        }
    }

    if (showDeleteAllDialog) {
        AlertDialog(
            onDismissRequest = { showDeleteAllDialog = false },
            title = { Text("Alle Aufgaben löschen?") },
            text = {
                Text(
                    "Dieser Schritt entfernt alle Aufgaben dauerhaft. Einstellungen bleiben erhalten."
                )
            },
            confirmButton = {
                TextButton(
                    onClick = {
                        showDeleteAllDialog = false
                        viewModel.clearTasks(
                            onSuccess = {
                                scope.launch {
                                    snackbarHostState.showSnackbar("Alle Aufgaben wurden gelöscht")
                                }
                            },
                            onError = ::showError,
                        )
                    }
                ) {
                    Text("Alle löschen", color = MaterialTheme.colorScheme.error)
                }
            },
            dismissButton = {
                TextButton(onClick = { showDeleteAllDialog = false }) { Text("Abbrechen") }
            },
        )
    }
}

@Composable
private fun SettingsContent(
    state: SettingsUiState.Content,
    onThemeSelected: (ThemeMode) -> Unit,
    onDeleteAll: () -> Unit,
    onReplayOnboarding: () -> Unit,
    modifier: Modifier = Modifier,
) {
    LazyColumn(
        modifier = modifier.fillMaxSize(),
        contentPadding = PaddingValues(start = 16.dp, top = 20.dp, end = 16.dp, bottom = 104.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(16.dp),
    ) {
        item {
            Column(Modifier.widthIn(max = 720.dp).fillMaxWidth()) {
                SettingsHeading("Darstellung")
                Spacer(Modifier.height(12.dp))
                ThemeMode.entries.forEach { mode ->
                    ThemeOption(
                        mode = mode,
                        selected = state.settings.themeMode == mode,
                        onClick = { onThemeSelected(mode) },
                    )
                    Spacer(Modifier.height(8.dp))
                }
            }
        }

        item {
            Column(Modifier.widthIn(max = 720.dp).fillMaxWidth()) {
                HorizontalDivider()
                Spacer(Modifier.height(20.dp))
                SettingsHeading("Deine Daten")
                Spacer(Modifier.height(8.dp))
                SettingsAction(
                    title = "Alle Aufgaben löschen",
                    subtitle = "${state.taskCount} lokal gespeicherte Aufgaben",
                    symbol = "×",
                    symbolColor = MaterialTheme.colorScheme.error,
                    onClick = onDeleteAll,
                    enabled = state.taskCount > 0,
                )
            }
        }

        item {
            Column(Modifier.widthIn(max = 720.dp).fillMaxWidth()) {
                HorizontalDivider()
                Spacer(Modifier.height(20.dp))
                SettingsHeading("Einführung")
                Spacer(Modifier.height(8.dp))
                SettingsAction(
                    title = "Onboarding erneut ansehen",
                    subtitle = "Entdecke die wichtigsten Funktionen noch einmal",
                    symbol = "↻",
                    onClick = onReplayOnboarding,
                )
            }
        }

        item {
            Column(Modifier.widthIn(max = 720.dp).fillMaxWidth()) {
                HorizontalDivider()
                Spacer(Modifier.height(20.dp))
                SettingsHeading("Über Momentum")
                Spacer(Modifier.height(12.dp))
                OutlinedCard(Modifier.fillMaxWidth()) {
                    Row(
                        modifier = Modifier.fillMaxWidth().padding(18.dp),
                        verticalAlignment = Alignment.CenterVertically,
                    ) {
                        Text(
                            text = "M",
                            modifier = Modifier.padding(12.dp),
                            color = MaterialTheme.colorScheme.primary,
                            style = MaterialTheme.typography.headlineSmall,
                            fontWeight = FontWeight.Black,
                        )
                        Spacer(Modifier.width(8.dp))
                        Column {
                            Text(
                                "Momentum",
                                style = MaterialTheme.typography.titleMedium,
                                fontWeight = FontWeight.Bold,
                            )
                            Text(
                                "Version 1.0.0 · vollständig lokal",
                                style = MaterialTheme.typography.bodyMedium,
                                color = MaterialTheme.colorScheme.onSurfaceVariant,
                            )
                        }
                    }
                }
            }
        }
    }
}

@Composable
private fun SettingsHeading(text: String) {
    Text(
        text = text,
        modifier = Modifier.semantics { heading() },
        style = MaterialTheme.typography.titleLarge,
        fontWeight = FontWeight.SemiBold,
    )
}

@Composable
private fun ThemeOption(
    mode: ThemeMode,
    selected: Boolean,
    onClick: () -> Unit,
) {
    val (symbol, title, subtitle) =
        when (mode) {
            ThemeMode.SYSTEM -> Triple("◐", "Systemstandard", "Folgt der Einstellung deines Geräts")
            ThemeMode.LIGHT -> Triple("☀", "Hell", "Helle, ruhige Oberfläche")
            ThemeMode.DARK -> Triple("●", "Dunkel", "Angenehm bei wenig Licht")
        }
    OutlinedCard(
        modifier =
            Modifier.fillMaxWidth()
                .semantics { role = Role.RadioButton }
                .clickable(onClick = onClick),
        border =
            if (selected) {
                androidx.compose.foundation.BorderStroke(2.dp, MaterialTheme.colorScheme.primary)
            } else {
                androidx.compose.foundation.BorderStroke(
                    1.dp,
                    MaterialTheme.colorScheme.outlineVariant,
                )
            },
    ) {
        Row(
            modifier = Modifier.fillMaxWidth().padding(horizontal = 14.dp, vertical = 12.dp),
            verticalAlignment = Alignment.CenterVertically,
        ) {
            Text(
                symbol,
                style = MaterialTheme.typography.titleLarge,
                color = MaterialTheme.colorScheme.primary,
            )
            Spacer(Modifier.width(14.dp))
            Column(Modifier.weight(1f)) {
                Text(title, style = MaterialTheme.typography.titleMedium)
                Text(
                    subtitle,
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
            }
            RadioButton(selected = selected, onClick = null)
        }
    }
}

@Composable
private fun SettingsAction(
    title: String,
    subtitle: String,
    symbol: String,
    onClick: () -> Unit,
    symbolColor: Color = MaterialTheme.colorScheme.primary,
    enabled: Boolean = true,
) {
    Row(
        modifier =
            Modifier.fillMaxWidth()
                .clickable(enabled = enabled, onClick = onClick)
                .padding(vertical = 14.dp),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        Text(
            symbol,
            modifier = Modifier.size(48.dp).padding(10.dp),
            style = MaterialTheme.typography.titleLarge,
            color =
                if (enabled) symbolColor
                else MaterialTheme.colorScheme.onSurface.copy(alpha = 0.38f),
        )
        Spacer(Modifier.width(10.dp))
        Column(Modifier.weight(1f)) {
            Text(
                title,
                style = MaterialTheme.typography.titleMedium,
                color =
                    if (enabled) MaterialTheme.colorScheme.onSurface
                    else MaterialTheme.colorScheme.onSurface.copy(alpha = 0.38f),
            )
            Text(
                subtitle,
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
            )
        }
    }
}

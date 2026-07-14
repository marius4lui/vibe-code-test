package com.momentum.app.feature.settings

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewModelScope
import androidx.lifecycle.viewmodel.initializer
import androidx.lifecycle.viewmodel.viewModelFactory
import com.momentum.app.domain.model.ThemeMode
import com.momentum.app.domain.model.UserSettings
import com.momentum.app.domain.repository.SettingsRepository
import com.momentum.app.domain.repository.TaskRepository
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.flatMapLatest
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch

sealed interface SettingsUiState {
    data object Loading : SettingsUiState

    data class Content(
        val settings: UserSettings,
        val taskCount: Int,
    ) : SettingsUiState

    data class Error(val message: String) : SettingsUiState
}

@OptIn(ExperimentalCoroutinesApi::class)
class SettingsViewModel(
    private val settingsRepository: SettingsRepository,
    private val taskRepository: TaskRepository,
) : ViewModel() {
    private val retrySignal = MutableStateFlow(0)

    val uiState =
        retrySignal
            .flatMapLatest {
                combine(
                        settingsRepository.observeSettings(),
                        taskRepository.observeTasks(),
                    ) { settings, tasks ->
                        SettingsUiState.Content(settings, tasks.size) as SettingsUiState
                    }
                    .catch { error ->
                        emit(
                            SettingsUiState.Error(
                                error.message ?: "Einstellungen konnten nicht geladen werden."
                            )
                        )
                    }
            }
            .stateIn(
                scope = viewModelScope,
                started = SharingStarted.WhileSubscribed(5_000),
                initialValue = SettingsUiState.Loading,
            )

    fun retry() {
        retrySignal.value += 1
    }

    fun setThemeMode(
        mode: ThemeMode,
        onError: (String) -> Unit,
    ) {
        viewModelScope.launch {
            runCatching { settingsRepository.setThemeMode(mode) }
                .onFailure { onError(it.message ?: "Darstellung konnte nicht gespeichert werden.") }
        }
    }

    fun clearTasks(
        onSuccess: () -> Unit,
        onError: (String) -> Unit,
    ) {
        viewModelScope.launch {
            runCatching { taskRepository.deleteAll() }
                .onSuccess { onSuccess() }
                .onFailure { onError(it.message ?: "Aufgaben konnten nicht gelöscht werden.") }
        }
    }

    fun replayOnboarding(onError: (String) -> Unit) {
        viewModelScope.launch {
            runCatching { settingsRepository.setOnboardingCompleted(false) }
                .onFailure { onError(it.message ?: "Onboarding konnte nicht geöffnet werden.") }
        }
    }

    companion object {
        fun factory(
            settingsRepository: SettingsRepository,
            taskRepository: TaskRepository,
        ): ViewModelProvider.Factory = viewModelFactory {
            initializer { SettingsViewModel(settingsRepository, taskRepository) }
        }
    }
}

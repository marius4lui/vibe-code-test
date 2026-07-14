package com.momentum.app

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewModelScope
import androidx.lifecycle.viewmodel.initializer
import androidx.lifecycle.viewmodel.viewModelFactory
import com.momentum.app.domain.model.UserSettings
import com.momentum.app.domain.repository.SettingsRepository
import com.momentum.app.domain.repository.TaskRepository
import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

sealed interface RootUiState {
    data object Loading : RootUiState

    data class Ready(val settings: UserSettings) : RootUiState

    data class Error(val message: String) : RootUiState
}

class RootViewModel(
    private val taskRepository: TaskRepository,
    private val settingsRepository: SettingsRepository,
) : ViewModel() {
    private val _uiState = MutableStateFlow<RootUiState>(RootUiState.Loading)
    val uiState: StateFlow<RootUiState> = _uiState.asStateFlow()
    private var loadJob: Job? = null

    init {
        load()
    }

    fun retry() = load()

    fun completeOnboarding() {
        viewModelScope.launch {
            runCatching { settingsRepository.setOnboardingCompleted(true) }
                .onFailure { error ->
                    _uiState.value =
                        RootUiState.Error(
                            error.message
                                ?: "Der Onboarding-Status konnte nicht gespeichert werden."
                        )
                }
        }
    }

    private fun load() {
        loadJob?.cancel()
        loadJob = viewModelScope.launch {
            _uiState.value = RootUiState.Loading
            try {
                taskRepository.initializeIfNeeded()
                settingsRepository.observeSettings().collect { settings ->
                    _uiState.value = RootUiState.Ready(settings)
                }
            } catch (error: CancellationException) {
                throw error
            } catch (error: Exception) {
                _uiState.value =
                    RootUiState.Error(error.message ?: "Momentum konnte nicht gestartet werden.")
            }
        }
    }

    companion object {
        fun factory(
            taskRepository: TaskRepository,
            settingsRepository: SettingsRepository,
        ): ViewModelProvider.Factory = viewModelFactory {
            initializer { RootViewModel(taskRepository, settingsRepository) }
        }
    }
}

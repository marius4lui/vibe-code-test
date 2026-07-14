package com.momentum.app

import android.graphics.Color
import androidx.activity.ComponentActivity
import androidx.activity.SystemBarStyle
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.Surface
import androidx.compose.runtime.Composable
import androidx.compose.runtime.SideEffect
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.lifecycle.viewmodel.compose.viewModel
import com.momentum.app.domain.model.ThemeMode
import com.momentum.app.feature.onboarding.OnboardingScreen
import com.momentum.app.navigation.MomentumMain
import com.momentum.app.ui.components.ErrorState
import com.momentum.app.ui.components.LoadingState
import com.momentum.app.ui.theme.MomentumTheme

@Composable
fun MomentumRoot() {
    val context = LocalContext.current
    val application = context.applicationContext as MomentumApplication
    val container = application.container
    val rootViewModel: RootViewModel =
        viewModel(
            factory = RootViewModel.factory(container.taskRepository, container.settingsRepository)
        )
    val state by rootViewModel.uiState.collectAsStateWithLifecycle()
    val themeMode = (state as? RootUiState.Ready)?.settings?.themeMode ?: ThemeMode.SYSTEM
    val darkTheme =
        when (themeMode) {
            ThemeMode.SYSTEM -> isSystemInDarkTheme()
            ThemeMode.LIGHT -> false
            ThemeMode.DARK -> true
        }

    SideEffect {
        (context as? ComponentActivity)?.enableEdgeToEdge(
            statusBarStyle =
                SystemBarStyle.auto(Color.TRANSPARENT, Color.TRANSPARENT) { darkTheme },
            navigationBarStyle =
                SystemBarStyle.auto(Color.TRANSPARENT, Color.TRANSPARENT) { darkTheme },
        )
    }

    MomentumTheme(darkTheme = darkTheme) {
        Surface(Modifier.fillMaxSize()) {
            when (val current = state) {
                RootUiState.Loading -> LoadingState(message = "Momentum wird vorbereitet")
                is RootUiState.Error -> ErrorState(current.message, rootViewModel::retry)
                is RootUiState.Ready -> {
                    if (current.settings.onboardingCompleted) {
                        MomentumMain(container = container)
                    } else {
                        OnboardingScreen(
                            onFinish = rootViewModel::completeOnboarding,
                            onSkip = rootViewModel::completeOnboarding,
                        )
                    }
                }
            }
        }
    }
}

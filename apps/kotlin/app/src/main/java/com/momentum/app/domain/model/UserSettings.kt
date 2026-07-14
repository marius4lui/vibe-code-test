package com.momentum.app.domain.model

data class UserSettings(
    val onboardingCompleted: Boolean = false,
    val themeMode: ThemeMode = ThemeMode.SYSTEM,
)

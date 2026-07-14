package com.momentum.app.domain.repository

import com.momentum.app.domain.model.ThemeMode
import com.momentum.app.domain.model.UserSettings
import kotlinx.coroutines.flow.Flow

interface SettingsRepository {
    fun observeSettings(): Flow<UserSettings>

    suspend fun getSettings(): UserSettings

    suspend fun setOnboardingCompleted(completed: Boolean)

    suspend fun setThemeMode(mode: ThemeMode)
}

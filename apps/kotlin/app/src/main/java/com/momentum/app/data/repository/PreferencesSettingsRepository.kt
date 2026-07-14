package com.momentum.app.data.repository

import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.MutablePreferences
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.booleanPreferencesKey
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.stringPreferencesKey
import com.momentum.app.data.error.MomentumStorageException
import com.momentum.app.data.error.SettingsStorageDecodingException
import com.momentum.app.data.error.SettingsStorageReadException
import com.momentum.app.data.error.SettingsStorageWriteException
import com.momentum.app.domain.model.ThemeMode
import com.momentum.app.domain.model.UserSettings
import com.momentum.app.domain.repository.SettingsRepository
import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.flow.distinctUntilChanged
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.map

class PreferencesSettingsRepository(private val dataStore: DataStore<Preferences>) :
    SettingsRepository {
    override fun observeSettings(): Flow<UserSettings> =
        dataStore.data
            .map(::decodeSettings)
            .catch { cause ->
                when (cause) {
                    is CancellationException -> throw cause
                    is MomentumStorageException -> throw cause
                    else -> throw SettingsStorageReadException(cause)
                }
            }
            .distinctUntilChanged()

    override suspend fun getSettings(): UserSettings = observeSettings().first()

    override suspend fun setOnboardingCompleted(completed: Boolean) {
        editSetting(settingName = "Onboarding-Status") { preferences ->
            preferences[ONBOARDING_COMPLETED_KEY] = completed
        }
    }

    override suspend fun setThemeMode(mode: ThemeMode) {
        editSetting(settingName = "Darstellung") { preferences ->
            preferences[THEME_MODE_KEY] = mode.toStorageKey()
        }
    }

    private fun decodeSettings(preferences: Preferences): UserSettings =
        UserSettings(
            onboardingCompleted = preferences[ONBOARDING_COMPLETED_KEY] ?: false,
            themeMode = preferences[THEME_MODE_KEY]?.toThemeMode() ?: ThemeMode.SYSTEM,
        )

    private suspend fun editSetting(
        settingName: String,
        update: (MutablePreferences) -> Unit,
    ) {
        try {
            dataStore.edit { preferences -> update(preferences) }
        } catch (cause: CancellationException) {
            throw cause
        } catch (cause: MomentumStorageException) {
            throw cause
        } catch (cause: Exception) {
            throw SettingsStorageWriteException(settingName, cause)
        }
    }

    private fun ThemeMode.toStorageKey(): String =
        when (this) {
            ThemeMode.SYSTEM -> THEME_SYSTEM
            ThemeMode.LIGHT -> THEME_LIGHT
            ThemeMode.DARK -> THEME_DARK
        }

    private fun String.toThemeMode(): ThemeMode =
        when (this) {
            THEME_SYSTEM -> ThemeMode.SYSTEM
            THEME_LIGHT -> ThemeMode.LIGHT
            THEME_DARK -> ThemeMode.DARK
            else -> throw SettingsStorageDecodingException("Unbekannter Darstellungsmodus '$this'.")
        }

    private companion object {
        val ONBOARDING_COMPLETED_KEY = booleanPreferencesKey("onboarding_completed")
        val THEME_MODE_KEY = stringPreferencesKey("theme_mode")

        const val THEME_SYSTEM = "system"
        const val THEME_LIGHT = "light"
        const val THEME_DARK = "dark"
    }
}

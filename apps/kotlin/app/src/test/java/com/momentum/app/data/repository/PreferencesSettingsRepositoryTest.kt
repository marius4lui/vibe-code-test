package com.momentum.app.data.repository

import androidx.datastore.preferences.core.PreferenceDataStoreFactory
import com.momentum.app.domain.model.ThemeMode
import com.momentum.app.domain.model.UserSettings
import java.io.File
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.test.runTest
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Before
import org.junit.Rule
import org.junit.Test
import org.junit.rules.TemporaryFolder

class PreferencesSettingsRepositoryTest {
    @get:Rule val temporaryFolder = TemporaryFolder()

    private lateinit var dataStoreScope: CoroutineScope
    private lateinit var repository: PreferencesSettingsRepository

    @Before
    fun setUp() {
        dataStoreScope = CoroutineScope(SupervisorJob() + Dispatchers.IO)
        val preferencesFile = File(temporaryFolder.root, "settings.preferences_pb")
        repository =
            PreferencesSettingsRepository(
                PreferenceDataStoreFactory.create(
                    scope = dataStoreScope,
                    produceFile = { preferencesFile },
                )
            )
    }

    @After
    fun tearDown() {
        dataStoreScope.cancel()
    }

    @Test
    fun `onboarding and dark mode are persisted together`() = runTest {
        assertEquals(UserSettings(), repository.getSettings())

        repository.setOnboardingCompleted(true)
        repository.setThemeMode(ThemeMode.DARK)

        assertEquals(
            UserSettings(onboardingCompleted = true, themeMode = ThemeMode.DARK),
            repository.getSettings(),
        )
    }
}

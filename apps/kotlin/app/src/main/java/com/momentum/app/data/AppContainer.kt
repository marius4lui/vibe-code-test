package com.momentum.app.data

import android.content.Context
import com.momentum.app.data.local.momentumDataStore
import com.momentum.app.data.repository.PreferencesSettingsRepository
import com.momentum.app.data.repository.PreferencesTaskRepository
import com.momentum.app.domain.repository.SettingsRepository
import com.momentum.app.domain.repository.TaskRepository

class AppContainer(context: Context) {
    private val dataStore = context.applicationContext.momentumDataStore

    val taskRepository: TaskRepository = PreferencesTaskRepository(dataStore)
    val settingsRepository: SettingsRepository = PreferencesSettingsRepository(dataStore)
}

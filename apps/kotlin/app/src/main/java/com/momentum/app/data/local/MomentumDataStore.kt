package com.momentum.app.data.local

import android.content.Context
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.preferencesDataStore

private const val MOMENTUM_DATA_STORE_NAME = "momentum_preferences"

val Context.momentumDataStore: DataStore<Preferences> by
    preferencesDataStore(name = MOMENTUM_DATA_STORE_NAME)

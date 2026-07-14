package com.momentum.app.data.repository

import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.PreferenceDataStoreFactory
import androidx.datastore.preferences.core.Preferences
import com.momentum.app.domain.model.TaskCategory
import com.momentum.app.domain.model.TaskDraft
import com.momentum.app.domain.model.TaskPriority
import java.io.File
import java.time.Clock
import java.time.Instant
import java.time.LocalDate
import java.time.LocalTime
import java.time.ZoneOffset
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.test.runTest
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Rule
import org.junit.Test
import org.junit.rules.TemporaryFolder

class PreferencesTaskRepositoryTest {
    @get:Rule val temporaryFolder = TemporaryFolder()

    private lateinit var dataStoreScope: CoroutineScope
    private lateinit var dataStore: DataStore<Preferences>
    private lateinit var repository: PreferencesTaskRepository

    @Before
    fun setUp() {
        dataStoreScope = CoroutineScope(SupervisorJob() + Dispatchers.IO)
        val preferencesFile = File(temporaryFolder.root, "momentum.preferences_pb")
        dataStore =
            PreferenceDataStoreFactory.create(
                scope = dataStoreScope,
                produceFile = { preferencesFile },
            )
        repository =
            PreferencesTaskRepository(
                dataStore = dataStore,
                clock = Clock.fixed(Instant.parse("2026-07-14T10:00:00Z"), ZoneOffset.UTC),
                idFactory = { "11111111-1111-4111-8111-111111111111" },
            )
    }

    @After
    fun tearDown() {
        dataStoreScope.cancel()
    }

    @Test
    fun `seed is written exactly once`() = runTest {
        assertTrue(repository.initializeIfNeeded())
        val firstSeed = repository.listTasks()

        assertFalse(repository.initializeIfNeeded())
        assertEquals(firstSeed, repository.listTasks())
        assertEquals(5, firstSeed.size)
    }

    @Test
    fun `task can be created completed and reopened`() = runTest {
        repository.deleteAll()
        val created =
            repository.create(
                TaskDraft(
                    title = "  Release vorbereiten  ",
                    description = "Checkliste prüfen",
                    category = TaskCategory.WORK,
                    priority = TaskPriority.HIGH,
                    dueDate = LocalDate.of(2026, 7, 14),
                    dueTime = LocalTime.of(16, 30),
                )
            )

        assertEquals("Release vorbereiten", created.title)
        assertFalse(created.isCompleted)
        assertEquals(listOf(created), repository.listTasks())

        val completed = repository.setCompleted(created.id, completed = true)
        assertTrue(completed.isCompleted)
        assertEquals(LocalDate.of(2026, 7, 14), completed.completedOn)

        val reopened = repository.setCompleted(created.id, completed = false)
        assertFalse(reopened.isCompleted)
        assertNull(reopened.completedOn)
    }
}

package com.momentum.app.data.local

import com.momentum.app.data.error.TaskStorageDecodingException
import com.momentum.app.domain.model.MomentumTask
import com.momentum.app.domain.model.TaskCategory
import com.momentum.app.domain.model.TaskPriority
import java.time.LocalDate
import java.time.LocalTime
import org.junit.Assert.assertEquals
import org.junit.Assert.assertThrows
import org.junit.Assert.assertTrue
import org.junit.Test

class TaskStorageCodecTest {
    private val codec = TaskStorageCodec()

    @Test
    fun `task payload round trips without domain serialization annotations`() {
        val task =
            MomentumTask(
                id = "11111111-1111-4111-8111-111111111111",
                title = "Release vorbereiten",
                description = "Checkliste prüfen",
                category = TaskCategory.WORK,
                priority = TaskPriority.HIGH,
                dueDate = LocalDate.of(2026, 7, 14),
                dueTime = LocalTime.of(16, 30),
                isCompleted = true,
                completedOn = LocalDate.of(2026, 7, 14),
                createdAtEpochMillis = 100L,
                updatedAtEpochMillis = 200L,
            )

        assertEquals(listOf(task), codec.decode(codec.encode(listOf(task))))
    }

    @Test
    fun `invalid payload reports a storage decoding exception`() {
        val exception =
            assertThrows(TaskStorageDecodingException::class.java) {
                codec.decode("{\"schema_version\":1,\"tasks\":\"invalid\"}")
            }

        assertTrue(exception.message?.contains("Aufgabendaten sind ungültig") == true)
    }
}

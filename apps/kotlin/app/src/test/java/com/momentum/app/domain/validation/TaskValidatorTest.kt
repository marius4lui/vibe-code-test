package com.momentum.app.domain.validation

import com.momentum.app.domain.model.TaskCategory
import com.momentum.app.domain.model.TaskDraft
import com.momentum.app.domain.model.TaskPriority
import java.time.LocalDate
import java.time.LocalTime
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNull
import org.junit.Assert.assertThrows
import org.junit.Assert.assertTrue
import org.junit.Test

class TaskValidatorTest {
    private val validator = TaskValidator()

    @Test
    fun `all required fields are reported together`() {
        val result = validator.validate(TaskDraft(title = "   "))

        assertFalse(result.isValid)
        assertNull(result.value)
        assertEquals(
            setOf(TaskField.TITLE, TaskField.CATEGORY, TaskField.PRIORITY, TaskField.DUE_DATE),
            result.errors.map(TaskValidationError::field).toSet(),
        )
    }

    @Test
    fun `valid draft is trimmed and time is normalized to minutes`() {
        val result =
            validator.validate(
                validDraft()
                    .copy(
                        title = "  Wochenplanung  ",
                        description = "   ",
                        dueTime = LocalTime.of(9, 45, 32, 100),
                    )
            )

        assertTrue(result.isValid)
        assertEquals("Wochenplanung", result.value?.title)
        assertNull(result.value?.description)
        assertEquals(LocalTime.of(9, 45), result.value?.dueTime)
    }

    @Test
    fun `title and description length limits are enforced`() {
        val result =
            validator.validate(
                validDraft()
                    .copy(
                        title = "T".repeat(TaskValidator.MAX_TITLE_LENGTH + 1),
                        description = "D".repeat(TaskValidator.MAX_DESCRIPTION_LENGTH + 1),
                    )
            )

        assertEquals(TaskValidationCode.TOO_LONG, result.errorFor(TaskField.TITLE)?.code)
        assertEquals(TaskValidationCode.TOO_LONG, result.errorFor(TaskField.DESCRIPTION)?.code)
        assertThrows(TaskValidationException::class.java) {
            validator.validateOrThrow(
                validDraft().copy(title = "T".repeat(TaskValidator.MAX_TITLE_LENGTH + 1))
            )
        }
    }

    private fun validDraft() =
        TaskDraft(
            title = "Wochenplanung",
            description = "Die wichtigsten Schritte festlegen.",
            category = TaskCategory.WORK,
            priority = TaskPriority.HIGH,
            dueDate = LocalDate.of(2026, 7, 14),
            dueTime = LocalTime.of(9, 0),
        )
}

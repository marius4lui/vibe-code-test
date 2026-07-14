package com.momentum.app

import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.hasContentDescription
import androidx.compose.ui.test.hasTestTag
import androidx.compose.ui.test.junit4.v2.createAndroidComposeRule
import androidx.compose.ui.test.onNodeWithContentDescription
import androidx.compose.ui.test.onNodeWithTag
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.performClick
import androidx.compose.ui.test.performTextInput
import androidx.test.ext.junit.runners.AndroidJUnit4
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(AndroidJUnit4::class)
class MomentumUserFlowTest {
    @get:Rule val composeRule = createAndroidComposeRule<MainActivity>()

    @Test
    fun createAndCompleteTask() {
        waitForEither("onboarding_skip", "bottom_tasks")
        if (
            composeRule.onAllNodes(hasTestTag("onboarding_skip")).fetchSemanticsNodes().isNotEmpty()
        ) {
            composeRule.onNodeWithTag("onboarding_skip").performClick()
        }

        composeRule.waitUntil(timeoutMillis = 10_000) {
            composeRule.onAllNodes(hasTestTag("bottom_tasks")).fetchSemanticsNodes().isNotEmpty()
        }
        composeRule.onNodeWithTag("bottom_tasks").performClick()
        composeRule.onNodeWithTag("add_task_fab").performClick()

        val title = "UI-Test Aufgabe ${System.currentTimeMillis()}"
        composeRule.onNodeWithTag("task_title_input").performTextInput(title)
        composeRule.onNodeWithTag("category_personal").performClick()
        composeRule.onNodeWithTag("save_task_button").performClick()

        composeRule.waitUntil(timeoutMillis = 10_000) {
            composeRule
                .onAllNodes(hasTestTag("task_search_input"))
                .fetchSemanticsNodes()
                .isNotEmpty()
        }
        composeRule.onNodeWithTag("task_search_input").performTextInput(title)
        composeRule.onNodeWithText(title).assertIsDisplayed()

        composeRule.onNodeWithContentDescription("$title abschließen").performClick()
        composeRule.waitUntil(timeoutMillis = 10_000) {
            composeRule
                .onAllNodes(hasContentDescription("$title erneut öffnen"))
                .fetchSemanticsNodes()
                .isNotEmpty()
        }
        composeRule.onNodeWithContentDescription("$title erneut öffnen").assertIsDisplayed()
    }

    private fun waitForEither(firstTag: String, secondTag: String) {
        composeRule.waitUntil(timeoutMillis = 10_000) {
            composeRule.onAllNodes(hasTestTag(firstTag)).fetchSemanticsNodes().isNotEmpty() ||
                composeRule.onAllNodes(hasTestTag(secondTag)).fetchSemanticsNodes().isNotEmpty()
        }
    }
}

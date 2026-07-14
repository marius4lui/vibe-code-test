package com.momentum.app.navigation

import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.slideInHorizontally
import androidx.compose.animation.slideOutHorizontally
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.Home
import androidx.compose.material.icons.filled.Settings
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.testTag
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavGraph.Companion.findStartDestination
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.currentBackStackEntryAsState
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import com.momentum.app.data.AppContainer
import com.momentum.app.domain.model.TaskCategory
import com.momentum.app.feature.editor.TaskEditorScreen
import com.momentum.app.feature.editor.TaskEditorViewModel
import com.momentum.app.feature.settings.SettingsScreen
import com.momentum.app.feature.settings.SettingsViewModel
import com.momentum.app.feature.tasks.TasksScreen
import com.momentum.app.feature.tasks.TasksViewModel
import com.momentum.app.feature.today.TodayScreen
import com.momentum.app.feature.today.TodayViewModel
import kotlinx.coroutines.launch

private object Routes {
    const val TODAY = "today"
    const val TASKS = "tasks?category={category}"
    const val TASKS_BASE = "tasks"
    const val SETTINGS = "settings"
    const val CREATE = "task/create"
    const val EDIT = "task/edit/{taskId}"

    fun tasks(category: TaskCategory? = null): String =
        category?.let { "$TASKS_BASE?category=${it.name}" } ?: TASKS_BASE

    fun edit(taskId: String): String = "task/edit/$taskId"
}

private data class BottomDestination(
    val route: String,
    val label: String,
    val icon: ImageVector,
    val testTag: String,
)

private val bottomDestinations =
    listOf(
        BottomDestination(Routes.TODAY, "Heute", Icons.Default.Home, "bottom_today"),
        BottomDestination(Routes.TASKS_BASE, "Aufgaben", Icons.Default.CheckCircle, "bottom_tasks"),
        BottomDestination(
            Routes.SETTINGS,
            "Einstellungen",
            Icons.Default.Settings,
            "bottom_settings",
        ),
    )

@Composable
fun MomentumMain(
    container: AppContainer,
    modifier: Modifier = Modifier,
) {
    val navController = rememberNavController()
    val backStackEntry by navController.currentBackStackEntryAsState()
    val currentRoute = backStackEntry?.destination?.route.orEmpty()
    val isMainDestination =
        currentRoute == Routes.TODAY ||
            currentRoute.startsWith(Routes.TASKS_BASE) ||
            currentRoute == Routes.SETTINGS
    val showAdd = currentRoute == Routes.TODAY || currentRoute.startsWith(Routes.TASKS_BASE)
    val snackbarHostState = remember { SnackbarHostState() }
    val scope = rememberCoroutineScope()

    fun navigateToBottom(route: String) {
        navController.navigate(route) {
            popUpTo(navController.graph.findStartDestination().id) { saveState = true }
            launchSingleTop = true
            restoreState = true
        }
    }

    fun finishEditor(message: String) {
        if (!navController.popBackStack()) navController.navigate(Routes.TASKS_BASE)
        scope.launch { snackbarHostState.showSnackbar(message) }
    }

    Scaffold(
        modifier = modifier,
        contentWindowInsets = WindowInsets(0, 0, 0, 0),
        snackbarHost = { SnackbarHost(snackbarHostState) },
        bottomBar = {
            if (isMainDestination) {
                NavigationBar {
                    bottomDestinations.forEach { destination ->
                        val selected =
                            when (destination.route) {
                                Routes.TASKS_BASE -> currentRoute.startsWith(Routes.TASKS_BASE)
                                else -> currentRoute == destination.route
                            }
                        NavigationBarItem(
                            selected = selected,
                            onClick = { navigateToBottom(destination.route) },
                            icon = { Icon(destination.icon, contentDescription = null) },
                            label = { androidx.compose.material3.Text(destination.label) },
                            modifier = Modifier.testTag(destination.testTag),
                        )
                    }
                }
            }
        },
        floatingActionButton = {
            if (showAdd) {
                FloatingActionButton(
                    onClick = { navController.navigate(Routes.CREATE) },
                    modifier = Modifier.testTag("add_task_fab"),
                ) {
                    Icon(Icons.Default.Add, contentDescription = "Neue Aufgabe")
                }
            }
        },
    ) { innerPadding ->
        NavHost(
            navController = navController,
            startDestination = Routes.TODAY,
            modifier = Modifier.padding(innerPadding),
            enterTransition = {
                fadeIn(tween(200)) + slideInHorizontally(tween(220)) { fullWidth -> fullWidth / 18 }
            },
            exitTransition = {
                fadeOut(tween(140)) +
                    slideOutHorizontally(tween(180)) { fullWidth -> -fullWidth / 24 }
            },
            popEnterTransition = {
                fadeIn(tween(180)) +
                    slideInHorizontally(tween(200)) { fullWidth -> -fullWidth / 24 }
            },
            popExitTransition = {
                fadeOut(tween(140)) +
                    slideOutHorizontally(tween(180)) { fullWidth -> fullWidth / 18 }
            },
        ) {
            composable(Routes.TODAY) {
                val todayViewModel: TodayViewModel =
                    viewModel(factory = TodayViewModel.factory(container.taskRepository))
                TodayScreen(
                    viewModel = todayViewModel,
                    onAddTask = { navController.navigate(Routes.CREATE) },
                    onShowAll = { navigateToBottom(Routes.TASKS_BASE) },
                    onEditTask = { navController.navigate(Routes.edit(it)) },
                    onCategorySelected = { navigateToBottom(Routes.tasks(it)) },
                    snackbarHostState = snackbarHostState,
                )
            }

            composable(
                route = Routes.TASKS,
                arguments =
                    listOf(
                        navArgument("category") {
                            type = NavType.StringType
                            nullable = true
                            defaultValue = null
                        }
                    ),
            ) { entry ->
                val tasksViewModel: TasksViewModel =
                    viewModel(factory = TasksViewModel.factory(container.taskRepository))
                val category =
                    entry.arguments?.getString("category")?.let { raw ->
                        TaskCategory.entries.firstOrNull { it.name == raw }
                    }
                LaunchedEffect(category) { tasksViewModel.setCategory(category) }
                TasksScreen(
                    viewModel = tasksViewModel,
                    onAddTask = { navController.navigate(Routes.CREATE) },
                    onEditTask = { navController.navigate(Routes.edit(it)) },
                    snackbarHostState = snackbarHostState,
                )
            }

            composable(Routes.SETTINGS) {
                val settingsViewModel: SettingsViewModel =
                    viewModel(
                        factory =
                            SettingsViewModel.factory(
                                container.settingsRepository,
                                container.taskRepository,
                            )
                    )
                SettingsScreen(viewModel = settingsViewModel)
            }

            composable(Routes.CREATE) {
                val editorViewModel: TaskEditorViewModel =
                    viewModel(
                        key = "create_task_editor",
                        factory =
                            TaskEditorViewModel.factory(container.taskRepository, taskId = null),
                    )
                TaskEditorScreen(
                    viewModel = editorViewModel,
                    onBack = { navController.popBackStack() },
                    onSaved = ::finishEditor,
                )
            }

            composable(
                route = Routes.EDIT,
                arguments = listOf(navArgument("taskId") { type = NavType.StringType }),
            ) { entry ->
                val taskId = requireNotNull(entry.arguments?.getString("taskId"))
                val editorViewModel: TaskEditorViewModel =
                    viewModel(
                        key = "edit_task_$taskId",
                        factory = TaskEditorViewModel.factory(container.taskRepository, taskId),
                    )
                TaskEditorScreen(
                    viewModel = editorViewModel,
                    onBack = { navController.popBackStack() },
                    onSaved = ::finishEditor,
                )
            }
        }
    }
}

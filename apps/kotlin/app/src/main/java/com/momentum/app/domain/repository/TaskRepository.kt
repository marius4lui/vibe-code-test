package com.momentum.app.domain.repository

import com.momentum.app.domain.model.MomentumTask
import com.momentum.app.domain.model.TaskDraft
import kotlinx.coroutines.flow.Flow

interface TaskRepository {
    fun observeTasks(): Flow<List<MomentumTask>>

    suspend fun listTasks(): List<MomentumTask>

    /** Returns true only for the call that persisted the initial seed. */
    suspend fun initializeIfNeeded(): Boolean

    suspend fun create(draft: TaskDraft): MomentumTask

    suspend fun update(taskId: String, draft: TaskDraft): MomentumTask

    /** Returns the removed task so callers can offer Undo via [restore]. */
    suspend fun delete(taskId: String): MomentumTask

    suspend fun restore(task: MomentumTask): MomentumTask

    suspend fun setCompleted(taskId: String, completed: Boolean): MomentumTask

    /** Clears all tasks without resetting the initial-seed marker. */
    suspend fun deleteAll()
}

sealed class TaskRepositoryException(message: String) : IllegalStateException(message)

class TaskNotFoundException(taskId: String) :
    TaskRepositoryException("Die Aufgabe mit der ID '$taskId' wurde nicht gefunden.")

class DuplicateTaskException(taskId: String) :
    TaskRepositoryException("Eine Aufgabe mit der ID '$taskId' ist bereits vorhanden.")

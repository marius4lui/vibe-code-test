package com.momentum.app.data.error

open class MomentumStorageException(
    message: String,
    cause: Throwable? = null,
) : IllegalStateException(message, cause)

class TaskStorageReadException(cause: Throwable) :
    MomentumStorageException(
        message = "Die lokal gespeicherten Aufgaben konnten nicht gelesen werden.",
        cause = cause,
    )

class TaskStorageWriteException(operation: String, cause: Throwable) :
    MomentumStorageException(
        message = "Die Aufgabe konnte lokal nicht $operation werden.",
        cause = cause,
    )

class TaskStorageDecodingException(
    detail: String,
    cause: Throwable? = null,
) :
    MomentumStorageException(
        message = "Die gespeicherten Aufgabendaten sind ungültig: $detail",
        cause = cause,
    )

class TaskStorageEncodingException(
    detail: String,
    cause: Throwable? = null,
) :
    MomentumStorageException(
        message =
            "Die Aufgabendaten konnten nicht für die lokale Speicherung vorbereitet werden: $detail",
        cause = cause,
    )

class SettingsStorageReadException(cause: Throwable) :
    MomentumStorageException(
        message = "Die lokal gespeicherten Einstellungen konnten nicht gelesen werden.",
        cause = cause,
    )

class SettingsStorageWriteException(setting: String, cause: Throwable) :
    MomentumStorageException(
        message = "Die Einstellung '$setting' konnte nicht lokal gespeichert werden.",
        cause = cause,
    )

class SettingsStorageDecodingException(detail: String) :
    MomentumStorageException(message = "Die gespeicherten Einstellungen sind ungültig: $detail")

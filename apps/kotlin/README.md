# Momentum

Momentum ist eine vollständig lokale Android-App für Aufgaben, Tagesplanung und persönliche Routinen. Die Oberfläche ist mit Kotlin und Jetpack Compose umgesetzt und folgt Material 3, ohne wie eine generische Beispiel-App zu wirken. Es gibt kein Backend, keine Konten, keine kostenpflichtigen Dienste und keine API-Schlüssel.

Die App benötigt mindestens Android 8.0 (API 26), kompiliert gegen Android API 36 und verwendet Java 17.

## Funktionen

- dreiseitiges Onboarding mit Überspringen, Zurück- und Weiter-Navigation
- Dashboard „Heute“ mit:
  - heutigen Aufgaben
  - Anzahl erledigter Aufgaben
  - animierter Fortschrittsanzeige
  - aktuellem Streak
  - Übersicht aller vier Kategorien
- Erstellen, Bearbeiten und Löschen von Aufgaben
- Abschließen und erneutes Öffnen von Aufgaben
- Wiederherstellen einer gelöschten Aufgabe über eine Snackbar-Aktion
- Titel, optionale Beschreibung, Kategorie, Priorität, Datum und optionale Uhrzeit je Aufgabe
- Kategorien Arbeit, Persönlich, Gesundheit und Lernen
- Prioritäten Niedrig, Mittel und Hoch mit eigener Farbsemantik
- Suche in Titel und Beschreibung
- kombinierbare Filter für Status, Kategorie und Priorität
- Bottom Navigation mit Heute, Aufgaben und Einstellungen
- persistenter System-, Light- und Dark-Mode
- Einstellungen zum Löschen aller Aufgaben und erneuten Anzeigen des Onboardings
- dauerhafte lokale Speicherung von Aufgaben, Theme und Onboarding-Status
- Loading-, Empty- und Error-States mit verständlichen Rückmeldungen
- Formularvalidierung mit feldbezogenen Meldungen
- dezente Navigation-, Fortschritts- und Inhaltsanimationen
- responsive Inhaltsbreiten, adaptive Kartenanordnung und Unterstützung von Edge-to-Edge
- zugängliche Beschriftungen, Semantics, ausreichend große Touch-Ziele und gut sichtbare Zustände

## Architektur

Momentum ist eine Single-Activity-App. `MainActivity` setzt ausschließlich den Compose-Root; Navigation und Features bleiben voneinander getrennt. Ein kleiner `AppContainer` übernimmt die manuelle Dependency Injection. Dadurch gibt es keine globale mutable Zustandsquelle und keine zusätzliche DI-Bibliothek.

Die wesentlichen Schichten sind:

- **Presentation:** Compose-Screens, wiederverwendbare Komponenten und je Feature ein ViewModel
- **State und Business Logic:** unveränderliche UI-States, `StateFlow`, Validator, Filter-Engine und Streak-Berechnung
- **Domain:** Modelle und Repository-Schnittstellen ohne Android- oder Serialisierungsdetails
- **Data:** Preferences DataStore, versionierter JSON-Codec und konkrete Repository-Implementierungen
- **Navigation:** Navigation Compose mit getrennten Haupt- und Editor-Zielen
- **Theme:** eigene Material-3-Farben, Typografie und Shapes für Light und Dark

### Unidirectional Data Flow und StateFlow

Die App verwendet einen unidirektionalen Datenfluss:

```text
Preferences DataStore
        ↓ Flow
Repository
        ↓
ViewModel → StateFlow<UiState>
        ↓ collectAsStateWithLifecycle
Compose UI
        ↓ Benutzerereignis
ViewModel → Repository → dataStore.edit(...)
```

Diese Wahl passt zu Compose, weil es eine eindeutige Quelle für den sichtbaren Zustand gibt. Die UI rendert unveränderliche Zustände und delegiert Aktionen an das ViewModel. Persistenz und Business Logic lassen sich dadurch ohne UI testen; gleichzeitig verhindert `collectAsStateWithLifecycle`, dass ein nicht sichtbarer Screen unnötig Flows sammelt. `StateFlow` liefert neuen Collectors stets den aktuellen Zustand und bildet Loading, Content und Error explizit ab.

ViewModels besitzen keine Navigation. Screens erhalten Navigations-Callbacks, und Repository-Interfaces halten die Presentation unabhängig von der konkreten DataStore-Implementierung.

### Lokale Persistenz und Seed-Daten

Aufgaben und Einstellungen liegen im app-internen Preferences DataStore `momentum_preferences`. Aufgaben werden als versionierter kotlinx.serialization-JSON-Payload gespeichert. Domainmodelle tragen bewusst keine Serialisierungsannotationen; stabile Storage-Keys und DTOs befinden sich in der Datenschicht.

Beim ersten Start schreibt `initializeIfNeeded()` in genau einer atomaren `dataStore.edit`-Transaktion:

1. fünf sinnvolle Beispielaufgaben über alle vier Kategorien,
2. den Marker `initial_seed_completed`.

Liste und Marker können daher nicht teilweise geschrieben werden. Weitere Starts legen keine neuen Seed-Daten an. „Alle Aufgaben löschen“ leert die Liste, behält den Marker aber bei, sodass die Beispiele nicht zurückkehren. Erst das Löschen der App-Daten oder eine vollständige Neuinstallation ohne Wiederherstellung eines Android-Backups erzeugt wieder einen echten Erststart.

Datum und Abschlussdatum werden als lokale Kalendertage gespeichert, optionale Uhrzeiten minutengenau. Dadurch gibt es keine UTC-Verschiebung des Aufgabentages. Ein Streak zählt aufeinanderfolgende lokale Kalendertage mit mindestens einer abgeschlossenen Aufgabe; ein noch nicht abgeschlossener aktueller Tag beendet den bis gestern laufenden Streak nicht vorzeitig.

Der Codec lehnt unbekannte Speicherversionen oder ungültige Kategorie-, Prioritäts-, UUID-, Datums- und Statuswerte mit nachvollziehbaren Exceptions ab. DataStore-Schreibvorgänge bleiben atomar.

## Verzeichnisstruktur

```text
apps/kotlin/
├── app/
│   ├── build.gradle.kts
│   └── src/
│       ├── main/
│       │   ├── AndroidManifest.xml
│       │   ├── java/com/momentum/app/
│       │   │   ├── MainActivity.kt
│       │   │   ├── MomentumApplication.kt
│       │   │   ├── MomentumRoot.kt
│       │   │   ├── RootViewModel.kt
│       │   │   ├── data/
│       │   │   │   ├── AppContainer.kt
│       │   │   │   ├── error/
│       │   │   │   ├── local/
│       │   │   │   └── repository/
│       │   │   ├── domain/
│       │   │   │   ├── logic/
│       │   │   │   ├── model/
│       │   │   │   ├── repository/
│       │   │   │   └── validation/
│       │   │   ├── feature/
│       │   │   │   ├── editor/
│       │   │   │   ├── onboarding/
│       │   │   │   ├── settings/
│       │   │   │   ├── tasks/
│       │   │   │   └── today/
│       │   │   ├── navigation/
│       │   │   └── ui/
│       │   │       ├── components/
│       │   │       ├── theme/
│       │   │       └── util/
│       │   └── res/
│       ├── test/          # lokale JVM-Tests
│       └── androidTest/   # Compose-Instrumentationstest
├── build.gradle.kts
├── settings.gradle.kts
└── gradle/wrapper/
```

## Toolchain und Libraries

Alle Versionen sind direkt in den Gradle-Dateien gepinnt. Abhängigkeiten ohne eigene Versionsnummer werden durch die Compose BOM aufeinander abgestimmt.

| Komponente | Version | Begründung |
|---|---:|---|
| Gradle Wrapper | 8.14.5 | reproduzierbarer Build ohne lokal installiertes Gradle |
| Android Gradle Plugin | 8.13.2 | Android-Build, Packaging, Lint und Tests für API 36 |
| Kotlin | 2.3.20 | Sprache und Kotlin-Android-Plugin |
| Kotlin Compose Plugin | 2.3.20 | Compose-Compiler passend zur Kotlin-Version |
| Kotlin Serialization Plugin | 2.3.20 | Codegenerierung für den lokalen JSON-Payload |
| Compose BOM | 2026.06.01 | konsistente Versionen für Compose UI, Foundation, Animation, Material 3, Icons und Tests |
| Activity Compose | 1.13.0 | Compose-Hosting in `MainActivity` und Edge-to-Edge |
| Navigation Compose | 2.9.8 | Bottom Navigation sowie Create-/Edit-Routen |
| Preferences DataStore | 1.2.1 | transaktionale, coroutine-basierte lokale Persistenz |
| Lifecycle Runtime Compose | 2.10.0 | lifecycle-bewusstes Sammeln von Flows in Compose |
| Lifecycle ViewModel Compose | 2.10.0 | ViewModel-Integration und Factory-Unterstützung |
| Kotlin Coroutines Android | 1.11.0 | asynchrone Repository-Operationen und Flows |
| kotlinx.serialization JSON | 1.11.0 | stabiler, versionierter Aufgaben-Payload ohne Reflection |
| JUnit | 4.13.2 | lokale Unit-Tests |
| kotlinx-coroutines-test | 1.11.0 | deterministische Coroutine-Tests |
| AndroidX Test Ext JUnit | 1.3.0 | AndroidJUnit4-Instrumentation |
| AndroidX Test Runner | 1.7.0 | Ausführung von Android- und Compose-Tests |
| Compose UI Test JUnit4 | via BOM 2026.06.01 | zentraler End-to-End-Nutzerfluss über echte Compose-Semantics |

Lifecycle `2.10.0` ist absichtlich gewählt. Lifecycle `2.11.0` verlangt compileSdk 37 und Android Gradle Plugin 9.1; das Projekt ist bewusst und konsistent auf compileSdk 36 sowie AGP 8.13.2 ausgelegt.

Nicht benötigt werden Room, Hilt/Koin, ein Netzwerkstack, Bildladebibliotheken oder externe Datumsbibliotheken.

## Voraussetzungen

- Linux, macOS oder Windows mit einer Shell für den Gradle Wrapper
- JDK 17; `JAVA_HOME` muss auf dieses JDK zeigen
- Android SDK Platform 36
- Android SDK Platform-Tools für `adb`
- Android Studio mit Unterstützung für AGP 8.13.2, wenn die IDE verwendet wird
- für Installation und Instrumentationstests ein Emulator oder Android-Gerät ab API 26
- Internetzugriff beim ersten Gradle-Lauf zum Laden der frei verfügbaren Maven-Abhängigkeiten

Es sind keine API-Schlüssel, Konten oder kostenpflichtigen Dienste erforderlich.

## Installation der Abhängigkeiten

Vom Repository-Root:

```bash
cd apps/kotlin
./gradlew --version
./gradlew :app:dependencies
```

Der Wrapper lädt die festgelegte Gradle-Version und anschließend alle Maven-Abhängigkeiten automatisch. In Android Studio genügt es, `apps/kotlin` als Projekt zu öffnen und den Gradle-Sync abzuwarten.

## Entwicklungsstart

### Android Studio

1. `apps/kotlin` als Projekt öffnen.
2. Gradle-Sync abschließen lassen.
3. Ein Gerät oder einen Emulator ab API 26 auswählen.
4. Die Run-Konfiguration `app` starten.

### Kommandozeile und adb

Verbundene Geräte prüfen, Debug-APK bauen und installieren:

```bash
cd apps/kotlin
adb devices
./gradlew :app:assembleDebug
adb install -r app/build/outputs/apk/debug/app-debug.apk
adb shell am start -n com.momentum.app/.MainActivity
```

Alternativ kombiniert Gradle Build und Installation auf einem verbundenen Gerät:

```bash
cd apps/kotlin
./gradlew :app:installDebug
adb shell am start -n com.momentum.app/.MainActivity
```

## Tests und statische Analyse

### Lokale Unit-Tests

```bash
cd apps/kotlin
./gradlew :app:testDebugUnitTest
```

Der zuletzt ausgeführte Lauf war erfolgreich: **13 von 13 Tests bestanden**, keine Fehler und keine übersprungenen Tests. Abgedeckt sind:

- Aufgabenvalidierung und Normalisierung
- kombinierte Suche und Filter
- Streak-Berechnung
- JSON-Encoding, Decoding und Fehlerfälle
- Seed-once-Verhalten
- Erstellen, Abschließen und erneutes Öffnen einer Aufgabe
- persistenter Onboarding- und Theme-Status

Der HTML-Bericht liegt danach unter `app/build/reports/tests/testDebugUnitTest/index.html`.

### Compose-UI-/Integrationstest

Die Test-APK ohne Gerät kompilieren:

```bash
cd apps/kotlin
./gradlew :app:assembleDebugAndroidTest
```

Der zentrale Test `MomentumUserFlowTest` durchläuft Onboarding, Aufgaben-Tab, Erstellen, Suche und Abschließen einer Aufgabe. Die AndroidTest-APK wurde erfolgreich kompiliert. In der lokalen Umgebung war jedoch weder ein Emulator noch ein physisches Android-Gerät vorhanden; deshalb wurde `connectedDebugAndroidTest` dort nicht ausgeführt.

Mit einem verbundenen Gerät oder laufenden Emulator:

```bash
cd apps/kotlin
adb devices
./gradlew :app:connectedDebugAndroidTest
```

Der Bericht liegt danach unter `app/build/reports/androidTests/connected/debug/index.html`.

### Android Lint

```bash
cd apps/kotlin
./gradlew :app:lintDebug
```

Der HTML-Bericht wird unter `app/build/reports/lint-results-debug.html` erzeugt. Lint ist mit `abortOnError = true` konfiguriert; Fehler lassen den Task fehlschlagen.

## Build

Debug-APK:

```bash
cd apps/kotlin
./gradlew :app:assembleDebug
```

Ausgabe: `app/build/outputs/apk/debug/app-debug.apk`

Release-APK und App Bundle:

```bash
cd apps/kotlin
./gradlew :app:assembleRelease
./gradlew :app:bundleRelease
```

Vollständiger lokaler Check ohne angeschlossenes Gerät:

```bash
cd apps/kotlin
./gradlew :app:testDebugUnitTest :app:lintDebug :app:assembleDebug :app:assembleRelease :app:bundleRelease :app:assembleDebugAndroidTest
```

Build-Artefakte entfernen:

```bash
cd apps/kotlin
./gradlew clean
```

## Bekannte Einschränkungen

- Es gibt bewusst kein Backend, keine Anmeldung, keine Cloud-Synchronisation und keine gemeinsame Aufgabenbearbeitung.
- Optionale Uhrzeiten dienen Anzeige und Sortierung. Die App plant keine Systemalarme, Benachrichtigungen oder Kalendertermine.
- Kategorien und Prioritätsstufen sind fest definiert und können nicht individuell ergänzt werden.
- Die JSON-Liste im Preferences DataStore ist für einen persönlichen, lokalen Aufgabenbestand ausgelegt. Suche und Filter laufen im Speicher; für sehr große Datenmengen wäre eine indizierte Datenbank geeigneter.
- Die aktuelle Speicherversion ist Schema 1. Eine zukünftige inkompatible Schemaänderung benötigt eine explizite Migration.
- Die Oberfläche ist derzeit deutschsprachig; es gibt noch keine weitere Lokalisierung.
- Die AndroidTest-APK kompiliert, der Instrumentationstest wurde in der verfügbaren lokalen Umgebung mangels Emulator oder Gerät jedoch nicht tatsächlich ausgeführt.
- Ein Release-Signing-Setup ist nicht im Repository enthalten. Für Play-Store- oder andere Produktionsveröffentlichungen muss ein eigener, sicher verwahrter Keystore konfiguriert werden.
- Die Daten bleiben app-intern. Da `android:allowBackup="true"` gesetzt ist, können sie abhängig von Android-Version und Geräteeinstellungen Teil des systemverwalteten App-Backups sein. „App-Daten löschen“ entfernt Aufgaben, Einstellungen und Seed-Marker vollständig.

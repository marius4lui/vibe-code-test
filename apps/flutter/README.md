# Momentum

Momentum ist eine lokal arbeitende Task- und Habit-Tracker-App für Android. Sie verbindet eine
fokussierte Tagesansicht mit Aufgabenverwaltung, Fortschritt, Kategorien und einer fortlaufenden
Erledigungsserie. Sämtliche Aufgaben und Einstellungen bleiben auf dem Gerät; die App benötigt
weder Backend noch Benutzerkonto, API-Schlüssel oder kostenpflichtige Dienste.

## Funktionsumfang

- Dreiseitiges Onboarding, das nur bis zum erfolgreichen Abschluss angezeigt wird
- Dashboard für den heutigen Tag mit erledigten und gesamten Aufgaben, Fortschrittsanzeige,
  aktueller Serie und Kategorienübersicht
- Vollständige Aufgabenverwaltung: erstellen, bearbeiten, löschen, erledigen und wieder öffnen
- Aufgabenfelder für Titel, optionale Beschreibung, Kategorie, Priorität, Datum und optionale Uhrzeit
- Vier visuell unterscheidbare Kategorien: Arbeit, Persönlich, Gesundheit und Lernen
- Prioritäten Niedrig, Mittel und Hoch mit konsistenter Farbsemantik
- Suche in Titel und Beschreibung sowie kombinierbare Filter für Status, Kategorie und Priorität
- Bottom Navigation für Heute, Aufgaben und Einstellungen
- Helles, dunkles und systemgesteuertes Material-3-Theme
- Dauerhafte lokale Speicherung von Aufgaben, Theme, Onboarding- und Seed-Status
- Seed-Daten nur beim ersten Start; bereits vorhandene Datensätze werden nicht überschrieben
- Lade-, Leer- und Fehlerzustände mit Wiederholungs- beziehungsweise Korrekturmöglichkeiten
- Formularvalidierung mit Längenbegrenzungen und verständlichen lokalisierten Meldungen
- Deutsche und englische Oberfläche anhand der Gerätesprache
- Responsive Layouts, ausreichend große Touch-Flächen, Semantik-Labels und dezente Animationen

## Architektur

Das Projekt folgt einer Feature-first-Struktur mit klaren Schichtengrenzen:

```text
Presentation (Screens, Widgets, Riverpod State)
                    |
                    v
Domain (Entities, Value Objects, Regeln, Repository-Verträge)
                    ^
                    |
Repositories (Mapping zwischen Domain und Datenmodellen)
                    |
                    v
Data (JSON-Modelle, lokale Hive-Datasources)
```

Die UI löst ausschließlich Aktionen aus und beobachtet unveränderlichen Zustand. Der
`MomentumNotifier` bündelt Ladevorgänge, Business-Operationen, Such-Debouncing und
Fehlerbehandlung. Abgeleitete Riverpod-Provider berechnen gefilterte Listen, Tagesfortschritt,
Serie und Kategoriestatistiken. Repositories kapseln die Persistenz und liefern ausschließlich
Domain-Objekte zurück. Dadurch lassen sich State und Business Logic ohne Android- oder
Widget-Abhängigkeit testen.

Als State Management kommt Riverpod mit Codegenerierung zum Einsatz. Die Wahl liefert einen
expliziten, unidirektionalen Datenfluss, typsichere Abhängigkeiten, kontrollierte Lifecycles und
leicht überschreibbare Provider für Tests, ohne globalen veränderlichen Zustand. Freezed stellt
unveränderliche States, Entities und Datenmodelle bereit. Navigation erfolgt über typisierte
GoRouter-Routen; Theme und Lokalisierung sind zentrale App-Services.

### Lokale Datenhaltung

Hive CE speichert JSON-kompatible Records in zwei versionierten Boxen:

- `momentum_tasks_v1`: ein Record pro Aufgaben-ID
- `momentum_settings_v1`: Theme-Präferenz, Onboarding- und Seed-Status

Beim ersten erfolgreichen Laden werden fehlende Seed-Aufgaben idempotent ergänzt und anschließend
der Seed-Status gespeichert. Die Streak-Berechnung verwendet die tatsächlichen
Erledigungszeitpunkte, nicht das geplante Aufgabendatum.

## Verzeichnisstruktur

```text
apps/flutter/
├── android/                         # Android-Projekt und Build-Konfiguration
├── lib/
│   ├── core/
│   │   ├── app/                     # App-Wurzel und Bootstrap
│   │   ├── data/local/              # Hive-Abstraktion
│   │   ├── errors/                  # App-weite Fehlerobjekte
│   │   ├── extensions/              # UI-, Datum- und Formatierungshelfer
│   │   ├── router/                  # Typisierte Routen und Router
│   │   ├── services/                # Lokales Fehler-Logging
│   │   ├── testing/                 # Stabile Widget-Selektoren
│   │   ├── theme/                   # Material-3-Theme und Design-Tokens
│   │   ├── time/                    # Testbare Clock-Abstraktion
│   │   └── widgets/                 # Wiederverwendbare UI-Bausteine
│   ├── features/
│   │   ├── dashboard/               # Tagesdashboard und Kennzahlen
│   │   ├── momentum/                # Zentraler State und Business Logic
│   │   ├── navigation/              # Bottom-Navigation und App-Shell
│   │   ├── onboarding/              # Dreiseitiger Einstieg
│   │   ├── settings/                # Theme und lokale Präferenzen
│   │   ├── startup/                 # Lade- und Routing-Entscheidung
│   │   └── tasks/                   # Domain, Datenzugriff und Aufgaben-UI
│   ├── l10n/                        # ARB-Quellen und generierte Übersetzungen
│   ├── main.dart                    # Produktions-Einstiegspunkt
│   └── main_dev.dart                # Separater Flutter-Driver-Einstiegspunkt
├── test/                            # Unit-, State- und Widget-Tests
├── analysis_options.yaml            # Strikte Analyse inklusive Riverpod-Regeln
├── build.yaml                       # Codegen-Konfiguration
├── l10n.yaml                        # Lokalisierungskonfiguration
└── pubspec.yaml                     # Abhängigkeiten und App-Metadaten
```

Generierte Dateien (`*.g.dart`, `*.freezed.dart` und die Dart-Lokalisierungen) werden nicht manuell
bearbeitet.

## Verwendete Libraries

| Library | Zweck und Begründung |
| --- | --- |
| Flutter / Material 3 | Plattformgerechte Android-UI ohne zusätzliches UI-Framework |
| `flutter_riverpod` + `riverpod_annotation` | Typsicheres State Management mit gut testbaren Provider-Abhängigkeiten |
| `riverpod_generator` | Generiert Provider-APIs und reduziert fehleranfällige manuelle Verkabelung |
| `freezed_annotation` + `freezed` | Unveränderliche States, Entities und Datenmodelle mit sicherem `copyWith` |
| `go_router` + `go_router_builder` | Offizielle deklarative Flutter-Navigation mit typisierten Routen |
| `hive_ce_flutter` | Schnelle, vollständig lokale Persistenz ohne nativen Datenbankserver |
| `json_annotation` + `json_serializable` | Explizite Serialisierung zwischen Hive-Records und Datenmodellen |
| `flutter_localizations` + `intl` | Deutsche/englische Texte sowie lokale Datums- und Zeitformate |
| `build_runner` | Einheitlicher Generator für Riverpod, Freezed, JSON und Routen |
| `flutter_test` + `flutter_driver` | Unit-, State- und Widget-Tests sowie optionaler Driver-Einstiegspunkt |
| `flutter_lints` + `riverpod_lint` | Statische Qualitäts- und Riverpod-Prüfungen |

Alle Abhängigkeiten sind kostenlos. Die App bindet keine externen APIs, Analytics-, Werbe- oder
Cloud-SDKs ein.

## Voraussetzungen

- Flutter Stable mit Dart `>= 3.12.0` (entwickelt mit Flutter 3.44 / Dart 3.12)
- Android SDK inklusive Platform Tools und einer installierten Android-SDK-Plattform
- Java 17 oder neuer; Flutter kann das mit Android Studio ausgelieferte JDK verwenden
- Ein Android-Gerät mit aktiviertem USB-Debugging oder ein gestarteter Android-Emulator

Die Umgebung lässt sich vorab prüfen:

```bash
flutter doctor -v
flutter devices
```

## Installation

Alle folgenden Befehle werden vom Repository-Root ausgeführt:

```bash
cd apps/flutter
flutter pub get
flutter gen-l10n
dart run build_runner build
```

Bei Änderungen an annotierten Providern, Freezed-Klassen, JSON-Modellen oder Routen müssen die
generierten Dateien aktualisiert werden:

```bash
cd apps/flutter
dart run build_runner build
```

Für fortlaufende Codegenerierung während der Entwicklung:

```bash
cd apps/flutter
dart run build_runner watch
```

## Entwicklungsstart

Gerät oder Emulator auswählen und die Debug-App starten:

```bash
cd apps/flutter
flutter devices
flutter run -d <device-id>
```

Ist genau ein Android-Ziel verbunden, genügt:

```bash
cd apps/flutter
flutter run
```

Ein vorhandener Emulator kann über Flutter gestartet werden:

```bash
flutter emulators
flutter emulators --launch <emulator-id>
```

## Tests und statische Analyse

Die vollständige lokale Prüfung umfasst Formatierung, Analyse und alle Unit-/Widget-Tests:

```bash
cd apps/flutter
dart format --output=none --set-exit-if-changed lib test
dart analyze
flutter test
```

Tests mit ausführlicher Ausgabe:

```bash
cd apps/flutter
flutter test --reporter expanded
```

## Android-Build

Debug-APK für lokale Installation:

```bash
cd apps/flutter
flutter build apk --debug
```

Optimierter lokaler Release-Check:

```bash
cd apps/flutter
flutter build apk --release
```

Die Artefakte liegen anschließend unter `build/app/outputs/flutter-apk/`. Für eine Veröffentlichung
im Play Store muss vor dem Build eine eigene Keystore-Signierung eingerichtet und die lokale
Debug-Signierung in `android/app/build.gradle.kts` ersetzt werden.

## Bekannte Einschränkungen

- Es wird ausschließlich Android unterstützt; iOS-, Web- und Desktop-Projekte sind nicht enthalten.
- Daten bleiben nur in der lokalen App-Sandbox. Es gibt bewusst keine Anmeldung, Cloud-Synchronisierung
  oder geräteübergreifende Wiederherstellung.
- Android-Backups sind deaktiviert. Eine Deinstallation oder das Löschen der App-Daten entfernt daher
  Aufgaben und Einstellungen dauerhaft.
- Erinnerungsbenachrichtigungen und Hintergrundjobs sind nicht Bestandteil dieses lokalen Scopes.
- Der enthaltene Release-Build ist für lokale Verifikation mit dem Android-Debug-Key signiert und
  nicht unmittelbar für eine Store-Veröffentlichung vorgesehen.
- Die UI ist auf Deutsch und Englisch verfügbar; andere Gerätesprachen fallen auf Englisch zurück.

# Momentum

Momentum ist eine lokal arbeitende Android-App für Tagesplanung und beständige Routinen. Aufgaben werden nach Kategorie und Priorität organisiert, der Tagesfortschritt bleibt sichtbar und eine fortlaufende Serie macht tägliche Abschlüsse greifbar. Die App benötigt weder Konto noch Backend, Cloud-Dienst oder API-Schlüssel.

## Funktionen

- dreiseitiges, persistiertes Onboarding mit Überspringen- und Zurück-Navigation
- Dashboard für den aktuellen Tag mit erledigt/offen, Fortschrittsbalken, Streak, überfälligen Aufgaben und Kategorien
- Aufgaben erstellen, bearbeiten, löschen, abschließen und wieder öffnen
- Titel, optionale Beschreibung, Kategorie, Priorität, lokales Datum und optionale Uhrzeit
- vier semantische Kategorien: Arbeit, Persönlich, Gesundheit und Lernen
- Suche in Titel und Beschreibung
- kombinierbare Filter nach Status, Kategorie und Priorität
- versionierte lokale Persistenz mit einmaligen Seed-Daten beim allerersten Start
- persistierte Darstellungseinstellung: System, Hell oder Dunkel
- Material-3-Oberfläche, responsive Inhaltsbreiten, große Touch-Flächen und Screenreader-Labels
- Lade-, Fehler- und differenzierte Leerzustände
- dezente Einblend-, Layout- und Haptik-Rückmeldungen
- eigene Android-App-, Adaptive- und Splash-Assets

Der Streak zählt aufeinanderfolgende lokale Kalendertage mit mindestens einem echten Aufgabenabschluss. Ist heute noch nichts erledigt, bleibt eine bis gestern bestehende Serie erhalten. Wiederöffnen einer Aufgabe aktualisiert den Streak korrekt.

## Architektur

Die App verwendet React Context mit `useReducer`. Für diesen klar abgegrenzten lokalen Zustand ist das ein etabliertes React-Konzept ohne zusätzliche Store-Abhängigkeit. Der Reducer bleibt rein und testbar; UI-Komponenten greifen ausschließlich über typisierte Actions und Selektoren auf Businesslogik zu. AsyncStorage liegt hinter einem injizierbaren Adapter, wodurch Tests denselben echten State-Flow mit einem In-Memory-Speicher ausführen können.

Die Schichten sind bewusst getrennt:

- `app`: ausschließlich Expo-Router-Routen und Navigation
- `features`: Screens, Feature-Komponenten, Validierung und Selektoren
- `state`: Context, Actions, Hydration, Persistenzqueue und reiner Reducer
- `storage`: AsyncStorage-Adapter, Serialisierung und strikte Laufzeitvalidierung
- `models`: Datenmodelle und erlaubte Werte
- `theme`: synchronisiertes Paper-, Router-, Statusbar- und Android-System-Theme
- `components`: wiederverwendbare, domänenarme UI-Bausteine
- `utils`: lokale Datumsdarstellung, Formatierung und ID-Erzeugung

Persistierte Daten tragen eine Schema-Version. Beschädigte oder unbekannte Daten werden nicht stillschweigend überschrieben, sondern führen zu einem verständlichen Fehlerzustand mit Wiederholen- und bestätigtem Reset-Pfad. `didSeed` ist unabhängig von der Aufgabenliste gespeichert; das Löschen aller Aufgaben erzeugt daher nie erneut Demo-Daten.

## Verzeichnisstruktur

```text
apps/expo/
├── assets/
│   ├── brand/                  # editierbare SVG-Quellen
│   └── images/                 # Android- und Splash-PNGs
├── src/
│   ├── app/                    # Expo Router: Gate, Onboarding, Tabs, Editor
│   ├── components/             # Brand, Empty/Error/Loading, Layout
│   ├── data/                   # Kategorien und einmalige Seed-Erzeugung
│   ├── features/
│   │   ├── dashboard/
│   │   ├── settings/
│   │   └── tasks/              # Form, Cards, Screens, Selektoren, Validierung
│   ├── models/
│   ├── state/
│   ├── storage/
│   ├── theme/
│   ├── utils/
│   └── __tests__/              # zentraler Router-Integrationstest
├── app.json
├── eslint.config.js
├── jest.config.js
├── package.json
└── tsconfig.json
```

## Verwendete Libraries

| Library                                      | Zweck und Begründung                                                         |
| -------------------------------------------- | ---------------------------------------------------------------------------- |
| Expo SDK 57 / React Native 0.86 / TypeScript | stabile Managed-Toolchain für Expo Go und Android                            |
| Expo Router                                  | dateibasierte, typisierte Stack- und Bottom-Tab-Navigation                   |
| React Native Paper                           | ausgereifte, reine JavaScript-Umsetzung von Material 3                       |
| AsyncStorage 2.2                             | in Expo Go enthaltene, dauerhafte lokale Speicherung                         |
| Community DateTimePicker 9.1                 | in Expo Go enthaltener nativer Android-Datums-/Zeitdialog                    |
| Material Design Icons                        | dynamisch über `expo-font` geladene, verständliche Symbole ohne Custom Build |
| Expo Haptics                                 | dezente Systemrückmeldung bei Abschluss und Speichern                        |
| Jest Expo + React Native Testing Library     | Android-nahe Unit- und UI-/Router-Integrationstests                          |
| ESLint + Prettier                            | statische Prüfung und reproduzierbare Formatierung                           |

Es werden keine Abhängigkeiten verwendet, die einen eigenen Development Build, kostenpflichtigen Dienst oder externen Schlüssel voraussetzen.

## Voraussetzungen

- Node.js `22.13` oder neuer (geprüft mit `22.22.2`)
- npm `10` oder neuer
- Android-Gerät mit USB-Debugging oder Android-Emulator
- Expo Go passend zu SDK 57

Zum Zeitpunkt der Umsetzung ist Expo Go für SDK 57 auf Android bereits kompatibel, aber noch nicht als aktuelle Play-Store-Version verteilt. Falls die installierte Expo-Go-App SDK 57 nicht unterstützt, lässt sich die passende offizielle APK über die Expo-CLI beziehen:

```bash
npx expo-go download android 57.0.0
adb install -r Expo-Go-*.apk
```

## Installation

Vom Repository-Root:

```bash
cd apps/expo
npm install
```

Die Expo-Kompatibilitätsmatrix kann zusätzlich geprüft werden:

```bash
npx expo install --check
```

## Entwicklungsstart

Metro starten und anschließend den QR-Code mit Expo Go öffnen:

```bash
cd apps/expo
npm start
```

Ein verbundenes Android-Gerät oder einen laufenden Emulator direkt öffnen:

```bash
cd apps/expo
npm run android
```

Im interaktiven Metro-Terminal ist `a` gleichbedeutend mit dem Android-Start.

## Tests und Qualität

```bash
npm test
npm run lint
npm run typecheck
npm run format:check
npm run doctor
```

Enthalten sind:

- Validierungstests für Pflichtfelder, Längen, Kategorie, Priorität, Datum und Uhrzeit
- Reducer-Test für Erstellen, Abschließen und Wiederöffnen inklusive Immutabilität
- UI-/Integrationstest mit echtem Expo Router, Formular, Context/Reducer und In-Memory-Persistenz für den Flow „Aufgabe erstellen und abschließen“

## Android-Build-Check

Der maximale lokale Managed-Workflow-Check ohne generiertes natives Projekt bündelt die vollständige Android-App mit Hermes/Metro:

```bash
npm run build:android-check
```

Das Ergebnis liegt in `dist/`. Es ist ein geprüftes Android-Bundle für den Expo-Managed-Workflow, keine installierbare APK. Eine APK/AAB kann bei Bedarf anschließend mit einem regulären Expo/EAS-Produktionsbuild erzeugt werden; das ist für Expo Go und die lokale Entwicklung nicht erforderlich.

## Bekannte Einschränkungen

- Alle Daten bleiben ausschließlich auf dem aktuellen Gerät. Es gibt bewusst keinen Sync, Account oder Export.
- AsyncStorage ist lokaler App-Speicher, aber keine verschlüsselte Datenbank. Es werden daher keine sensiblen Zugangsdaten gespeichert.
- Erinnerungsbenachrichtigungen sind nicht enthalten; Datum und Uhrzeit dienen der Planung und Sortierung.
- Ohne gestarteten Emulator oder verbundenes Android-Gerät kann die UI lokal nicht als APK installiert werden. Lint, Typprüfung, Tests, Expo Doctor und Android-Bundle-Export funktionieren unabhängig davon.

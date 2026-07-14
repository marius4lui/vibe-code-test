# Benchmark-Protokoll

## Ziel

Der Benchmark untersucht, wie zuverlässig ein KI-Agent aus demselben Produktauftrag eine wartbare Android-App erzeugt. Bewertet werden One-Shot-Fähigkeit, Reparaturverhalten und Änderbarkeit. Das Protokoll trennt Agentenleistung von Unterschieden in Hardware, Toolchain und Hilfestellung.

## Vor dem ersten Run

Für alle drei Runs festhalten:

- Datum und Zeitzone
- KI-Produkt, exakter Modellname beziehungsweise Snapshot und Reasoning-Modus
- maximales Zeitlimit pro Phase
- maximal eine Korrekturrunde in Phase B
- Betriebssystem und Rechner
- Android-Gerät oder Emulator, Android-Version, API-Level, Auflösung und Dichte
- Java-, Node-, npm-/pnpm-, Flutter-, Dart-, Android-SDK- und Gradle-Versionen, soweit relevant
- Messwerkzeug und Methode für App-Größe und Cold Start
- Netzwerk- und Cache-Regel: empfohlen sind geleerte projektspezifische Build-Caches, aber vorinstallierte globale SDKs

Ein manueller Eingriff ist jede Änderung, Auswahl oder zusätzliche inhaltliche Hilfe außerhalb des veröffentlichten Prompts. Reine Bestätigungen für technisch notwendige Berechtigungsdialoge werden separat als Tool-/Berechtigungsinteraktion protokolliert.

## Isolation und Git

Alle Branches müssen vom exakt gleichen Baseline-Commit starten. Zwei sichere Varianten:

### Variante A: nacheinander

```bash
git switch main
git switch -c benchmark/expo benchmark-baseline
# Expo Phasen durchführen und committen
git switch main
git switch -c benchmark/flutter benchmark-baseline
# Flutter Phasen durchführen und committen
git switch main
git switch -c benchmark/kotlin benchmark-baseline
```

### Variante B: separate Worktrees

```bash
git worktree add ../vibe-benchmark-expo -b benchmark/expo benchmark-baseline
git worktree add ../vibe-benchmark-flutter -b benchmark/flutter benchmark-baseline
git worktree add ../vibe-benchmark-kotlin -b benchmark/kotlin benchmark-baseline
```

Bei parallelen Worktrees dürfen nicht gleichzeitig Emulator-, Gradle- oder Package-Manager-Ressourcen verändert werden, wenn dadurch ein Run den anderen beeinflusst. Für maximale Vergleichbarkeit die Runs nacheinander durchführen.

## Phase A: One-Shot

1. Neuen Chat öffnen.
2. Den passenden Prompt (`expo-prompt.md`, `flutter-prompt.md` oder `kotlin-prompt.md`) unverändert senden.
3. Keine zusätzlichen Hinweise geben.
4. Start- und Endzeit erfassen.
5. Nach Abschluss selbst Build, Lint/static analysis und Tests entsprechend der README des erzeugten Projekts wiederholen.
6. App auf demselben Zielgerät installieren und die Anforderungs-Checkliste manuell prüfen.
7. Ergebnisse, Bugs, Dateienzahl und sichtbare Warnungen dokumentieren.
8. Commit erstellen:

   ```bash
   git add apps/<stack> results/<stack>.md
   git commit -m "benchmark(<stack>): complete phase A one-shot"
   ```

Der Agent darf in Phase A seine eigenen Prüfungen und Reparaturen innerhalb desselben Runs durchführen, weil dies Teil des Master-Prompts ist. Eine weitere Nachricht des Menschen zählt bereits als zusätzlicher KI-Run.

## Phase B: eine Fehlerbehebungsrunde

Im selben Framework-Chat exakt den Inhalt aus `prompts/phase-b-fix.md` senden. Keine individuellen Fehlermeldungen oder Hinweise ergänzen. Danach alle Messungen erneut durchführen und committen:

```bash
git add apps/<stack> results/<stack>.md
git commit -m "benchmark(<stack>): complete phase B repair"
```

## Phase C: Änderbarkeit

Im selben Framework-Chat exakt den Inhalt aus `prompts/phase-c-recurring.md` senden. Prüfen:

- täglich, wöchentlich und monatlich auswählbar
- Wiederholung wird persistent gespeichert
- Erstellen und Bearbeiten funktionieren
- nächste Fälligkeit beziehungsweise wiederkehrende Instanz verhält sich nachvollziehbar
- bestehende Daten bleiben kompatibel
- bestehende Tests bleiben grün und neue Logik ist getestet
- kein grundlegender Architektur-Neubau

Anschließend committen:

```bash
git add apps/<stack> results/<stack>.md
git commit -m "benchmark(<stack>): complete phase C recurring tasks"
```

## Objektive Messungen

### Dateien und Codeumfang

Zähle Dateien im App-Verzeichnis ohne generierte Artefakte, Dependency-Verzeichnisse und VCS-Metadaten. Dokumentiere den verwendeten Befehl. Empfohlen:

```bash
find apps/<stack> -type f \
  ! -path '*/node_modules/*' ! -path '*/build/*' ! -path '*/.dart_tool/*' \
  ! -path '*/.gradle/*' ! -path '*/.expo/*' | wc -l
```

### Installierte App-Größe

Auf demselben Gerät, im gleichen Build-Modus und nach einer frischen Installation messen. Debug-Größen nicht mit Release-Größen mischen. Primär APK/AAB-Dateigröße und optional installierte Paketgröße mit `adb shell dumpsys package` beziehungsweise `adb shell du` dokumentieren. Expo Go selbst ist nicht als App-Größe der Expo-Anwendung vergleichbar; für Expo daher zusätzlich die JavaScript-Bundle-/Exportgröße ausweisen und den methodischen Unterschied markieren.

### Cold Start

Mindestens fünf Messungen nach erzwungenem Stop durchführen, erste Aufwärmmessung verwerfen und Median berichten:

```bash
adb shell am force-stop <package-id>
adb shell am start -W -n <package-id>/<activity>
```

Für Expo Go ist der Start über den Host nicht direkt mit installierten nativen Release-Apps vergleichbar. Deshalb entweder alle Stacks in einem vergleichbaren Debug-Szenario messen oder Expo separat kennzeichnen; keine Scheingenauigkeit in die 5-Punkte-Wertung einfließen lassen.

### UI-Bewertung

Screenshots auf identischem Gerät in Light und Dark Mode aufnehmen: Onboarding, Dashboard, Aufgabenliste, Formular, leerer Zustand und Einstellungen. Drei Bewertende oder eine verblindete, feste Rubrik sind besser als eine spontane Einzelmeinung. Mittelwert und Begründung dokumentieren.

## Akzeptanzprüfung

Jede Anforderung wird mit `erfüllt`, `teilweise` oder `nicht erfüllt` markiert. `Teilweise` zählt als halber Punkt innerhalb der jeweiligen Unterrubrik. Eine Funktion gilt nur als erfüllt, wenn sie über die UI erreichbar ist, tatsächlich arbeitet und einen App-Neustart überlebt, sofern Persistenz betroffen ist.

Mindestens prüfen:

- drei Onboarding-Seiten; Status bleibt gespeichert
- Dashboard: heute, erledigt, Fortschritt, Streak, Kategorien
- Aufgabe erstellen, bearbeiten, löschen, abschließen und erneut öffnen
- Titel, optionale Beschreibung, Kategorie, Priorität, Datum, optionale Uhrzeit
- mindestens vier Kategorien
- Suche sowie Filter nach Status, Kategorie und Priorität
- Daten, Einstellungen und Theme persistent
- Light/Dark Mode
- Tabs Heute, Aufgaben und Einstellungen
- Empty-, Loading- und Error-State erreichbar beziehungsweise testbar
- Formularvalidierung mit verständlichen Meldungen
- Animationen und Übergänge
- responsive Darstellung auf mindestens zwei Bildschirmgrößen
- Seed-Daten ausschließlich beim ersten Start
- Barrierefreiheit: Touch-Ziele, Labels, Kontrast und Textskalierung
- mindestens drei ausführbare Tests gemäß Prompt

## Fairness- und Abbruchregeln

- Läuft ein Run ins Zeitlimit, wird der vorhandene Zustand unverändert bewertet.
- Fehlende SDKs auf dem Benchmark-Rechner sind Infrastrukturfehler und werden vor dem Run behoben; vom Agenten falsch gewählte oder inkompatible Dependencies sind Produktfehler.
- Ein manuell korrigierter Build kann weiter bewertet werden, verliert aber den One-Shot-Build-Anteil und der Eingriff muss vollständig protokolliert werden.
- Kein Framework darf nachträglich zusätzliche Hinweise, mehr Zeit oder mehr Korrekturrunden erhalten.
- Bekannte Toolchain-Warnungen werden nicht als App-Fehler gezählt, aber mit Quelle dokumentiert.

## Abschluss

Nach allen Runs die Einzelpunkte aus den Ergebnisdateien nach `scorecard.md` übertragen. Neben der Gesamtpunktzahl immer Phase-A-Build, Zahl manueller Eingriffe und Aufwand von Phase C prominent berichten; diese Kennzahlen dürfen nicht durch eine gute UI-Gesamtnote verdeckt werden.

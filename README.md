# Momentum Vibe-Mobile-Benchmark

Kontrollierter Vibe-Coding-Benchmark für drei moderne Android-Stacks:

- Expo / React Native mit TypeScript und Expo Router
- Flutter mit Dart und Material 3
- Native Android mit Kotlin, Jetpack Compose, Material 3 und Navigation Compose

Verglichen wird nicht nur das visuelle Ergebnis. Im Mittelpunkt stehen ein erfolgreicher erster Build, Anforderungsabdeckung, notwendige Reparaturen, Testbarkeit und die Erweiterbarkeit um wiederkehrende Aufgaben.

## Festgelegte KI-Konfiguration

Für alle drei Benchmark-Runs wird dieselbe Codex-Konfiguration verwendet:

| Einstellung | Wert |
|---|---|
| Codex-Modell | `gpt-5.6-sol` |
| Reasoning-Level | `ultra` |
| Ausführung | interaktive Codex-CLI-Sitzung |
| Sandbox | `danger-full-access` |
| Bestätigungen | `never` |

Die weitreichende Sandbox-Konfiguration ist für diesen kontrollierten lokalen Benchmark vorgesehen, damit Dependency-Installation sowie Zugriffe auf Android-, Gradle-, Flutter- und Paketmanager-Caches nicht durch unterschiedliche Freigaben beeinflusst werden. Sie sollte nur auf einem vertrauenswürdigen Benchmark-Rechner verwendet werden.

## Repository

```text
.
├── apps/
│   ├── expo/
│   ├── flutter/
│   └── kotlin/
├── prompts/
│   ├── base-prompt.md
│   ├── expo-prompt.md
│   ├── flutter-prompt.md
│   ├── kotlin-prompt.md
│   ├── phase-b-fix.md
│   └── phase-c-recurring.md
├── results/
│   ├── expo.md
│   ├── flutter.md
│   └── kotlin.md
├── BENCHMARK.md
└── scorecard.md
```

Die Verzeichnisse unter `apps/` enthalten in der Baseline absichtlich keinen Quellcode. Jeder Agent muss sein Projekt vollständig selbst erzeugen.

## Schnellstart

1. Baseline committen und dessen Hash notieren:

   ```bash
   git add .
   git commit -m "chore: prepare mobile benchmark harness"
   git tag benchmark-baseline
   ```

2. Für jeden Stack einen frischen Branch vom identischen Baseline-Commit anlegen:

   ```bash
   git switch -c benchmark/expo benchmark-baseline
   git switch -c benchmark/flutter benchmark-baseline
   git switch -c benchmark/kotlin benchmark-baseline
   ```

   Die Befehle werden nicht direkt nacheinander in derselben Working Copy ausgeführt. Pro Run zuerst zum Baseline-Stand zurückkehren oder separate Git-Worktrees verwenden; Details stehen in [BENCHMARK.md](BENCHMARK.md).

3. Einen komplett neuen Chat öffnen, den passenden Prompt aus `prompts/` unverändert übergeben und im zugehörigen `apps/<stack>/` arbeiten lassen.
4. Nach jeder Phase committen und Messwerte sofort in `results/<stack>.md` eintragen.
5. Nach allen Runs die Punkte in `scorecard.md` übertragen.

## Codex-Startbefehle

Die drei Runs werden nacheinander in getrennten Terminals gestartet. Jeder Befehl erzeugt einen neuen Codex-Chat:

```bash
cd ../vibe-benchmark-expo && codex \
  --model gpt-5.6-sol \
  --config 'model_reasoning_effort="ultra"' \
  --sandbox danger-full-access \
  --ask-for-approval never \
  "$(cat prompts/expo-prompt.md)"
```

```bash
cd ../vibe-benchmark-flutter && codex \
  --model gpt-5.6-sol \
  --config 'model_reasoning_effort="ultra"' \
  --sandbox danger-full-access \
  --ask-for-approval never \
  "$(cat prompts/flutter-prompt.md)"
```

```bash
cd ../vibe-benchmark-kotlin && codex \
  --model gpt-5.6-sol \
  --config 'model_reasoning_effort="ultra"' \
  --sandbox danger-full-access \
  --ask-for-approval never \
  "$(cat prompts/kotlin-prompt.md)"
```

Phase A startet jeweils mit diesem Befehl. Phase B und Phase C werden anschließend im selben Framework-Chat mit den unveränderten Folgeprompts fortgeführt. Zwischen den Frameworks wird weder ein Chat fortgesetzt noch `codex resume` verwendet.

## Regeln

- Gleiches Modell, Reasoning-Level, Zeitlimit, Gerät/Emulator und Korrekturbudget.
- Pro Framework ein neuer Chat ohne Kontext aus anderen Runs.
- Im ersten Run keine Hinweise oder manuellen Hilfen geben.
- Nur der Technologieblock unterscheidet die drei Hauptprompts.
- Expo muss in Expo Go funktionieren. Eine inkompatible native Dependency ist ein Benchmark-Fehler; nicht still auf einen Development Build wechseln.
- Keine manuellen Codeänderungen verschweigen. Jede Intervention wird gezählt und beschrieben.
- Build-, Test- und Performancewerte zusammen mit Umgebung und Messmethode dokumentieren.

Die vollständige Durchführung, Definitionen und Messverfahren stehen in [BENCHMARK.md](BENCHMARK.md).

# Momentum Vibe-Mobile-Benchmark – vollständige Phase-A-Auswertung

Stand: 14. Juli 2026 · Arbeitsstand `main` vor dieser Dokumentationsänderung: `6a13704`

## 1. Executive Summary

**Flutter führt das vorläufige Ranking nach Phase A mit 91,67 Punkten an**, vor Expo mit 89,17 und Kotlin/Compose mit 87,43. Der Vorsprung entsteht nicht durch die UI – dort führt Expo –, sondern durch die sauberste Schichtung, die beste Testisolation und vollständig grüne geforderte Testtypen. Dieser technische Vorsprung kostete allerdings mit Abstand am meisten: 1:03:04 Laufzeit, acht Sub-Agenten und 3.875.008 Tokens ohne Cache.

Expo liefert die eigenständigste und sichtbar produktreifste Oberfläche sowie einen grünen zentralen Router-/Persistenzflow. Zwei objektive QA-Gates bleiben rot: Prettier wegen `pnpm-lock.yaml` und Expo Doctor wegen zweier Lockfiles. Der Expo-Export ist keine APK; eine direkte Größenrangfolge mit nativen Debug-APKs wäre methodisch falsch.

Kotlin war der schnellste regulär abgeschlossene Run und verbrauchte am wenigsten Tokens ohne Cache. Architektur und native UI sind stark, aber der einzige Compose-Instrumentationstest ist historisch rot. In der aktuellen Verifikation war A059 nicht erreichbar; die Test-APK kompiliert, der Test zählt trotzdem nicht als erfolgreich.

Phase B und C wurden nicht durchgeführt. Alle Gesamtwerte mit Phase-C-Punkten enthalten daher eine ausdrücklich vorläufige Architekturprognose. Ohne Phase C lautet der belastbarere Zwischenstand: Flutter 87,17/95, Expo 85,67/95, Kotlin 83,43/95.

## 2. Vorläufiges Gesamtranking

| Rang | Stack | vorläufig / 100 | ohne Phase C / 95 | maximale Endspanne | Kurzurteil |
|---:|---|---:|---:|---:|---|
| 1 | Flutter | **91,67** | **87,17** | 87,17–92,17 | technisch am vollständigsten, prozessual am teuersten |
| 2 | Expo | **89,17** | **85,67** | 85,67–90,67 | beste sichtbare Produktqualität, zwei rote QA-Gates |
| 3 | Kotlin + Compose | **87,43** | **83,43** | 83,43–88,43 | effizient und nativ stark, zentraler UI-Test nicht grün |

Die Endspanne setzt den bisherigen Stand plus 0–5 echte Phase-C-Punkte an. Phase B kann die Ausgangswerte noch verändern. Daher: **vorläufiges Ranking nach Phase A**, kein Endranking.

## 3. Vollständige Punktetabelle

| Kategorie | Max. | Expo | Flutter | Kotlin |
|---|---:|---:|---:|---:|
| Build ohne manuelle Codeänderung | 15 | 15,0 | 15,0 | 15,0 |
| Anforderungen vollständig umgesetzt | 20 | 19,67 | 19,67 | 19,33 |
| UI und visuelle Konsistenz | 15 | 13,7 | 12,0 | 13,3 |
| Bedienbarkeit und Navigation | 10 | 9,5 | 9,6 | 9,5 |
| Architektur und Codequalität | 15 | 12,0 | 14,2 | 13,1 |
| Fehlerbehandlung | 5 | 4,5 | 4,7 | 4,5 |
| Tests und Testbarkeit | 10 | 9,8 | 10,0 | 6,5 |
| Performance und App-Größe | 5 | 1,5 | 2,0 | 2,2 |
| Erweiterbarkeit Phase C, vorläufig | 5 | 3,5 | 4,5 | 4,0 |
| **Gesamt** | **100** | **89,17** | **91,67** | **87,43** |
| **ohne Phase C** | **95** | **85,67** | **87,17** | **83,43** |

Kontrolle: Expo `15+19,67+13,7+9,5+12+4,5+9,8+1,5+3,5=89,17`; Flutter `=91,67`; Kotlin `=87,43`. Keine Summe überschreitet 100.

## 4. Objektive Kennzahlen

| Kennzahl | Expo | Flutter | Kotlin + Compose |
|---|---:|---:|---:|
| Phase-A-Dauer | 38:04 | 1:03:04 | 36:12 |
| Root-Agenten | 1 | 1 | 1 |
| Sub-Agenten | 3 | 8 | 3 |
| Projektdateien | 76 | 135 | 67 |
| Source-Dateien | 51 TS/TSX | 101 Dart in `lib` | 38 Main-Kotlin |
| generierte Source-Dateien | 0 | 23 (4.506 Zeilen) | 0 |
| Testdateien | 3 | 3 + 1 Harness | 6 Unit + 1 AndroidTest |
| erneute grüne Tests | 4/4 | 4/4 | 13/13 Unit |
| zusätzlicher UI-Test | in 4/4 enthalten, grün | in 4/4 enthalten, grün | kompiliert; historisch 0/1, aktuell Gerät fehlt |
| größte Source-Datei | 464 Zeilen | 309 Zeilen handgeschrieben | 750 Zeilen |
| aktuelles Artefakt | Export 5.660.371 B | Debug-APK 153.747.996 B | Debug-APK 13.235.469 B |
| Cold Start / Frames | fehlt | fehlt | fehlt |
| menschliche Codeänderungen | 0 | 0 | 0 |

Objektiv messbar bedeutet hier nicht automatisch vergleichbar: Expo-Export, Flutter-Debug-APK und Kotlin-Debug-APK enthalten unterschiedliche Laufzeitanteile. Debug-Artefakte sind keine Release-Größen.

## 5. Anforderungen pro Framework

Die ursprünglichen Ergebnisvorlagen enthielten 31 sichtbare Zeilen trotz verbindlichem Nenner 30. Für die Wertung werden „Erstellen-/Abschließen-Test“ und „zentraler UI-/Integrationstest“ als ein zusammengesetztes Kriterium 30 behandelt; die Testscore-Anker bleiben getrennt.

| # | Anforderung | Expo | Flutter | Kotlin | Kernbeleg |
|---:|---|:---:|:---:|:---:|---|
| 1 | Onboarding, drei Seiten | E | E | E | jeweilige Onboarding-Datei + drei Screenshots |
| 2 | Status persistent | E | E | E | Expo Storage, Flutter Hive-Settings, Kotlin DataStore |
| 3 | heutige Aufgaben | E | E | E | Dashboard/Today-Selektoren bzw. ViewModel |
| 4 | erledigte Anzahl | E | E | E | sichtbare Dashboardwerte + State-Berechnung |
| 5 | Fortschritt | E | E | E | sichtbare Progresskarten |
| 6 | Streak | E | E | E | Selector/Provider/Calculator; Kotlin 3 Unit-Tests |
| 7 | Kategorienübersicht | E | E | E | je vier sichtbare Kategorien |
| 8 | erstellen | E | E | E | UI erreichbar; Tests/Repositorybelege |
| 9 | bearbeiten | E | E | E | Editor-Routen + Updatepfade, Code plausibilisiert |
| 10 | löschen | E | E | E | UI/Dialog/Repositorypfad |
| 11 | abschließen / öffnen | E | E | E | grüne Expo-/Flutter-Flows, grüner Kotlin-Repositorytest |
| 12 | alle Felder | E | E | E | Titel, Beschreibung, Kategorie, Priorität, Datum, Zeit |
| 13 | vier Kategorien | E | E | E | Enums/Seeds + UI |
| 14 | Suche | E | E | E | Titel-/Beschreibungsfilter |
| 15 | Statusfilter | E | E | E | Filter-State + UI |
| 16 | Kategoriefilter | E | E | E | Filter-State + UI |
| 17 | Prioritätsfilter | E | E | E | Filter-State + UI |
| 18 | lokale Persistenz | E | E | E | versionierte Adapter/Hive/Codec; Neustart nicht neu ausgeführt |
| 19 | persistentes Theme | E | E | E | System/Light/Dark im Code; Dark sichtbar, Light nicht |
| 20 | drei Bottom-Tabs | E | E | E | Heute/Aufgaben/Einstellungen sichtbar |
| 21 | leerer Zustand | E | E | E | UI erreichbar laut Code, nicht als Screenshot belegt |
| 22 | Ladezustand | E | E | E | explizite Loading-Komponenten/States |
| 23 | Fehlerzustand | E | E | E | Retry/Reset bzw. ErrorBanner/State |
| 24 | Formularvalidierung | E | E | E | Inline-Regeln + grüne Tests |
| 25 | Animationen | E | E | E | Router/Page/Progress/Card-Übergänge |
| 26 | zwei Bildschirmgrößen | T | T | T | adaptiver Code, aber nur 1080×2296 sichtbar |
| 27 | Seed einmalig | E | E | E | Marker-/Idempotenzlogik; Kotlin explizit getestet |
| 28 | Accessibility/Touch | E | E | E | Semantics/Labels/48-dp-Flächen im Code |
| 29 | Validierungstest | E | E | E | aktuell grün |
| 30 | Create/Complete + UI-Flow | E | E | T | Expo/Flutter zentral grün; Kotlin Repository grün, Compose-Test rot |
|  | **Wert / 30** | **29,5** | **29,5** | **29,0** | Detailbelege: [Expo](expo.md), [Flutter](flutter.md), [Kotlin](kotlin.md) |

„E“ bei nur codeplausibilisierten Zuständen bedeutet: UI-Pfad ist vorhanden und nachvollziehbar verdrahtet, wurde aber nicht in jedem Fall manuell ausgeführt. Die Einzeldateien kennzeichnen das pro Zeile.

## 6. Build-, Lint- und Testergebnisse

### Expo

| Befehl | Exit | Dauer | Ergebnis |
|---|---:|---:|---|
| `npm test -- --ci` | 0 | 12,13 s | 4/4 Tests |
| `npm run lint` | 0 | 10,57 s | 0 Fehler/Warnungen |
| `npm run typecheck` | 0 | 4,16 s | 0 Fehler |
| `npm run format:check` | 1 | 3,98 s | `pnpm-lock.yaml` abweichend |
| `npm run doctor` | 1 | 7,65 s | 19/20; zwei Lockfiles |
| `npm run build:android-check` | 0 | 10,65 s | Export 5.660.371 B |

Setup: erster Test Exit 127 wegen fehlendem `node_modules`; danach `npm ci` 24,40 s ohne Source-Änderung.

### Flutter

| Befehl | Exit | Dauer | Ergebnis |
|---|---:|---:|---|
| `dart format --output=none --set-exit-if-changed .` | 0 | 0,89 s | 105 Dateien, 0 Änderungen |
| `flutter analyze` | 0 | 39,03 s | No issues found |
| `flutter test` | 0 | 20,82 s | 4/4 Tests |
| `flutter build apk --debug` | 0 | 44,83 s | 153.747.996-B-Debug-APK |

Setup: erster Formatlauf ohne Paketkontext Exit 1; nach `flutter pub get` 2,10 s grün. 17 neuere, constraint-inkompatible Pakete wurden gemeldet.

### Kotlin

| Befehl | Exit | Dauer | Ergebnis |
|---|---:|---:|---|
| `./gradlew --no-daemon testDebugUnitTest` | 0 | 20,70 s | 13/13 Tests |
| `./gradlew --no-daemon lintDebug` | 0 | 23,06 s | 0 Issues |
| `./gradlew --no-daemon assembleDebug` | 0 | 25,60 s | 13.235.469-B-Debug-APK |
| `./gradlew --no-daemon assembleDebugAndroidTest` | 0 | 21,75 s | Test-APK 1.102.307 B |
| Compose-Test auf A059 | — | — | aktuell nicht erreichbar; historisch 1/1 rot |

Gradle verwendete Caches. Zwei native Libraries wurden im Debug-Build nicht gestripped.

## 7. UI-Vergleich

Diese Noten sind subjektiv; Grundlage sind ausschließlich die vorhandenen Screenshots, nicht deren Anzahl.

| Aspekt (0–5) | Expo | Flutter | Kotlin |
|---|---:|---:|---:|
| visuelle Hierarchie | 4,8 | 4,1 | 4,6 |
| Konsistenz / Spacing | 4,5 | 4,1 | 4,5 |
| Typografie / Lesbarkeit | 4,6 | 4,1 | 4,4 |
| Light / Dark | 4,2 | 4,0 | 4,2 |
| Zustände / Feedback | 4,5 | 3,7 | 4,2 |
| Eigenständigkeit / Produktqualität | 4,8 | 3,9 | 4,6 |
| **normiert / 15** | **13,7** | **12,0** | **13,3** |

- Expo: dichteste, eigenständigste Produktsprache; besonders Dashboard, Kategorien, Settings und Löschdialog überzeugen.
- Flutter: sehr konsistent und lesbar, aber standardnäher; englische Seed-Texte in deutscher Navigation und das unausgewogene Formular schwächen den Gesamteindruck.
- Kotlin: sehr starkes Onboarding und native Material-Konsistenz; Filterleisten sind dichter, einzelne Seed-Titel ebenfalls englisch.
- Für alle fehlen echte Light-Screens, zweite Bildschirmgröße sowie vollständige sichtbare Loading-/Error-/Empty-Abdeckung.

## 8. Architekturvergleich

| Merkmal | Expo | Flutter | Kotlin |
|---|---|---|---|
| Struktur | Feature-Screens + globale State/Model/Storage-Bereiche | konsequent Feature + Data/Domain/Repo/Presentation | Domain/Data/Feature/Nav/Theme |
| State | Context + Reducer + Selektoren | Riverpod-Codegen + Freezed | ViewModel + StateFlow |
| Persistenz | versionierter AsyncStorage-JSON-Adapter | Hive-Datasources hinter Repositories | Preferences DataStore + versionierter Gesamt-JSON-Codec |
| Navigation | Expo Router | typisierte GoRouter-Routen | Navigation Compose |
| Fehler | Load/Save-State, Retry/Reset | getypter AppError, Operation-Gate, Retry | Repositoryexceptions, Codecvalidierung, ErrorStates |
| Testisolation | injizierbarer Storage/Clock/ID | Provider-Overrides, Fakes, zentrale Keys | injizierbare Clock/IDs, Temp-DataStore |
| Codegen | keiner | 23 Dateien / 50,5 % der `lib`-Zeilen | keiner |
| große Dateien | 464/388/381 | 309/296/204 | 750/517/446 |
| Hauptschuld | globaler Context, zwei Lockfiles | Codegen-/Notifier-Komplexität | monolithische Compose-Screens, Gesamtpayload-Rewrite |
| Phase-C-Prognose | 3,5/5 | 4,5/5 | 4,0/5 |

Flutter besitzt die saubersten formalen Schichtengrenzen. Kotlin erreicht mit weniger Infrastruktur fast dieselbe Wartbarkeit, zahlt aber mit großen UI-Dateien. Expo ist pragmatisch und gut testbar, bindet jedoch zu viele Verantwortungen an einen zentralen Context.

## 9. Token- und Zeiteffizienz

| Metrik | Expo | Flutter | Kotlin |
|---|---:|---:|---:|
| nicht gecachter Input | 891.497 | 3.310.368 | 767.946 |
| gecachter Input | 31.631.872 | 76.932.096 | 34.649.856 |
| Output | 156.184 | 564.640 | 209.144 |
| Reasoning | 59.459 | 225.343 | 86.213 |
| Gesamt inkl. Cache | 32.679.553 | 80.807.104 | 35.626.946 |
| Gesamt ohne Cache | 1.047.681 | 3.875.008 | 977.090 |
| Tokens/min ohne Cache | 27.522 | 61.443 | 26.991 |
| Output / Projektdatei | 2.055 | 4.183 | 3.122 |
| Tool-Aufrufe | 323 | 296 | 324 |
| explizit fehlgeschlagene Tools | 4 | 4 | 3 |
| Build-/Test-Reparaturen | 3 testbezogen | 1 testbezogen + Analyzer-Runden | 2 |
| Abbruch-/Limit | Turn-Abbruch | Nutzungslimit/Turn-Abbruch | keiner |

Kotlin ist nach Gesamtmenge ohne Cache und regulärem Abschluss prozessual am effizientesten. Flutter verarbeitet fast das Vierfache der Kotlin-Menge ohne Cache und nutzt acht statt drei Sub-Agenten. Die niedrigere Flutter-Toolzahl bedeutet keine niedrigere Arbeit: einzelne Toolaufrufe enthielten lange Parallel-/Sammelprüfungen. Cached Tokens werden ausdrücklich nicht als neue oder direkt kostenäquivalente Tokens interpretiert.

## 10. Bekannte Bugs

| Stack | Schwere | Befund |
|---|---|---|
| Expo | Mittel | Expo Doctor rot: `package-lock.json` und `pnpm-lock.yaml` konkurrieren. |
| Expo | Niedrig | Prettier-Check rot ausschließlich für `pnpm-lock.yaml`. |
| Expo | Prozess | Zusätzlicher nativer Gradle-Build beim Turn-Abbruch nicht beendet; kein belastbarer APK-Wert. |
| Flutter | Wartbarkeit | Keine aktuell rote Appprüfung; 17 neuere, constraint-inkompatible Pakete und hoher generierter Anteil. |
| Kotlin | Mittel | Compose-Test matcht in Zeile 48 mehr als einen Textknoten und ist historisch rot. |
| Kotlin | Niedrig | Zwei native Libraries im Debug-Build nicht gestripped. |

## 11. Manuelle Eingriffe

- In allen Phase-A-Agentenläufen: **0 menschliche Codeänderungen**.
- Expo: Root-Turn wurde während des optionalen nativen Builds abgebrochen; Export/Expo-Go-Stand war vorhanden.
- Flutter: Run endete laut Vorgabe durch Nutzungslimit; keine automatische Abwertung der App.
- Kotlin: Instrumentationstest wurde nach Root-Abschluss extern auf A059 verifiziert; aktuell war das Gerät nicht erreichbar.
- Aktuelle QA-Setups: `npm ci` und `flutter pub get`; beide erzeugten nur ignorierte Abhängigkeits-/Builddaten und keine versionierten App-Änderungen.
- Screenshoterstellung/-ablage war eine externe Verifikation, kein Beleg für automatisierte Testabdeckung.

## 12. Methodische Einschränkungen

1. Phase B und C fehlen vollständig; Phase-C-Punkte sind nur Prognosen.
2. Keine vergleichbaren Cold-Start-, Frame-, installierten Größen- oder Release-Artefaktmessungen.
3. Expo Go besitzt keinen sinnvoll direkt vergleichbaren Host-App-Größenwert; Export ist keine APK.
4. Flutter-/Kotlin-Größen sind Debug-APKs, keine Releasegrößen.
5. Re-Verifikationszeiten sind Warm-Cache-Läufe und keine fairen Cold-Build-Zeiten.
6. A059 war für die aktuelle Kotlin-Instrumentation nicht erreichbar; historischer Fehler bleibt sekundär dokumentiert.
7. Nur eine Screenshotauflösung (1080×2296) ist belegt; zweite Größe fehlt bei allen.
8. Light Theme und mehrere Zustände sind nicht vollständig sichtbar abgedeckt.
9. UI-, Architektur- und Phase-C-Noten enthalten nachvollziehbare, aber subjektive Ingenieursurteile.
10. Die 31-vs.-30-Inkonsistenz der ursprünglichen Checkliste wurde durch ein explizit zusammengesetztes Kriterium behoben.
11. Tool-Fehlerzahl zählt nur explizite `Script failed`-Outputs; fachlich rote Befehle werden separat in der QA-Tabelle geführt.

## 13. Stärkster und schwächster Aspekt

| Stack | stärkster Aspekt | schwächster Aspekt |
|---|---|---|
| Expo | eigenständige UI plus grüner realer Router-/Storage-Flow | Paketmanagerhygiene und fehlender nativer Vergleichswert |
| Flutter | Schichtung, Fehlerpfade und vollständig grüne Testtypen | höchste Laufzeit-/Tokenmenge; visuell weniger eigenständig |
| Kotlin | effiziente native Umsetzung, guter Codec und breite Unit-Tests | roter zentraler UI-Test und übergroße Compose-Screens |

## 14. Empfehlung nach Einsatzzweck

- **Langfristig erweiterbare, testzentrierte App:** Flutter, wenn Codegen-/Toolingkomplexität und höherer initialer Agentenaufwand akzeptabel sind.
- **Schnelle Produktiteration mit überzeugender Cross-Platform-UI:** Expo, sobald Lockfile-/Doctor-Hygiene bereinigt und ein belastbarer nativer Buildpfad festgelegt ist.
- **Android-first, kompakte native Distribution und geringe Infrastruktur:** Kotlin/Compose, sofern Phase B den Instrumentationstest grün macht und große Screens vor wachsender Phase-C-Komplexität modularisiert werden.
- **Minimaler Phase-A-Prozessaufwand:** Kotlin nach gemessener Laufzeit/Tokens; dieser Vorteil ersetzt nicht den fehlenden grünen UI-Test.

Keine Empfehlung ist endgültig, bevor Phase C die reale Änderbarkeit statt nur die Architekturprognose misst.

## 15. Fehlende Schritte für Phase B und C

### Phase B

1. Je Stack denselben Fix-Prompt `prompts/phase-b-fix.md` in einer frischen Fortsetzung ausführen.
2. Expo: genau die zwei roten QA-Gates und den nativen Buildpfad prüfen, ohne Anforderungen zu reduzieren.
3. Flutter: reproduzierbares Setup, Analyzer-Plugin-Konfiguration und Dependency-Warnungen prüfen; Nutzungslimit als Prozesswert erhalten.
4. Kotlin: Matcher des Compose-Tests reparieren und `connectedDebugAndroidTest` auf A059 erfolgreich ausführen.
5. Danach alle in dieser Analyse gelisteten Commands erneut messen und Regressionen dokumentieren.

### Phase C

1. Identischen Recurrence-Prompt `prompts/phase-c-recurring.md` verwenden.
2. Täglich/wöchentlich/monatlich in Erstellen und Bearbeiten UI-erreichbar umsetzen.
3. Persistenzschema und Migration bestehender Daten explizit testen.
4. Fälligkeits-/Erzeugungsverhalten deterministisch spezifizieren und mit Clock-basierten Tests belegen.
5. Bestehende Tests grün halten, neue Domain-/Persistenz-/UI-Tests ergänzen.
6. Dauer, Token, geänderte Dateien, Reparaturversuche, Regressionen und Architekturumbau messen.
7. Gemeinsame zweite Bildschirmgröße, Light/Dark- und Zustandsabnahme durchführen.
8. Vergleichbare Performance-/Release-Messmethodik definieren; Expo separat ausweisen.
9. Erst dann Phase-C-Prognosen ersetzen, Punktzahlen neu summieren und das Ranking als endgültig kennzeichnen.

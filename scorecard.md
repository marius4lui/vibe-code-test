# Momentum Benchmark – Scorecard

## Vorläufiges Ranking nach Phase A

Phase B und C sind offen. Die Spalte „Phase-C-Prognose“ ist eine vorläufige Architekturbewertung, kein ausgeführtes Ergebnis. Das Ranking bleibt deshalb ausdrücklich vorläufig.

| Rang | Stack | vorläufig / 100 | ohne Phase C / 95 | mögliche Endspanne | entscheidender Befund |
|---:|---|---:|---:|---:|---|
| 1 | Flutter | **91,67** | **87,17** | 87,17–92,17 | stärkste Architektur und alle geforderten Testtypen grün; höchster Zeit-/Tokenaufwand |
| 2 | Expo | **89,17** | **85,67** | 85,67–90,67 | stärkste sichtbare Produktqualität und grüner UI-Flow; Doctor/Format rot, keine vergleichbare APK |
| 3 | Kotlin + Compose | **87,43** | **83,43** | 83,43–88,43 | effizientester regulär abgeschlossener Run und kompakte Debug-APK; zentraler UI-Test rot |

Die Endspannen ergeben sich aus dem Phase-A-Stand ohne Phase C plus 0–5 tatsächlich noch zu erwerbenden Phase-C-Punkten. Phase B kann Befunde verändern und ist in diesen rein arithmetischen Spannen nicht vorweggenommen.

## Vollständige Punktetabelle

| Kategorie | Max. | Expo | Flutter | Kotlin + Compose |
|---|---:|---:|---:|---:|
| Build ohne manuelle Codeänderung | 15 | 15,0 | 15,0 | 15,0 |
| Anforderungen vollständig umgesetzt | 20 | 19,67 | 19,67 | 19,33 |
| UI und visuelle Konsistenz | 15 | 13,7 | 12,0 | 13,3 |
| Bedienbarkeit und Navigation | 10 | 9,5 | 9,6 | 9,5 |
| Architektur und Codequalität | 15 | 12,0 | 14,2 | 13,1 |
| Fehlerbehandlung | 5 | 4,5 | 4,7 | 4,5 |
| Tests und Testbarkeit | 10 | 9,8 | 10,0 | 6,5 |
| Performance und App-Größe | 5 | 1,5 | 2,0 | 2,2 |
| Erweiterbarkeit in Phase C (vorläufig) | 5 | 3,5 | 4,5 | 4,0 |
| **Gesamt** | **100** | **89,17** | **91,67** | **87,43** |
| **ohne Phase C** | **95** | **85,67** | **87,17** | **83,43** |

Mathematische Kontrolle: Keine Implementierung überschreitet 100 Punkte; jede Zeilensumme entspricht der ausgewiesenen Gesamtpunktzahl.

## Objektive Kerndaten

| Kennzahl | Expo | Flutter | Kotlin + Compose |
|---|---:|---:|---:|
| Phase-A-Build | Export/Expo Go erfolgreich | Debug-APK + Start-Smoke erfolgreich | Debug-APK erfolgreich |
| erneute Tests | 4/4 grün | 4/4 grün | 13/13 Unit grün; Compose-Test nicht ausführbar, historisch rot |
| Analyse/Lint | ESLint + TS grün | Analyze grün | Lint grün |
| sonstige QA | Format rot; Doctor 19/20 | Format grün nach `pub get` | AndroidTest-APK kompiliert |
| Checklistenwert / 30 | 29,5 | 29,5 | 29,0 |
| Phase-A-Dauer | 38:04 | 1:03:04 | 36:12 |
| Sub-Agenten | 3 | 8 | 3 |
| Tokens ohne Cache | 1.047.681 | 3.875.008 | 977.090 |
| Tokens/min ohne Cache | 27.522 | 61.443 | 26.991 |
| Output / Projektdatei | 2.055 | 4.183 | 3.122 |
| Tool-Aufrufe / explizit fehlgeschlagen | 323 / 4 | 296 / 4 | 324 / 3 |
| Projektdateien | 76 | 135 | 67 |
| Source | 51 TS/TSX | 101 `lib`-Dart, davon 23 generiert | 38 Main-Kotlin |
| aktuelle Artefaktgröße | Export 5.660.371 B | Debug-APK 153.747.996 B | Debug-APK 13.235.469 B |
| Abbruch-/Limitbefund | Turn-Abbruch beim Zusatz-Native-Build | Nutzungslimit/Turn-Abbruch | keiner |

Expo-Export, Flutter-Debug-APK und Kotlin-Debug-APK sind methodisch nicht gleichartige Größen. Debug-APK-Größen sind keine Release-Größen. Es fehlen Cold-Start-, Frame- und installierte Größenmessungen.

## Objektiv und subjektiv

- Objektiv: Exit-Codes, Testzahlen, Artefaktbytes, Dateizahlen, Session-/Tokenwerte und Git-Historie.
- Subjektiv: UI-Teilnoten, Architekturqualität, Bedienbarkeit und Phase-C-Prognose. Diese Noten sind jeweils mit sichtbaren beziehungsweise messbaren Belegen begründet.
- Das Template enthielt 31 sichtbare Checkzeilen, obwohl der Benchmark einen Nenner von 30 vorgibt. Für konsistente Mathematik werden „Erstellen-/Abschließen-Test“ und „zentraler UI-/Integrationstest“ als zusammengesetztes 30. Akzeptanzkriterium bewertet. In der Testkategorie bleiben die Testtypen gemäß Anker getrennt.

## Verbindliche Bewertungsanker

Zwischenwerte werden proportional vergeben; jede Abweichung ist in der jeweiligen Ergebnisdatei begründet.

### Build – 15 Punkte

- 15: Phase A baut und startet ohne menschliche Codeänderung.
- 10: Phase A scheitert, Phase B baut ohne menschliche Codeänderung.
- 5: Build erst nach dokumentierter kleiner manueller Codeänderung.
- 0: kein startfähiger Build oder erhebliche manuelle Reparatur.

### Anforderungen – 20 Punkte

Die 30 Punkte der Anforderungscheckliste werden proportional umgerechnet: `E = 1`, `T = 0,5`, `N = 0`. Formel: `Checklistenwert / 30 × 20`.

### UI – 15 Punkte

Sechs Aspekte werden jeweils 0–5 bewertet und halbiert: Hierarchie, Konsistenz/Spacing, Typografie, Themes, Zustände/Feedback, Eigenständigkeit. Es wird keine Implementierung wegen einer höheren Anzahl fremder Screenshots bevorzugt; bewertet werden sichtbare Qualität und belegbare Abdeckung.

### Bedienbarkeit – 10 Punkte

- Navigation und Informationsarchitektur: 0–3
- zentrale Task-Flows ohne Sackgassen: 0–3
- Formulare, Feedback und Fehlermeldungen: 0–2
- Responsive UI und Barrierefreiheit: 0–2

### Architektur – 15 Punkte

- klare Schichten und Feature-Struktur: 0–4
- State/Business Logic sauber von UI getrennt: 0–4
- verständliche Modelle und Persistenzgrenze: 0–3
- wenig Duplikation, tote Abhängigkeiten und übergroße Dateien: 0–2
- README und Nachvollziehbarkeit: 0–2

### Fehlerbehandlung – 5 Punkte

- Persistenz-/Initialisierungsfehler: 0–2
- Formular- und Nutzerfehler: 0–2
- verständliche Recovery-/Fehlerzustände: 0–1

### Tests – 10 Punkte

- Validierungstest vorhanden und grün: 0–2
- Erstellen/Abschließen vorhanden und grün: 0–3
- zentraler UI-/Integrationsflow vorhanden und grün: 0–3
- deterministisch, sinnvoll isoliert und leicht erweiterbar: 0–2

Nicht ausführbare oder rote Tests erhalten für den betroffenen Testtyp keine Vollpunkte. Mehr Tests ersetzen keinen fehlenden geforderten Testtyp.

### Performance und Größe – 5 Punkte

- keine auffälligen Ruckler oder unnötigen Rebuilds im geprüften Flow: 0–2
- Startzeit relativ zum vergleichbaren Messszenario: 0–2
- Artefakt-/Bundle-Größe ist für Stack und Modus plausibel: 0–1

Unvergleichbare Messmodi werden gekennzeichnet und nicht direkt gegeneinander gerankt. Fehlende Messungen erhalten keine erfundenen Werte.

### Erweiterbarkeit Phase C – 5 Punkte

- Funktion vollständig und persistent: 0–2
- vorhandene Architektur ohne Grundumbau erweitert: 0–1
- Tests erweitert, bestehende Tests bleiben grün: 0–1
- keine Regressionen, Migration berücksichtigt: 0–1

Da Phase C offen ist, sind die vergebenen Werte ausschließlich vorläufige Architekturprognosen.

## Tie-Breaker

Bei Gleichstand gelten nacheinander: erfolgreicher Phase-A-Build, weniger menschliche Codeänderungen, höhere tatsächlich gemessene Phase-C-Punktzahl und kürzere Phase-A-Dauer. Aktuell ist kein Tie-Breaker nötig.

## Was für ein endgültiges Ranking fehlt

1. Phase B mit identischem Fix-Prompt je Stack, dokumentierten Änderungen und vollständiger Wiederholung aller Prüfungen.
2. Kotlin-Compose-Test nach Phase-B-Fix auf A059; Expo Doctor/Format und Flutter Setup-/Lint-Konfiguration erneut prüfen.
3. Gemeinsame Geräte-/Buildmethodik für Cold Start, Frameverhalten, installierte Größe und möglichst Release-Artefakte; Expo methodisch getrennt behandeln.
4. Zweite Android-Bildschirmgröße sowie Light/Dark-, Loading-, Empty- und Error-Screens reproduzierbar abnehmen.
5. Phase C mit identischem Recurrence-Prompt, Persistenzmigration, neuen Tests, Änderungsdauer/-umfang und Regressionsergebnis.
6. Erst danach Phase-C-Prognosen durch Messwerte ersetzen und das Ranking finalisieren.

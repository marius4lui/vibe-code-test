# Momentum Benchmark – Scorecard

## Kernergebnisse

| Kennzahl | Expo | Flutter | Kotlin + Compose |
|---|---:|---:|---:|
| Phase A baut | — | — | Ja |
| Phase B baut | — | — | — |
| Phase C baut | — | — | — |
| manuelle Codeänderungen | — | — | 0 |
| gesamte KI-Runs | — | — | 1 Root-Run (+3 Sub-Agenten) |
| Anforderungen Phase A (von 30) | — | — | 29 vorläufig |
| Tests Phase A bestanden / gesamt | — | — | 13 / 14 |
| Dauer Phase A | — | — | 36 min 12 s |
| Dauer Phase C | — | — | — |
| bekannte Bugs nach Phase B | — | — | Phase B offen; 1 Bug aus Phase A |

## Bewertung (100 Punkte)

| Kategorie | Max. | Expo | Flutter | Kotlin + Compose |
|---|---:|---:|---:|---:|
| Build funktioniert ohne manuelle Codeänderung | 15 | — | — | — |
| Anforderungen vollständig umgesetzt | 20 | — | — | — |
| UI und visuelle Konsistenz | 15 | — | — | — |
| Bedienbarkeit und Navigation | 10 | — | — | — |
| Architektur und Codequalität | 15 | — | — | — |
| Fehlerbehandlung | 5 | — | — | — |
| Tests und Testbarkeit | 10 | — | — | — |
| Performance und App-Größe | 5 | — | — | — |
| Erweiterbarkeit in Phase C | 5 | — | — | — |
| **Gesamt** | **100** | **—** | **—** | **—** |

## Verbindliche Bewertungsanker

Zwischenwerte dürfen proportional vergeben werden; jede Abweichung ist in der jeweiligen Ergebnisdatei zu begründen.

### Build – 15 Punkte

- 15: Phase A baut und startet ohne menschliche Codeänderung.
- 10: Phase A scheitert, Phase B baut ohne menschliche Codeänderung.
- 5: Build erst nach dokumentierter kleiner manueller Codeänderung.
- 0: kein startfähiger Build oder erhebliche manuelle Reparatur.

### Anforderungen – 20 Punkte

Die 30 Punkte der Anforderungscheckliste werden proportional umgerechnet: `erfüllt = 1`, `teilweise = 0,5`, `nicht erfüllt = 0`. Formel: `Checklistenwert / 30 × 20`.

### UI – 15 Punkte

Sechs Aspekte werden jeweils von 0 bis 5 bewertet und anschließend halbiert: Hierarchie, Konsistenz/Spacing, Typografie, Themes, Zustände/Feedback, Eigenständigkeit. Funktionslose Placeholder erhalten in den betroffenen Aspekten höchstens 1 Punkt.

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

Nicht ausführbare Tests erhalten keine Punkte. Mehr Tests ersetzen keinen fehlenden geforderten Testtyp.

### Performance und Größe – 5 Punkte

- keine auffälligen Ruckler oder unnötigen Rebuilds im geprüften Flow: 0–2
- Startzeit relativ zum vergleichbaren Messszenario: 0–2
- Artefakt-/Bundle-Größe ist für Stack und Modus plausibel: 0–1

Unvergleichbare Messmodi werden gekennzeichnet und nicht direkt gegeneinander gerankt.

### Erweiterbarkeit Phase C – 5 Punkte

- Funktion vollständig und persistent: 0–2
- vorhandene Architektur ohne Grundumbau erweitert: 0–1
- Tests erweitert, bestehende Tests bleiben grün: 0–1
- keine Regressionen, Migration berücksichtigt: 0–1

## Rangfolge und Tie-Breaker

Die Gesamtpunktzahl bestimmt die Rangfolge. Bei Gleichstand gelten nacheinander:

1. erfolgreicher Phase-A-Build
2. weniger manuelle Codeänderungen
3. höhere Punktzahl für Erweiterbarkeit
4. kürzere Phase-A-Dauer

## Zusammenfassung

| Rang | Stack | Punkte | Entscheidender Befund |
|---:|---|---:|---|
| 1 | — | — | — |
| 2 | — | — | — |
| 3 | — | — | — |

Die Schlussfolgerung muss Phase-A-Build, Zahl manueller Reparaturen und Phase-C-Änderbarkeit explizit nennen. Die schönste UI allein entscheidet den Benchmark nicht.

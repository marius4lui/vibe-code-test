# Benchmark-Screenshots

Die finalen Screenshots werden aus den unveränderten Roh-PNGs im Ordner `Bilder` erzeugt. Die GitHub-Pages-Seite erkennt sie automatisch; fehlende Dateien werden als neutrale Platzhalter dargestellt.

## Verarbeitung

Vom Repository-Root ausführen:

```bash
./scripts/process-screenshots.sh ../vibe-benchmark-expo/Bilder
```

Der Prozess entfernt ausschließlich die 96 Pixel hohe Android-Systemleiste am oberen Bildrand, entfernt Metadaten und exportiert mit WebP-Qualität 88. Die Originaldateien werden niemals überschrieben.

Die tatsächlichen Dateinamen und ihre Zuordnung stehen reproduzierbar in `scripts/process-screenshots.sh`. Phase C kann später mit zusätzlichen `*-recurring.webp`-Screenshots ergänzt werden.

## Aufnahmevorgaben

- Für alle drei Apps dasselbe Android-Gerät beziehungsweise denselben Emulator verwenden.
- Identische Auflösung, Pixeldichte, Textskalierung und Systemsprache verwenden.
- Statusleiste und Navigationsleiste entweder überall sichtbar oder überall ausgeblendet lassen.
- Persönliche Daten vor der Aufnahme entfernen.
- Screenshots nicht nachträglich unterschiedlich beschneiden oder skalieren.
- Empfohlen: verlustfreies WebP in der nativen Geräteauflösung.

Zusätzliche Detailbilder können ebenfalls hier abgelegt und anschließend in `docs/index.html` ergänzt werden.

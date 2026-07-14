# Momentum – Master-Prompt

> Ersetze für jeden Durchlauf ausschließlich den Abschnitt `TECHNOLOGIE`. Alle anderen Zeichen und Anforderungen bleiben unverändert.

Du bist ein autonom arbeitender Senior Mobile Engineer, Softwarearchitekt und UI/UX-Designer.

Deine Aufgabe ist es, in diesem vollständig leeren App-Verzeichnis eine komplette, lokal ausführbare Mobile-App zu entwickeln.

## TECHNOLOGIE

Erstelle die Anwendung ausschließlich mit:

- Framework: `[EXPO REACT NATIVE / FLUTTER / KOTLIN JETPACK COMPOSE]`
- Sprache: `[TYPESCRIPT / DART / KOTLIN]`
- Navigation: `[EXPO ROUTER / FLUTTER-STANDARD / NAVIGATION COMPOSE]`
- UI-System: Material 3 beziehungsweise eine plattformgerechte moderne Umsetzung
- Zielplattform: Android
- Zielverzeichnis: `apps/[expo|flutter|kotlin]`
- Backend: keines
- Speicherung: ausschließlich lokal
- Keine kostenpflichtigen Dienste
- Keine externen API-Schlüssel
- Keine experimentellen oder unnötig komplexen Abhängigkeiten

Bei Expo muss die App vollständig in Expo Go funktionieren. Verwende keine Abhängigkeit, die eigenen nativen Code oder einen Custom Development Build benötigt.

Implementiere das Projekt ausschließlich im für diesen Run vorgesehenen Verzeichnis `apps/[expo|flutter|kotlin]`. Verändere keine Prompts, Ergebnisvorlagen oder Projekte anderer Frameworks.

## PRODUKT

Entwickle eine hochwertige Task- und Habit-Tracker-App namens „Momentum“.

Die App soll sich wie ein echtes, veröffentlichungsfähiges Produkt anfühlen und nicht wie eine generische Tutorial-App.

## FUNKTIONEN

Implementiere vollständig:

- Ein Onboarding mit drei Seiten.
- Ein Dashboard mit heutiger Aufgabenübersicht, Anzahl erledigter Aufgaben, Fortschrittsanzeige, aktueller Streak und Kategorienübersicht.
- Aufgaben können erstellt, bearbeitet, gelöscht, abgeschlossen und erneut geöffnet werden.
- Jede Aufgabe besitzt Titel, optionale Beschreibung, Kategorie, Priorität, Datum und optional eine Uhrzeit.
- Implementiere mindestens vier Kategorien.
- Implementiere Suche und Filter nach Status, Kategorie und Priorität.
- Speichere alle Daten dauerhaft lokal.
- Implementiere einen funktionierenden Dark Mode.
- Verwende eine Bottom Navigation mit Heute, Aufgaben und Einstellungen.
- Zeige leere Zustände, Ladezustände und verständliche Fehlermeldungen.
- Validiere sämtliche Formulare.
- Verwende sinnvolle, dezente Animationen und Übergänge.
- Die Anwendung muss auf verschiedenen Android-Bildschirmgrößen funktionieren.
- Seed-Daten dürfen nur beim ersten Start angelegt werden.
- Einstellungen und Onboarding-Status müssen ebenfalls lokal gespeichert werden.

## DESIGN

Erstelle ein eigenständiges, modernes Design mit:

- klarer visueller Hierarchie
- großzügigem Spacing
- konsistentem Rastersystem
- hochwertiger Typografie
- abgerundeten Karten
- gut sichtbaren Interaktionszuständen
- sinnvoller Farbsemantik für Prioritäten und Status
- konsistentem Light und Dark Theme
- guter Barrierefreiheit
- ausreichend großen Touch-Flächen
- verständlichen Icons
- keiner überladenen Oberfläche
- keinen beliebigen Gradients
- keinem generischen KI-Dashboard-Look

Verwende keine Placeholder-Oberflächen. Alle sichtbaren Buttons und Interaktionen müssen funktionieren.

## ARCHITEKTUR

Nutze eine nachvollziehbare, wartbare Feature-Struktur.

Trenne mindestens:

- UI beziehungsweise Presentation
- State und Business Logic
- Datenmodelle
- lokale Persistenz
- Navigation
- Theme
- wiederverwendbare Komponenten

Vermeide:

- eine einzelne gigantische Datei
- duplizierten Code
- globale mutable Zustände
- Business Logic direkt in UI-Komponenten
- unnötige Abstraktionen
- ungenutzte Dependencies
- TODO-Kommentare anstelle einer Implementierung
- Mock-Funktionen ohne reales Verhalten

Wähle ein für das jeweilige Framework etabliertes State-Management-Konzept. Begründe die Wahl kurz in der README.

## TESTS

Erstelle mindestens:

- einen Test für die Aufgabenvalidierung
- einen Test für das Erstellen und Abschließen einer Aufgabe
- einen UI- oder Integrationstest für einen zentralen Nutzerfluss

Alle Tests müssen ausführbar sein. Nutze beim jeweiligen Framework die vorgesehenen UI-Testwerkzeuge; bei Flutter mindestens einen Widget-/UI-Test und bei Jetpack Compose die Compose-Testing-APIs.

## QUALITÄTSSICHERUNG

Bevor du die Aufgabe abschließt:

- Installiere alle Abhängigkeiten.
- Formatiere den Code.
- Führe den Linter beziehungsweise die statische Analyse aus.
- Führe sämtliche Tests aus.
- Führe einen vollständigen Android-Build oder den maximal möglichen lokalen Build-Check aus.
- Behebe alle von dir gefundenen Fehler.
- Entferne ungenutzten Code und ungenutzte Abhängigkeiten.
- Prüfe alle Imports und Navigation-Routen.
- Stelle sicher, dass die dokumentierten Startbefehle tatsächlich stimmen.

Reduziere niemals stillschweigend den Funktionsumfang, um einen Build erfolgreich zu machen. Wenn eine Prüfung durch die lokale Umgebung unmöglich ist, dokumentiere exakt den ausgeführten Befehl, die Fehlermeldung und die Ursache.

## README

Erstelle im App-Verzeichnis eine vollständige README mit:

- Projektüberblick
- Funktionsliste
- Architektur
- Verzeichnisstruktur
- verwendeten Libraries und Begründungen
- Voraussetzungen
- Installationsbefehlen
- Entwicklungsstart
- Testbefehlen
- Build-Befehlen
- bekannten Einschränkungen

## ARBEITSWEISE

Arbeite autonom.

Analysiere zuerst die Anforderungen und implementiere danach das vollständige Projekt. Frage nicht nach Bestätigung und stoppe nicht nach einem Konzept oder einer Dateiliste.

Du darfst innerhalb des vorgesehenen App-Verzeichnisses Dateien erstellen, verändern oder löschen, wenn dies für eine saubere Umsetzung erforderlich ist.

Am Ende gib ausschließlich eine strukturierte Abschlussübersicht aus:

- Implementierte Funktionen
- Architektur
- Verwendete Abhängigkeiten
- Ausgeführte Prüfungen
- Ergebnisse von Build, Linter und Tests
- Bekannte Einschränkungen
- Exakte Startbefehle

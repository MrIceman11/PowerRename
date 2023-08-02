# Pfad zum Ordner, der durchsucht werden soll
$Ordnerpfad = "C:\Pfad\Zum\Ordner"

# Funktion zum Löschen von Dateien und bestimmten Ordnern
function Lösche-Dateien-Und-Ordner ($Ordnerpfad) {
    # Suche nach JPG-Dateien und lösche sie
    $Dateien = Get-ChildItem -Path $Ordnerpfad -Recurse -Include "*.jpg" -File
    foreach ($Datei in $Dateien) {
        Write-Host "Gefundene Datei: $($Datei.FullName)"
        # Lösche die JPG-Datei mit Option "Force" (ignoriere Fehler)
        Remove-Item $Datei.FullName -Force -ErrorAction SilentlyContinue
    }

    # Suche nach den Ordnern "Sample" und "Proof" und lösche sie mit ihrem Inhalt
    $ZuLöschendeOrdner = Get-ChildItem -Path $Ordnerpfad -Directory | Where-Object { $_.Name -eq "Sample" -or $_.Name -eq "Proof" }
    foreach ($Ordner in $ZuLöschendeOrdner) {
        Write-Host "Zu löschender Ordner: $($Ordner.FullName)"
        # Lösche den Ordner und seinen Inhalt mit Option "Force" (ignoriere Fehler)
        Remove-Item $Ordner.FullName -Force -Recurse -ErrorAction SilentlyContinue
    }

    # Rekursiv durchsuche Unterordner
    $Unterordner = Get-ChildItem -Path $Ordnerpfad -Directory
    foreach ($Unterordner in $Unterordner) {
        Lösche-Dateien-Und-Ordner -Ordnerpfad $Unterordner.FullName
    }
}

# Starte das Löschen von Dateien und bestimmten Ordnern
Lösche-Dateien-Und-Ordner -Ordnerpfad $Ordnerpfad
# Pfad zum Hauptordner, der durchsucht werden soll
$folderPath = "C:\Pfad\Zum\Ordner"

# Funktion zum Löschen von Dateien und bestimmten Ordnern
function Lösche-Dateien-Und-Ordner ($Ordnerpfad) {
    $Dateien = Get-ChildItem -Path $Ordnerpfad -Recurse -Include "*.jpg" -File
    foreach ($Datei in $Dateien) {
        Write-Host "Gefundene Datei: $($Datei.FullName)"
        Remove-Item $Datei.FullName -Force -ErrorAction SilentlyContinue
    }

    $ZuLöschendeOrdner = Get-ChildItem -Path $Ordnerpfad -Directory | Where-Object { $_.Name -eq "Sample" -or $_.Name -eq "Proof" }
    foreach ($Ordner in $ZuLöschendeOrdner) {
        Write-Host "Zu löschender Ordner: $($Ordner.FullName)"
        Remove-Item $Ordner.FullName -Force -Recurse -ErrorAction SilentlyContinue
    }

    $Unterordner = Get-ChildItem -Path $Ordnerpfad -Directory
    foreach ($Unterordner in $Unterordner) {
        Lösche-Dateien-Und-Ordner -Ordnerpfad $Unterordner.FullName
    }
}

# Starte das Löschen von Dateien und bestimmten Ordnern
Lösche-Dateien-Und-Ordner -Ordnerpfad $folderPath

# Umbenennung der Unterordner gemäß dem Muster und Ausgabe der alten und neuen Namen
Get-ChildItem -Path $folderPath -Directory | ForEach-Object {
    $subFolder = $_
    $folderName = $subFolder.Name
    $pattern = '(.+?)\.(\d{4})'

    if ($folderName -match $pattern) {
        $filmTitle = $matches[1].Trim()
        $year = $matches[2]
        $filmTitle = $filmTitle -replace '\.', ' '
        $newFolderName = "$filmTitle ($year)"

        # Überprüfen, ob der Ordnername geändert werden muss
        $neuerName = $neueOrdnerNamen | Where-Object { $_.Alt -eq $newFolderName } | Select-Object -ExpandProperty Neu
        if ($neuerName) {
            $newFolderName = $neuerName
        }

        if ($folderName -ne $newFolderName) {
            Write-Host "Alter Ordnername: $($subFolder.Name)"
            Write-Host "Neuer Ordnername: $newFolderName"
            Rename-Item -Path $subFolder.FullName -NewName $newFolderName
        }
    }
}
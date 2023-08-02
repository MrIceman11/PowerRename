$folderPath = "C:\Pfad\Zum\Ordner"  # Hier den Pfad zum Hauptordner angeben

# Alle Unterordner im Hauptordner durchgehen
Get-ChildItem -Path $folderPath -Directory | ForEach-Object {
    $subFolder = $_

    # Den Namen des Unterordners extrahieren
    $folderName = $subFolder.Name

    # Muster für den Filmtitel und das Jahr
    $pattern = '(.+?)\.(\d{4})'

    # Überprüfen, ob das Muster im Ordnername gefunden wird
    if ($folderName -match $pattern) {
        $filmTitle = $matches[1].Trim()
        $year = $matches[2]

        # Leerzeichen und Punkte aus dem Filmtitel entfernen
        $filmTitle = $filmTitle -replace '\.', ' '

        # Neuen Ordnername erstellen
        $newFolderName = "$filmTitle ($year)"

        # Überprüfen, ob der neue Ordnername vom vorhandenen Namen abweicht
        if ($folderName -ne $newFolderName) {
            # Umbenennung durchführen
            Rename-Item -Path $subFolder.FullName -NewName $newFolderName
        }
    }
}
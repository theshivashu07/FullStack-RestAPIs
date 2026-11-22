param(
    [string]$Url = 'http://localhost:8080',
    [int]$TimeoutSeconds = 300
)

$deadline = (Get-Date).AddSeconds($TimeoutSeconds)
$ready = $false

# Wait until Vite is listening before opening the page.
while ((Get-Date) -lt $deadline) {
    $client = $null
    try {
        $client = [System.Net.Sockets.TcpClient]::new()
        $connection = $client.BeginConnect('127.0.0.1', 8080, $null, $null)
        if ($connection.AsyncWaitHandle.WaitOne(1500) -and $client.Connected) {
            $client.EndConnect($connection)
            $ready = $true
            break
        }
    }
    catch {
        # Vite may still be starting. Keep checking until timeout.
    }
    finally {
        if ($null -ne $client) { $client.Dispose() }
    }
    Start-Sleep -Seconds 2
}

if (-not $ready) {
    Write-Warning "Vite was not detected at $Url within $TimeoutSeconds seconds. Open the URL manually after starting the frontend."
    exit 1
}

$chromeCandidates = @(
    "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
    "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe",
    "$env:LocalAppData\Google\Chrome\Application\chrome.exe"
)
$chromePath = $chromeCandidates | Where-Object { $_ -and (Test-Path $_) } | Select-Object -First 1

if ($chromePath) {
    Start-Process -FilePath $chromePath -ArgumentList @('--new-window', $Url)
} elseif (Get-Command chrome.exe -ErrorAction SilentlyContinue) {
    Start-Process -FilePath 'chrome.exe' -ArgumentList @('--new-window', $Url)
} else {
    # Fallback to the Windows default browser if Chrome is installed in a non-standard location.
    Start-Process $Url
}

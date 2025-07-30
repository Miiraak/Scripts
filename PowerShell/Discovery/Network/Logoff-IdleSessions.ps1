########################################################################################
#                                                                                      |
#                 ███▄ ▄███▓ ██▓ ██▓ ██▀███   ▄▄▄      ▄▄▄       ██ ▄█▀                |
#                ▓██▒▀█▀ ██▒▓██▒▓██▒▓██ ▒ ██▒▒████▄   ▒████▄     ██▄█▒                 |
#                ▓██    ▓██░▒██▒▒██▒▓██ ░▄█ ▒▒██  ▀█▄ ▒██  ▀█▄  ▓███▄░                 |
#                ▒██    ▒██ ░██░░██░▒██▀▀█▄  ░██▄▄▄▄██░██▄▄▄▄██ ▓██ █▄                 |
#                ▒██▒   ░██▒░██░░██░░██▓ ▒██▒ ▓█   ▓██▒▓█   ▓██▒▒██▒ █▄                |
#                ░ ▒░   ░  ░░▓  ░▓  ░ ▒▓ ░▒▓░ ▒▒   ▓▒█░▒▒   ▓▒█░▒ ▒▒ ▓▒                |
#                ░  ░      ░ ▒ ░ ▒ ░  ░▒ ░ ▒░  ▒   ▒▒ ░ ▒   ▒▒ ░░ ░▒ ▒░                |
#                ░      ░    ▒ ░ ▒ ░  ░░   ░   ░   ▒    ░   ▒   ░ ░░ ░                 |
#                       ░    ░   ░     ░           ░  ░     ░  ░░  ░                   |
#                                                                                      |
#     Title        : Logoff-IdleSessions.ps1                                           |
#     Link         : https://github.com/Miiraak/Scripts/tree/master/PowerShell/Discovery/Network/     |
#     Version      : 2.0                                                               |
#     Category     : discovery/network                                                   |
#     Target       : Windows Server / 10/11                                            |
#     Description  : Logoff all idle/disconnected user sessions (RDP/console).          |
#                                                                                      |
########################################################################################

<#
.SYNOPSIS
    Logoff all idle or disconnected user sessions (RDP/console) based on session state and idle time.

.DESCRIPTION
    This script enumerates all user sessions using 'quser', filters them by state and idle time,
    then logs off matching sessions. Export of session data to CSV/JSON is supported, along with
    a dry run mode for simulation.

.PARAMETER StateFilter
    Array of session states to target for logoff (default: Disc, Idle, Disconnected).

.PARAMETER IdleMinutesMin
    Minimum idle time (in minutes) for logoff. Sessions below this threshold are skipped.

.PARAMETER ExportCsv
    Export matching sessions to a CSV file.

.PARAMETER CsvPath
    Path to save the CSV export.

.PARAMETER ExportJson
    Export matching sessions to a JSON file.

.PARAMETER JsonPath
    Path to save the JSON export.

.PARAMETER DryRun
    Simulate logoff actions without executing them.

.EXAMPLE
    .\Logoff-IdleSessions.ps1 -IdleMinutesMin 30 -ExportCsv -DryRun
#>

# ----------------[Parameters]---------------- #
[CmdletBinding()]
param (
    [string[]]$StateFilter = @("Disc", "Idle", "Disconnected"),
    [int]$IdleMinutesMin = 0,
    [switch]$ExportCsv,
    [string]$CsvPath = "$PSScriptRoot\IdleSessions_$((Get-Date).ToString('yyyyMMdd_HHmmss')).csv",
    [switch]$ExportJson,
    [string]$JsonPath = "$PSScriptRoot\IdleSessions_$((Get-Date).ToString('yyyyMMdd_HHmmss')).json",
    [switch]$DryRun
)

# ----------------[Functions]---------------- #
function Write-Section {
    param([string]$Title)
    Write-Host ""
    Write-Host $Title -ForegroundColor Cyan
    Write-Host ('=' * ($Title.Length)) -ForegroundColor Cyan
}

# ----------------[Execution]---------------- #
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "This script must be run as administrator!" -ForegroundColor Red
    exit 1
}

Write-Section "Active User Sessions"

# Retrieve all sessions via quser
$sessionsRaw = quser 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error running 'quser'. Access denied or tool not available." -ForegroundColor Red
    exit 2
}

# Parse quser output
$sessions = @()
foreach ($line in $sessionsRaw | Select-Object -Skip 1) {
    $cols = ($line -replace "\s{2,}", "`t").Split("`t")
    if ($cols.Count -ge 6) {
        $session = [PSCustomObject]@{
            USERNAME   = $cols[0]
            SESSIONNAME= $cols[1]
            ID         = $cols[2]
            STATE      = $cols[3]
            IDLETIME   = $cols[4]
            LOGONTIME  = $cols[5]
        }
        $sessions += $session
    }
}

if ($sessions.Count -eq 0) {
    Write-Host "No user sessions found." -ForegroundColor Yellow
    exit 0
}

# Filter by state
$idleSessions = $sessions | Where-Object {
    $StateFilter -contains $_.STATE
}

# Filter by idle time (e.g. '1+', '15', 'N/A')
if ($IdleMinutesMin -gt 0) {
    $idleSessions = $idleSessions | Where-Object {
        $idleStr = $_.IDLETIME
        # Convert idle time to minutes
        $minutes = if ($idleStr -match "^(\d+)\+$") { [int]$matches[1] * 60 }
        elseif ($idleStr -match "^(\d+):(\d+)$") { [int]$matches[1] * 60 + [int]$matches[2] }
        elseif ($idleStr -match "^\d+$") { [int]$idleStr }
        else { 0 }
        $minutes -ge $IdleMinutesMin
    }
}

if ($idleSessions.Count -eq 0) {
    Write-Host "No idle or disconnected sessions found according to filter." -ForegroundColor Yellow
    exit 0
}

# Display
Write-Host "Sessions to logoff: $($idleSessions.Count)" -ForegroundColor Magenta
$idleSessions | Format-Table USERNAME, ID, STATE, IDLETIME, LOGONTIME

# Export CSV/JSON
if ($ExportCsv) {
    $idleSessions | Export-Csv -Path $CsvPath -NoTypeInformation -Encoding UTF8
    Write-Host "Exported to CSV: $CsvPath" -ForegroundColor Cyan
}
if ($ExportJson) {
    $idleSessions | ConvertTo-Json -Depth 3 | Set-Content -Path $JsonPath -Encoding UTF8
    Write-Host "Exported to JSON: $JsonPath" -ForegroundColor Cyan
}

Write-Section "Processing Sessions"
$logoffCount = 0

foreach ($session in $idleSessions) {
    $sid = $session.ID
    $user = $session.USERNAME
    if (-not $DryRun) {
        try {
            logoff $sid
            Write-Host "Session ID $sid ($user) logged off." -ForegroundColor Green
            $logoffCount++
        } catch {
            Write-Host "Error logging off session $sid ($user)." -ForegroundColor Red
        }
    } else {
        Write-Host "[Simulation] Session ID $sid ($user) would be logged off." -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "Total sessions logged off: $logoffCount" -ForegroundColor DarkGreen

# ----------------[End]---------------- #
Write-Host "[END]" -ForegroundColor White -BackgroundColor DarkGreen
exit 0
########################################################################################################
#                                                                                                      #
#                   ███▄ ▄███▓ ██▓ ██▓ ██▀███   ▄▄▄      ▄▄▄       ██ ▄█▀                              #
#                  ▓██▒▀█▀ ██▒▓██▒▓██▒▓██ ▒ ██▒▒████▄   ▒████▄     ██▄█▒                               #
#                  ▓██    ▓██░▒██▒▒██▒▓██ ░▄█ ▒▒██  ▀█▄ ▒██  ▀█▄  ▓███▄░                               #
#                  ▒██    ▒██ ░██░░██░▒██▀▀█▄  ░██▄▄▄▄██░██▄▄▄▄██ ▓██ █▄                               #
#                  ▒██▒   ░██▒░██░░██░░██▓ ▒██▒ ▓█   ▓██▒▓█   ▓██▒▒██▒ █▄                              #
#                  ░ ▒░   ░  ░░▓  ░▓  ░ ▒▓ ░▒▓░ ▒▒   ▓▒█░▒▒   ▓▒█░▒ ▒▒ ▓▒                              #
#                  ░  ░      ░ ▒ ░ ▒ ░  ░▒ ░ ▒░  ▒   ▒▒ ░ ▒   ▒▒ ░░ ░▒ ▒░                              #
#                  ░      ░    ▒ ░ ▒ ░  ░░   ░   ░   ▒    ░   ▒   ░ ░░ ░                               #
#                         ░    ░   ░     ░           ░  ░     ░  ░░  ░                                 #
#                                                                                                      #
#     Title        : Restart-ServiceOnCrash.ps1                                                        #
#     Link         : https://github.com/Miiraak/Scripts/tree/master/PowerShell/DefenseEvasion/ProcessManipulation/ #
#     Version      : 3.2                                                                               #
#     Category     : defenseevasion/processmanipulation                                                #
#     Target       : Windows 10/11/Server                                                              #
#     Description  : Monitors a critical service, restarts + logs on failure.                          #
#                                                                                                      #
########################################################################################################

<#
.SYNOPSIS
    Monitors a critical service and automatically restarts it on crash/failure, with logging.

.DESCRIPTION
    Continuously monitors a specified Windows service. If the service is stopped or not found, attempts to restart it up to MaxAttempts. Logs each stop and restart attempt, with optional CSV/JSON export.

.PARAMETER Service
    Service name (short name from services.msc) to monitor.

.PARAMETER IntervalSeconds
    Monitoring interval (seconds). Default: 30.

.PARAMETER MaxAttempts
    Maximum restart attempts per incident. Default: 3.

.PARAMETER ExportLogCsv
    Export restart log as CSV.

.PARAMETER CsvPath
    Path for CSV export. Default: ServiceRestartLog_${Service}_<timestamp>.csv

.PARAMETER ExportLogJson
    Export restart log as JSON.

.PARAMETER JsonPath
    Path for JSON export. Default: ServiceRestartLog_${Service}_<timestamp>.json

.EXAMPLE
    .\Restart-ServiceOnCrash.ps1 -Service "Spooler"
    .\Restart-ServiceOnCrash.ps1 -Service "wuauserv" -ExportLogCsv -ExportLogJson
    .\Restart-ServiceOnCrash.ps1 -Service "WinRM" -IntervalSeconds 60 -MaxAttempts 5
#>

# -------------- [Parameters] -------------- #
[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$Service,

    [int]$IntervalSeconds = 30,
    [int]$MaxAttempts = 3,

    [switch]$ExportLogCsv,
    [string]$CsvPath = "$PSScriptRoot\ServiceRestartLog_${Service}_$((Get-Date).ToString('yyyyMMdd_HHmmss')).csv",

    [switch]$ExportLogJson,
    [string]$JsonPath = "$PSScriptRoot\ServiceRestartLog_${Service}_$((Get-Date).ToString('yyyyMMdd_HHmmss')).json"
)

# -------------- [Functions] -------------- #
function Write-Section {
    param([string]$Title)
    Write-Host "`n$Title" -ForegroundColor Cyan
    Write-Host ('=' * $Title.Length) -ForegroundColor Cyan
}

# -------------- [Variables] -------------- #
Write-Section "Monitoring critical service : $Service"
$restartLog = @()
$stopCount = 0
$restartCount = 0

# -------------- [Execution] -------------- #
try {
    Get-Service -Name $Service -ErrorAction Stop | Out-Null
} catch {
    Write-Host "Service '$Service' not found. Check the short name in 'services.msc'." -ForegroundColor Red
    exit 1
}

Write-Host "Monitoring started. (Ctrl+C to stop)" -ForegroundColor Green

try {
    while ($true) {
        try {
            $svc = Get-Service -Name $Service -ErrorAction Stop
            $currentStatus = $svc.Status
        } catch {
            $timeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            Write-Host "$timeStamp | Service '$Service' not found or removed!" -ForegroundColor Red
            $restartLog += [PSCustomObject]@{
                DateTime = $timeStamp
                Service  = $Service
                Status   = "Not Found"
                Attempt  = 0
                Result   = "Service Not Found"
            }
            break
        }

        if ($currentStatus -ne 'Running') {
            $stopCount++
            $timeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            Write-Host "$timeStamp | Warning: Service '$Service' is not running (status = $currentStatus)." -ForegroundColor Yellow

            $success = $false
            for ($i = 1; $i -le $MaxAttempts; $i++) {
                try {
                    Restart-Service -Name $Service -ErrorAction Stop
                    $restartCount++
                    $success = $true
                    Write-Host "$timeStamp | Service '$Service' restarted successfully (attempt $i)." -ForegroundColor Green
                    $restartLog += [PSCustomObject]@{
                        DateTime = $timeStamp
                        Service  = $Service
                        Status   = $currentStatus
                        Attempt  = $i
                        Result   = "Restarted"
                    }
                    break
                } catch {
                    Write-Host "$timeStamp | Error attempt $i : $($_.Exception.Message)" -ForegroundColor Red
                    $restartLog += [PSCustomObject]@{
                        DateTime = $timeStamp
                        Service  = $Service
                        Status   = $currentStatus
                        Attempt  = $i
                        Result   = "Failed: $($_.Exception.Message)"
                    }
                    Start-Sleep -Seconds 3
                }
            }

            if (-not $success) {
                Write-Host "$timeStamp | Failed to restart after $MaxAttempts attempts." -ForegroundColor Red
            }
        }

        Start-Sleep -Seconds $IntervalSeconds
    }
}
finally {
    # Export log if requested
    if ($ExportLogCsv -and $restartLog.Count -gt 0) {
        $restartLog | Export-Csv -Path $CsvPath -NoTypeInformation -Encoding UTF8
        Write-Host "Log exported as CSV: $CsvPath" -ForegroundColor Cyan
    }

    if ($ExportLogJson -and $restartLog.Count -gt 0) {
        $restartLog | ConvertTo-Json -Depth 3 | Set-Content -Path $JsonPath -Encoding UTF8
        Write-Host "Log exported as JSON: $JsonPath" -ForegroundColor Cyan
    }

    Write-Host ""
    Write-Host "Summary: Service stopped $stopCount times, restarted $restartCount times." -ForegroundColor Magenta
    Write-Host "[END] Monitoring finished." -ForegroundColor White -BackgroundColor DarkGreen
    exit 0
}
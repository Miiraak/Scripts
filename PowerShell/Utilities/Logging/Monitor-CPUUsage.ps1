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
#     Title        : Monitor-CPUUsage.ps1                                              |
#     Link         : https://github.com/Miiraak/Scripts/tree/master/PowerShell/Utilities/Logging/   |
#     Version      : 1.0                                                               |
#     Category     : utilities/logging                                                  |
#     Target       : Windows 10/11                                                     |
#     Description  : Monitors CPU usage in real time and displays a                     |
#                    graph using Out-GridView.                                          |
#                                                                                      |
########################################################################################

<#
.SYNOPSIS
    Monitors CPU usage in real time and displays the current usage in the console.

.DESCRIPTION
    This script displays the current CPU usage percentage every second in the console.
    It uses Get-Counter for accuracy and falls back to WMI Win32_Processor if needed.
    The script requires administrator privileges, and monitoring stops when any key is pressed.

.EXAMPLE
    .\Monitor-CPUUsage.ps1
#>

# ---------------[EXECUTION]--------------- #
# Check for administrator privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Please run this script as an Administrator." -ForegroundColor Red
    exit
}

# Detect which method to use
$useWMI = $false
try {
    $null = Get-Counter '\Processor(_Total)\% Processor Time' -ErrorAction Stop
} catch {
    Write-Host "Get-Counter failed, falling back to WMI..." -ForegroundColor Yellow
    $useWMI = $true
}

Write-Host "Monitoring CPU usage... Press any key to stop." -ForegroundColor Green
Write-Host ""

# Main monitoring loop
while (-not [Console]::KeyAvailable) {
    $timestamp = Get-Date -Format "HH:mm:ss"

    if (-not $useWMI) {
        try {
            $cpu = Get-Counter '\Processor(_Total)\% Processor Time'
            $value = [math]::Round($cpu.CounterSamples.CookedValue, 1)
            Write-Host "$timestamp - CPU Usage: $value%" -ForegroundColor Cyan
        } catch {
            Write-Host "$timestamp - Error with Get-Counter, switching to WMI..." -ForegroundColor Red
            $useWMI = $true
        }
    }

    if ($useWMI) {
        try {
            $value = Get-WmiObject -Query "SELECT LoadPercentage FROM Win32_Processor" | Select-Object -ExpandProperty LoadPercentage
            Write-Host "$timestamp - CPU Usage: $value%" -ForegroundColor DarkCyan
        } catch {
            Write-Host "$timestamp - Failed to retrieve CPU usage via WMI." -ForegroundColor Red
        }
    }

    Start-Sleep -Seconds 1
}

Write-Host "`nMonitoring stopped." -ForegroundColor Gray
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
#     Title        : Get-BatteryStatus.ps1                                             |
#     Link         : https://github.com/Miiraak/Scripts/tree/master/PowerShell/Utilities/Logging/   |
#     Version      : 1.0                                                               |
#     Category     : utilities/logging                                                  |
#     Target       : Windows 10/11                                                     |
#     Description  : Shows battery percentage and charging status.                      |
#                                                                                      |
########################################################################################

<#
.SYNOPSIS
    Displays the current battery percentage and charging status.

.DESCRIPTION
    This script checks for battery presence, retrieves the battery percentage and charging status,
    and displays the information in a color-coded format:
      - Green for 80% or above
      - Blue for 50% to 79%
      - Yellow for 20% to 49%
      - Red for below 20% or if no battery is detected

.EXAMPLE
    .\Get-BatteryStatus.ps1
#>

# ---------------[Execution]--------------- #
Add-Type -AssemblyName System.Windows.Forms
$battery = [System.Windows.Forms.SystemInformation]::PowerStatus

if ($battery.BatteryChargeStatus -eq [System.Windows.Forms.BatteryChargeStatus]::NoBattery) {
    Write-Host "No battery detected." -ForegroundColor Red
    exit
}

$percentage = [math]::Round($battery.BatteryLifePercent * 100)
$status = $battery.PowerLineStatus

if ($percentage -ge 80) {
    Write-Host "Battery Percentage: $percentage% ($status)" -ForegroundColor Green
    exit
} elseif ($percentage -ge 50) {
    Write-Host "Battery Percentage: $percentage% ($status)" -ForegroundColor Blue
    exit
} elseif ($percentage -ge 20) {
    Write-Host "Battery Percentage: $percentage% ($status)" -ForegroundColor Yellow
    exit
} else {
    Write-Host "Battery Percentage: $percentage% ($status)" -ForegroundColor Red
    exit
}
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
#     Title        : Check-InternetConnection.ps1                                      |
#     Link         : https://github.com/Miiraak/Scripts/tree/master/PowerShell/Discovery/Network/   |
#     Version      : 1.1                                                               |
#     Category     : discovery/network                                                  |
#     Target       : Windows 10/11                                                     |
#     Description  : Checks internet access by pinging specified target.                |
#                                                                                      |
########################################################################################

<#
.SYNOPSIS
    Checks internet connectivity by pinging the specified target IP or hostname.

.DESCRIPTION
    This script tests network connectivity by attempting to ping a user-specified target (IP or hostname).
    If the target is not reachable, it pings Google's DNS server (8.8.8.8) to determine whether the issue
    is with the internet connection or just the target.

.PARAMETER Target
    IP address or hostname to test for connectivity.

.EXAMPLE
    .\Check-InternetConnection.ps1 -Target "google.com"

.EXAMPLE
    .\Check-InternetConnection.ps1 -Target "8.8.8.8"
#>

# ---------------[Parameters]--------------- #
param (
    [Parameter(Mandatory=$true, HelpMessage="Specify the IP address or hostname to test connectivity.")]
    [string]$Target
)

# ---------------[Execution]--------------- #
if (-not $Target) {
    Write-Host "No target specified. Please provide IP address or hostname." -ForegroundColor Yellow
    exit
}

# Check if the target is reachable
if (Test-Connection -ComputerName $Target -Count 1 -ErrorAction SilentlyContinue) {
    Write-Host "Internet connection is available." -ForegroundColor Green
    exit
} else {
    # Check if the default DNS server is reachable
    if (Test-Connection -ComputerName "8.8.8.8" -Count 1 -ErrorAction SilentlyContinue) {
        Write-Host "Target probably does not exist." -ForegroundColor Yellow
        exit
    }

    Write-Host "No internet connection available." -ForegroundColor Red
    exit
}


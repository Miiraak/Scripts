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
#     Title        : Get-Weather.ps1                                                   |
#     Link         : https://github.com/Miiraak/Scripts/tree/master/PowerShell/Utilities/Misc/     |
#     Version      : 1.0                                                               |
#     Category     : utilities/misc                                                    |
#     Target       : Windows 10/11                                                     |
#     Description  : Displays current weather information by querying wttr.in          |
#                    using Invoke-WebRequest.                                          |
#                                                                                      |
########################################################################################

<#
.SYNOPSIS
    Displays current weather information for a specified city by querying wttr.in.

.DESCRIPTION
    Uses Invoke-WebRequest to fetch weather data from wttr.in and prints it to the console.

.PARAMETER City
    Name of the city to fetch weather for.

.EXAMPLE
    .\Get-Weather.ps1 -City "Bern"
#>

# ---------------[Parameters]--------------- #
param (
    [Parameter(Mandatory=$true)]
    [string]$City
)

if (-not $City) {
    Write-Host "Please provide a city name." -ForegroundColor Yellow
    exit
}

# ---------------[Execution]--------------- #
$City = $City.ToLower()
$response = Invoke-WebRequest -Uri "http://wttr.in/$City" -UseBasicParsing
if ($response.StatusCode -ne 200) {
    Write-Host "Could not retrieve weather information for '$City'. Please check the city name." -ForegroundColor Red
    exit
}
$response.Content

# ---------------[End]--------------- #
exit 0
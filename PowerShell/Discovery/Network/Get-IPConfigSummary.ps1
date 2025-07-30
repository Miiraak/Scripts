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
#     Title        : Get-IPConfigSummary.ps1                                           |
#     Link         : https://github.com/Miiraak/Scripts/tree/master/PowerShell/Discovery/Network/   |
#     Version      : 1.2                                                               |
#     Category     : discovery/network                                                  |
#     Target       : Windows 10/11                                                     |
#     Description  : Displays a simplified view of current IP, Gateway and DNS for      |
#                    the choosen network adapter.                                       |
#                                                                                      |
########################################################################################

<#
.SYNOPSIS
    Displays a simplified summary of IPv4 address, gateway, and DNS servers for a selected network adapter.

.DESCRIPTION
    Lists all active network adapters and prompts the user to select one.
    Shows the IPv4 address, gateway, and DNS servers for the chosen adapter.

.EXAMPLE
    .\Get-IPConfigSummary.ps1
#>

# ---------------[Variables]--------------- #
$networkAdapters = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }
if ($networkAdapters.Count -eq 0) {
    Write-Host "No active network adapters found." -ForegroundColor Red
    exit
}

# ---------------[Execution]--------------- #
# Display all network adapters with index
Write-Host "Available Network Adapters:" -ForegroundColor Cyan
for ($i = 0; $i -lt $networkAdapters.Count; $i++) {
    $index = $i + 1
    Write-Host "[$index] $($networkAdapters[$i].Name) - $($networkAdapters[$i].Status)" -ForegroundColor Yellow
}

# Prompt user to choose an adapter
do {
    $selection = Read-Host "Enter the number of the network adapter you want to inspect"
    $isValid = $selection -match '^\d+$' -and [int]$selection -ge 1 -and [int]$selection -le $networkAdapters.Count
    if (-not $isValid) {
        Write-Host "Invalid selection. Please enter a number between 1 and $($networkAdapters.Count)." -ForegroundColor Red
    }
} until ($isValid)

# Get selected adapter
$adapter = $networkAdapters[[int]$selection - 1]

# Get IP configuration for selected adapter
$ipConfig = Get-NetIPConfiguration -InterfaceAlias $adapter.Name

Write-Host "`nSelected adapter: $($adapter.Name)" -ForegroundColor Green
Write-Host "IP Address  : $($ipConfig.IPv4Address.IPAddress)"
Write-Host "Gateway     : $($ipConfig.IPv4DefaultGateway.NextHop)"
Write-Host "DNS Servers : $($ipConfig.DnsServer.ServerAddresses -join ', ')"

# ---------------[End]--------------- #
exit 0
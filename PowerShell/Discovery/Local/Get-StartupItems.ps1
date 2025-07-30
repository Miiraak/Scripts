###################################################################################################
#                                                                                                 |
#                   ███▄ ▄███▓ ██▓ ██▓ ██▀███   ▄▄▄      ▄▄▄       ██ ▄█▀                         |
#                  ▓██▒▀█▀ ██▒▓██▒▓██▒▓██ ▒ ██▒▒████▄   ▒████▄     ██▄█▒                          |
#                  ▓██    ▓██░▒██▒▒██▒▓██ ░▄█ ▒▒██  ▀█▄ ▒██  ▀█▄  ▓███▄░                          |
#                  ▒██    ▒██ ░██░░██░▒██▀▀█▄  ░██▄▄▄▄██░██▄▄▄▄██ ▓██ █▄                          |
#                  ▒██▒   ░██▒░██░░██░░██▓ ▒██▒ ▓█   ▓██▒▓█   ▓██▒▒██▒ █▄                         |
#                  ░ ▒░   ░  ░░▓  ░▓  ░ ▒▓ ░▒▓░ ▒▒   ▓▒█░▒▒   ▓▒█░▒ ▒▒ ▓▒                         |
#                  ░  ░      ░ ▒ ░ ▒ ░  ░▒ ░ ▒░  ▒   ▒▒ ░ ▒   ▒▒ ░░ ░▒ ▒░                         |
#                  ░      ░    ▒ ░ ▒ ░  ░░   ░   ░   ▒    ░   ▒   ░ ░░ ░                          |
#                         ░    ░   ░     ░           ░  ░     ░  ░░  ░                            |
#                                                                                                 |
#     Title        : Get-StartupItems.ps1                                                         |
#     Link         : https://github.com/Miiraak/Scripts/tree/master/PowerShell/Discovery/Local/   |
#     Version      : 1.2                                                                          |
#     Category     : discovery/local                                                              |
#     Target       : Windows 10/11                                                                |
#     Description  : Lists startup programs from registry and Startup folder.                     |
#                                                                                                 |
###################################################################################################

<#
.SYNOPSIS
    Lists startup programs from registry and Startup folder.

.DESCRIPTION
    Enumerates user and system registry keys and the Startup folder to display all configured startup items.

.EXAMPLE
    .\Get-StartupItems.ps1
#>

# ---------------[Variables]--------------- #
$startupFolders = @(
    "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run",
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run"
)
$startupItems = @()

# ---------------[Execution]--------------- #
foreach ($path in $startupFolders) {
    Write-Host "`n[$path]" -ForegroundColor Cyan

    if (Test-Path $path) {
        $entries = Get-ItemProperty $path
        $entries.PSObject.Properties | Where-Object {
            $_.Name -ne "PSPath" -and
            $_.Name -ne "PSParentPath" -and
            $_.Name -ne "PSChildName" -and
            $_.Name -ne "PSDrive" -and
            $_.Name -ne "PSProvider"
        } | ForEach-Object {
            $startupItems += [PSCustomObject]@{
                Location = $path
                Name     = $_.Name
                Value    = $_.Value
            }
        }
    } else {
        Write-Host "Path does not exist." -ForegroundColor DarkGray
    }
}

if ($startupItems.Count -gt 0) {
    "`nStartup Items:`n" | Write-Host -ForegroundColor Yellow
    $startupItems | Sort-Object Location, Name | Format-Table -AutoSize
} else {
    Write-Host "No startup items found." -ForegroundColor Red
}

# ---------------[End]--------------- #
exit 0
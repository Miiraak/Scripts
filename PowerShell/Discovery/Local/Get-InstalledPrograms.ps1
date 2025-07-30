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
#     Title        : Get-InstalledPrograms.ps1                                                    |
#     Link         : https://github.com/Miiraak/Scripts/tree/master/PowerShell/Discovery/Local/   |
#     Version      : 1.0                                                                          |
#     Category     : discovery/local                                                              |
#     Target       : Windows 10/11                                                                |
#     Description  : Lists all installed programs via registry.                                   |
#                                                                                                 |
###################################################################################################

<#
.SYNOPSIS
    Lists all installed programs by reading from registry uninstall keys.

.DESCRIPTION
    Collects program names, versions, and publishers from both 32-bit and 64-bit registry paths.
    Results are sorted and deduplicated for easy viewing.

.EXAMPLE
    .\Get-InstalledPrograms.ps1
#>

# ---------------[Variables]--------------- #
$keys = @(
  "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
  "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
)
$allRecords = @()

# ---------------[Execution]--------------- #
foreach ($key in $keys) {
    $allRecords += Get-ItemProperty $key | Where-Object { $_.DisplayName } | 
    Select-Object DisplayName, DisplayVersion, Publisher
}
$allRecords = $allRecords | Sort-Object DisplayName -Unique

# ---------------[End]----------------- #
$allRecords | Format-Table -AutoSize
exit 0
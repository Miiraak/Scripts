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
#     Title        : Get-USBDevices.ps1                                                |
#     Link         : https://github.com/Miiraak/Scripts/tree/master/PowerShell/Discovery/Local/     |
#     Version      : 1.0                                                               |
#     Category     : discovery/local                                                   |
#     Target       : Windows 10/11                                                     |
#     Description  : Lists connected USB storage devices using WMI.                    |
#                                                                                      |
########################################################################################

<#
.SYNOPSIS
    Lists connected USB storage devices using WMI.

.DESCRIPTION
    Queries Win32_DiskDrive and filters for drives attached via USB interface.

.EXAMPLE
    .\Get-USBDevices.ps1
#>

# ---------------[EXECUTION]--------------- #
Get-WmiObject Win32_DiskDrive | Where-Object { $_.InterfaceType -eq "USB"}  | 
Select-Object Model, DeviceID, InterfaceType, Size#

# ---------------[End]--------------- #
Exit 0
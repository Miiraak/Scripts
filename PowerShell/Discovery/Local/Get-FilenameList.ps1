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
#     Title        : Get-FilenameList.ps1                                                         |
#     Link         : https://github.com/Miiraak/Scripts/tree/master/PowerShell/Discovery/Local/   |
#     Version      : 1.0.0                                                                        |
#     Category     : discovery/local                                                              |
#     Target       : Windows 10/11                                                                |
#     Description  : List all file names in a folder and export them to a text file.              |
#                                                                                                 |
###################################################################################################

<#
.SYNOPSIS
    Lists all file names in a specified folder and displays them in the console.

.DESCRIPTION
    This script lists all files (not directories) within a given folder path. It checks for the existence
    of the folder before listing files and outputs the file names to the console.

.PARAMETER Path
    The folder path to list file names from.

.EXAMPLE
    .\Get-FilenameList.ps1 -Path "C:\MyFolder"
#>

# ------------ [Parameters] ------------ #
param (
    [Parameter(Mandatory = $true, Position = 0, HelpMessage="Specify the folder path to list file names.")]
    [string]$Path
)

# ------------ [Execution] ------------ #
# ---[ Check if the folder exists ]---
if (-Not (Test-Path -Path $Path)) {
    Write-Error "The specified folder does not exist: $Path"
    exit 1
}

# ---[ Retrieve file names ]---
$fileNames = Get-ChildItem -Path $Path -File | Select-Object -ExpandProperty Name

# ---[ Display in console ]---
Write-Host "`n--- File list in $Path ---`n" -ForegroundColor Cyan
$fileNames | ForEach-Object { Write-Host $_ }

# ------------ [End] ------------ #
exit 0
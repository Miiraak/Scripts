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
#     Title        : Scan-Own-Ports.ps1                                                |
#     Link         : https://github.com/Miiraak/Scripts/tree/master/PowerShell/Discovery/Local/     |
#     Version      : 1.1                                                               |
#     Category     : discovery/local                                                   |
#     Target       : Windows 10/11                                                     |
#     Description  : Full scans for open ports on a own machine.                        |
#                                                                                      |
########################################################################################

<#
.SYNOPSIS
    Full scan for open ports on localhost using Nmap. Downloads Nmap if not present.

.DESCRIPTION
    Scans the specified port range on the local machine using Nmap (aggressive scan).
    Automatically downloads and extracts Nmap from a custom repository if not found.
    Saves reports in XML, Nmap, and GNmap formats to a timestamped folder on the desktop.

.PARAMETER StartPort
    First port in the scan range (default: 1)

.PARAMETER EndPort
    Last port in the scan range (default: 1024)

.EXAMPLE
    .\Scan-Own-Ports.ps1 -StartPort 1 -EndPort 1024
#>

# ---------------[Parameters]--------------- #
param (
    [int]$StartPort = 1,
    [int]$EndPort = 1024
)

# -----------[Configuration]----------- #
$Target = "localhost"
$ScriptDir = $PSScriptRoot
$NmapDir = Join-Path $ScriptDir "nmap"
$NmapExe = Join-Path $NmapDir "nmap.exe"
$NmapUrl = "https://github.com/Miiraak/Scripts/tree/master/Tools/nmap.zip"
$TempZip = Join-Path $env:TEMP "nmap_temp.zip"

# -----------[Validation]----------- #
if ($StartPort -lt 1 -or $EndPort -gt 65535 -or $StartPort -gt $EndPort) {
    Write-Host "[ERROR] Invalid port range specified." -ForegroundColor Red
    exit 1
}

# -----------[Ensure Nmap is available]----------- #
if (-not (Test-Path $NmapExe)) {
    Write-Host "[INFO] Nmap not found locally. Downloading from custom repository..." -ForegroundColor Yellow

    try {
        Invoke-WebRequest -Uri $NmapUrl -OutFile $TempZip -UseBasicParsing
        Write-Host "[INFO] Extracting Nmap..." -ForegroundColor Cyan
        Expand-Archive -Path $TempZip -DestinationPath $NmapDir -Force
        Remove-Item $TempZip -Force -ErrorAction SilentlyContinue

        if (-not (Test-Path $NmapExe)) {
            Write-Host "[ERROR] nmap.exe not found after extraction." -ForegroundColor Red
            exit 1
        }

        Write-Host "[SUCCESS] Nmap is ready: $NmapExe" -ForegroundColor Green
    } catch {
        Write-Host "[ERROR] Failed to download or extract Nmap: $_" -ForegroundColor Red
        exit 1
    }
}

# -----------[Scan Execution]----------- #
$timestamp = Get-Date -Format "yyyy-MM-dd_HHmmss"
$SafeTarget = $Target -replace '[^a-zA-Z0-9]', '_'
$ReportDir = Join-Path ([Environment]::GetFolderPath("Desktop")) "NmapReports\$timestamp"

# Create report folder if it doesn't exist
if (-not (Test-Path $ReportDir)) {
    New-Item -ItemType Directory -Path $ReportDir -Force | Out-Null
}

$OutputBase = Join-Path $ReportDir "aggressif_${SafeTarget}_$timestamp"

$nmapArgs = @(
    "-A",
    "-sV",
    "-sC",
    "-O",
    "-Pn",
    "-T4",
    "-p", "$StartPort-$EndPort",
    "-oA", "$OutputBase",
    "$Target"
)

Write-Host "[INFO] Running Nmap aggressive scan..." -ForegroundColor Cyan
& $NmapExe @nmapArgs | Out-Null

# -----------[Check & Report]----------- #
$XmlFile = "$OutputBase.xml"
if (Test-Path $XmlFile) {
    Write-Host "[SUCCESS] Scan complete. Report saved to:" -ForegroundColor Green
    Write-Host "`n$OutputBase.xml`n$OutputBase.nmap`n$OutputBase.gnmap" -ForegroundColor Cyan
} else {
    Write-Host "[ERROR] Nmap scan failed. No report generated." -ForegroundColor Red
    exit 1
}
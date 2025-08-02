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
#     Title        : Invoke-SandboxDetection.ps1                                                   #
#     Link         : https://github.com/Miiraak/Scripts/tree/master/PowerShell/DefenseEvasion/ProcessManipulation/ #
#     Version      : 2.8                                                                          #
#     Category     : defenseevasion/processmanipulation                                            #
#     Target       : Windows 10/11                                                                #
#     Description  : Advanced sandbox/VM/analysis environment detector with scoring, weighted      #
#                    indicators, summary, and detailed results.                                   #
#                                                                                                 #
###################################################################################################

<#
.SYNOPSIS
    Advanced sandbox/VM/analysis environment detector with weighted scoring, indicator summary, and detailed reporting.

.DESCRIPTION
    This script checks for numerous sandbox, VM, and analysis indicators across hardware, BIOS, services, processes, registry, files, MACs, user environment, timing anomalies, debugger presence, screen size, mouse activity, and PowerShell monitoring. Weighted scores are used for a final verdict with a detailed summary and optional full indicator listing.

.PARAMETER Verbose
    Enable detailed logging of each detection step.

.PARAMETER ShowAllDetails
    Show all detected indicators in the final report.

.PARAMETER SleepTime
    Sleep time (seconds) for timing anomaly detection. Default: 2.

.EXAMPLE
    .\Invoke-SandboxDetection.ps1
    .\Invoke-SandboxDetection.ps1 -Verbose
    .\Invoke-SandboxDetection.ps1 -ShowAllDetails
    .\Invoke-SandboxDetection.ps1 -SleepTime 5
#>

# -------------- [Parameters] -------------- #
param(
    [switch]$Verbose,
    [switch]$ShowAllDetails,
    [int]$SleepTime = 2

)

# -------------- [Functions] -------------- #
function Write-Log {
    param([string]$msg, [string]$lvl="INFO")
    $stamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $color = switch ($lvl) { "ERROR" {"Red"}; "SUCCESS" {"Green"}; "STEP" {"Yellow"}; "WARN" {"Magenta"}; default {"Gray"} }
    if ($Verbose) { Write-Host "[$lvl] $stamp :: $msg" -ForegroundColor $color }
}

# -------------- [Variables] -------------- #
$Indicators = @(
    @{Type="Hardware"; Value=@(
        "VMware","VirtualBox","Xen","QEMU","Parallels","Hyper-V","KVM","VMS","Microsoft Hv",
        "Microsoft Corporation","Virtual Machine","Bochs","BHYVE","OpenStack","Virtuozzo","HITACHI Virtual Storage",
        "HITACHI NAS","Cloud","Google Compute Engine","Amazon EC2","DigitalOcean"
    ); Weight=10},
    @{Type="BIOS"; Value=@(
        "VMware","VirtualBox","Xen","QEMU","Parallels","Hyper-V","KVM","VMS","Microsoft Hv",
        "Microsoft Corporation","Default System BIOS","SeaBIOS","Bochs","Coreboot","Google","Amazon","DigitalOcean"
    ); Weight=9},
    @{Type="Baseboard"; Value=@(
        "VMware","VirtualBox","Virtual","Xen","QEMU","Parallels","KVM","Microsoft Corporation",
        "Bochs","Cloud","Google","Amazon"
    ); Weight=8},
    @{Type="Service"; Value=@(
        "SbieSvc","VBoxService","vmtoolsd","vmsrvc","vmusrvc","qemu-ga","VGAuthService",
        "vmicrdv","vmicheartbeat","vmicvss","vmicshutdown","vmicexchange",
        "vboxservice","vmms","vboxtray","vmware","vmacthlp","vboxadd","prl_tools","prl_services","prl_eth","prl_fs","prl_time"
    ); Weight=8},
    @{Type="Process"; Value=@(
        "vboxtray.exe","vmtoolsd.exe","vmwareuser.exe","vmacthlp.exe","VGAuthService.exe","SbieCtrl.exe",
        "SandboxieCrypto.exe","qemu-ga.exe","prl_tools.exe","svga.exe","vmicsvc.exe",
        "vboxservice.exe","vboxadd.exe","prl_tools.exe","prl_eth.exe","prl_fs.exe","prl_time.exe",
        "wireshark.exe","procmon.exe","filemon.exe","regmon.exe","ollydbg.exe","x64dbg.exe","ImmunityDebugger.exe",
        "ida.exe","idag.exe","idaw.exe","idau.exe","scylla.exe","scylla_x64.exe","scylla_x86.exe",
        "fiddler.exe","burpsuite.exe","tcpview.exe","processhacker.exe"
    ); Weight=7},
    @{Type="Registry"; Value=@(
        "HKLM:\\SYSTEM\\CurrentControlSet\\Services\\VBoxService",
        "HKLM:\\SYSTEM\\CurrentControlSet\\Services\\vmtools",
        "HKLM:\\SYSTEM\\CurrentControlSet\\Services\\SbieDrv",
        "HKLM:\\HARDWARE\\DESCRIPTION\\System\\BIOS",
        "HKLM:\\SYSTEM\\CurrentControlSet\\Services\\vmicvss",
        "HKLM:\\SYSTEM\\CurrentControlSet\\Services\\vmicrdv",
        "HKLM:\\SYSTEM\\CurrentControlSet\\Services\\vmicheartbeat",
        "HKLM:\\SYSTEM\\CurrentControlSet\\Services\\vmicshutdown",
        "HKLM:\\SYSTEM\\CurrentControlSet\\Services\\vmicexchange",
        "HKLM:\\SOFTWARE\\Oracle\\VirtualBox Guest Additions",
        "HKLM:\\SOFTWARE\\VMware, Inc.\\VMware Tools",
        "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\Sandboxie",
        "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\Wireshark"
    ); Weight=6},
    @{Type="File"; Value=@(
        "C:\\WINDOWS\\System32\\drivers\\vmmouse.sys","C:\\WINDOWS\\System32\\drivers\\vmhgfs.sys",
        "C:\\WINDOWS\\System32\\drivers\\VBoxMouse.sys","C:\\WINDOWS\\System32\\drivers\\SbieDrv.sys",
        "C:\\WINDOWS\\System32\\drivers\\prl_tools.sys","C:\\Windows\\System32\\drivers\\vmicheartbeat.sys",
        "C:\\Windows\\System32\\drivers\\vmicrdv.sys","C:\\Windows\\System32\\drivers\\vmicvss.sys",
        "C:\\Windows\\System32\\drivers\\vmicshutdown.sys","C:\\Windows\\System32\\drivers\\vmicexchange.sys",
        "C:\\Windows\\System32\\drivers\\vboxguest.sys","C:\\Windows\\System32\\drivers\\vm3dgl.dll",
        "C:\\Windows\\System32\\drivers\\vm3dver.dll","C:\\Windows\\System32\\drivers\\VBoxSF.sys",
        "C:\\Windows\\System32\\drivers\\VBoxVideo.sys"
    ); Weight=6},
    @{Type="MAC"; Value=@(
        "00:05:69","00:0C:29","00:1C:14","00:50:56","08:00:27","00:03:FF","00:15:5D",
        "00:16:3E","00:1C:42","00:18:51","00:1B:21","00:21:F6","00:0F:4B"
    ); Weight=6},
    @{Type="User"; Value=@(
        "sandbox","analysis","maltest","vmuser","vbox","test","user","admin","lab","sample","demo","guest"
    ); Weight=3},
    @{Type="Timing"; Value=@("Timing anomaly detected (sleep skipped/accelerated)"); Weight=8},
    @{Type="Debugger"; Value=@("Debugger detected"); Weight=10},
    @{Type="Env"; Value=@(
        "CI","GITHUB_ACTIONS","APPVEYOR","JENKINS_HOME","TRAVIS","TEAMCITY_VERSION",
        "BUILD_BUILDID","BUILD_DEFINITIONNAME","AZURE_HTTP_USER_AGENT","CIRCLECI","BAMBOO_BUILDKEY"
    ); Weight=5},
    @{Type="ScreenSize"; Value=@("800x600","1024x768","1280x1024","640x480"); Weight=2},
    @{Type="MouseActivity"; Value=@("Low mouse activity detected"); Weight=2},
    @{Type="Monitoring"; Value=@("PowerShellLog","ScriptBlockLogging","ModuleLogging","Transcription"); Weight=3},
    @{Type="AnalysisTool"; Value=@(
        "procmon.exe","filemon.exe","regmon.exe","ollydbg.exe","x64dbg.exe","ImmunityDebugger.exe",
        "ida.exe","idag.exe","idaw.exe","idau.exe","scylla.exe","scylla_x64.exe","scylla_x86.exe",
        "fiddler.exe","burpsuite.exe","tcpview.exe","processhacker.exe","wireshark.exe"
    ); Weight=4}
)

$global:DetectionResults = @()

function Add-Detection {
    param($Type, $Indicator, $Weight, $Details)
    $global:DetectionResults += [PSCustomObject]@{
        Type = $Type
        Indicator = $Indicator
        Weight = $Weight
        Details = $Details
    }
}

# -------------- [Execution] -------------- #
# --- Detection checks ---
try {
    $bios = (Get-WmiObject -Class Win32_BIOS).SerialNumber
    $manufacturer = (Get-WmiObject -Class Win32_ComputerSystem).Manufacturer
    $model = (Get-WmiObject -Class Win32_ComputerSystem).Model
    $baseboard = (Get-WmiObject -Class Win32_BaseBoard).Product
} catch { $bios = $manufacturer = $model = $baseboard = "" }

foreach ($hw in $Indicators | Where-Object {$_.Type -eq "Hardware"}) {
    foreach ($indicator in $hw.Value) {
        if ($bios -like "*$indicator*" -or $manufacturer -like "*$indicator*" -or $model -like "*$indicator*") {
            Add-Detection -Type "Hardware" -Indicator $indicator -Weight $hw.Weight -Details "BIOS/Manufacturer/Model"
            Write-Log "Hardware: $indicator" "STEP"
        }
    }
}
foreach ($bb in $Indicators | Where-Object {$_.Type -eq "Baseboard"}) {
    foreach ($indicator in $bb.Value) {
        if ($baseboard -like "*$indicator*") {
            Add-Detection -Type "Baseboard" -Indicator $indicator -Weight $bb.Weight -Details "Baseboard"
            Write-Log "Baseboard: $indicator" "STEP"
        }
    }
}
foreach ($biosind in $Indicators | Where-Object {$_.Type -eq "BIOS"}) {
    foreach ($indicator in $biosind.Value) {
        if ($bios -like "*$indicator*") {
            Add-Detection -Type "BIOS" -Indicator $indicator -Weight $biosind.Weight -Details "BIOS"
            Write-Log "BIOS: $indicator" "STEP"
        }
    }
}

foreach ($svcInd in $Indicators | Where-Object {$_.Type -eq "Service"}) {
    foreach ($svc in $svcInd.Value) {
        if (Get-Service -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "*$svc*" }) {
            Add-Detection -Type "Service" -Indicator $svc -Weight $svcInd.Weight -Details "Service"
            Write-Log "Service: $svc" "STEP"
        }
    }
}

foreach ($procInd in $Indicators | Where-Object {$_.Type -eq "Process"}) {
    foreach ($procName in $procInd.Value) {
        if (Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.ProcessName -like "*$($procName -replace '.exe$','')*" }) {
            Add-Detection -Type "Process" -Indicator $procName -Weight $procInd.Weight -Details "Process"
            Write-Log "Process: $procName" "STEP"
        }
    }
}

foreach ($regInd in $Indicators | Where-Object {$_.Type -eq "Registry"}) {
    foreach ($regKey in $regInd.Value) {
        if (Test-Path $regKey) {
            Add-Detection -Type "Registry" -Indicator $regKey -Weight $regInd.Weight -Details "Registry"
            Write-Log "Registry: $regKey" "STEP"
        }
    }
}

foreach ($fileInd in $Indicators | Where-Object {$_.Type -eq "File"}) {
    foreach ($filePath in $fileInd.Value) {
        if (Test-Path $filePath) {
            Add-Detection -Type "File" -Indicator $filePath -Weight $fileInd.Weight -Details "File"
            Write-Log "File: $filePath" "STEP"
        }
    }
}

try {
    $adapters = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object { $_.MACAddress }
    foreach ($macInd in $Indicators | Where-Object {$_.Type -eq "MAC"}) {
        foreach ($adapter in $adapters) {
            foreach ($macPrefix in $macInd.Value) {
                if ($adapter.MACAddress -like "$macPrefix*") {
                    Add-Detection -Type "MAC" -Indicator $adapter.MACAddress -Weight $macInd.Weight -Details "Network"
                    Write-Log "MAC: $($adapter.MACAddress)" "STEP"
                }
            }
        }
    }
} catch {
    Write-Log "Failed to retrieve network adapters: $_" "ERROR"
}

$user = $env:USERNAME
foreach ($userInd in $Indicators | Where-Object {$_.Type -eq "User"}) {
    foreach ($userTest in $userInd.Value) {
        if ($user -match $userTest) {
            Add-Detection -Type "User" -Indicator $user -Weight $userInd.Weight -Details "Username"
            Write-Log "User: $user" "STEP"
        }
    }
}

foreach ($envInd in $Indicators | Where-Object {$_.Type -eq "Env"}) {
    foreach ($envTest in $envInd.Value) {
        if ($null -ne $env -and ![string]::IsNullOrEmpty($envTest) -and ($env.ContainsKey($envTest) -and $env[$envTest] -ne $null -and $env[$envTest] -ne "")) {
            Add-Detection -Type "Env" -Indicator $envTest -Weight $envInd.Weight -Details "Environment Variable"
            Write-Log "Env: $envTest" "STEP"
        }
    }
}

$start = Get-Date
Start-Sleep -Seconds $SleepTime
$stop = Get-Date
$delta = ($stop - $start).TotalSeconds
if ($delta -lt ($SleepTime * 0.7)) {
    foreach ($timInd in $Indicators | Where-Object {$_.Type -eq "Timing"}) {
        Add-Detection -Type "Timing" -Indicator $timInd.Value[0] -Weight $timInd.Weight -Details "Sleep anomaly"
        Write-Log "Timing anomaly detected (possible sandbox)" "STEP"
    }
}

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class DebugCheck {
    [DllImport("kernel32.dll")]
    public static extern bool IsDebuggerPresent();
}
"@
if ([DebugCheck]::IsDebuggerPresent()) {
    foreach ($dbgInd in $Indicators | Where-Object {$_.Type -eq "Debugger"}) {
        Add-Detection -Type "Debugger" -Indicator $dbgInd.Value[0] -Weight $dbgInd.Weight -Details "Debugger"
        Write-Log "Debugger detected (IsDebuggerPresent)" "STEP"
    }
}

try {
    Add-Type -AssemblyName System.Windows.Forms
    $screen = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
    $sizeStr = "$($screen.Width)x$($screen.Height)"
    foreach ($scrInd in $Indicators | Where-Object {$_.Type -eq "ScreenSize"}) {
        foreach ($sz in $scrInd.Value) {
            if ($sizeStr -eq $sz) {
                Add-Detection -Type "ScreenSize" -Indicator $sizeStr -Weight $scrInd.Weight -Details "Screen size"
                Write-Log "ScreenSize: $sizeStr" "STEP"
            }
        }
    }
} catch {
    Write-Log "Failed to retrieve screen size: $_" "ERROR"
}

try {
    Add-Type -AssemblyName System.Windows.Forms
    $mouseMove = [System.Windows.Forms.Cursor]::Position
    Start-Sleep -Milliseconds 800
    $mouseMove2 = [System.Windows.Forms.Cursor]::Position
    if ($mouseMove -eq $mouseMove2) {
        foreach ($mouseInd in $Indicators | Where-Object {$_.Type -eq "MouseActivity"}) {
            Add-Detection -Type "MouseActivity" -Indicator $mouseInd.Value[0] -Weight $mouseInd.Weight -Details "Mouse"
            Write-Log "Low mouse activity detected" "WARN"
        }
    }
} catch {
    Write-Log "Failed to check mouse activity: $_" "ERROR"
}

$psLogPaths = @(
    "${env:SystemRoot}\System32\WindowsPowerShell\v1.0\powershell.exe",
    "${env:SystemRoot}\System32\WindowsPowerShell\v1.0\powershell_ise.exe"
)
foreach ($psPath in $psLogPaths) {
    if (Test-Path $psPath) {
        if ((Get-Content $psPath -ErrorAction SilentlyContinue | Select-String "Log") -or 
            (Get-Content $psPath -ErrorAction SilentlyContinue | Select-String "Monitor")) {
            Add-Detection -Type "Monitoring" -Indicator "PowerShellLog" -Weight 3 -Details "PowerShell binary contains suspicious strings"
            Write-Log "PowerShell monitoring detected" "WARN"
        }
    }
}

foreach ($toolInd in $Indicators | Where-Object {$_.Type -eq "AnalysisTool"}) {
    foreach ($procName in $toolInd.Value) {
        if (Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.ProcessName -like "*$($procName -replace '.exe$','')*" }) {
            Add-Detection -Type "AnalysisTool" -Indicator $procName -Weight $toolInd.Weight -Details "Analysis Tool Running"
            Write-Log "AnalysisTool: $procName" "WARN"
        }
    }
}

# --- CROSS-CHECK LOGIC TO AVOID FALSE POSITIVES ---
function IsHyperVHost {
    param($DetectionResults)
    $hwIndicators = $DetectionResults | Where-Object { $_.Type -eq "Hardware" -or $_.Type -eq "BIOS" -or $_.Type -eq "Baseboard" }
    $vmIndicators = $DetectionResults | Where-Object { $_.Type -eq "Service" -and $_.Indicator -match "^vmic|vmms" }
    # If Hyper-V services present but no typical VM hardware/model/BIOS
    if ($vmIndicators.Count -gt 0 -and $hwIndicators.Count -eq 0) { return $true } else { return $false }
}

function Get-DetectionScore {
    param($DetectionResults)
    $typeScores = @{}
    foreach ($item in $DetectionResults) {
        if ($typeScores.ContainsKey($item.Type)) {
            if ($item.Weight -gt $typeScores[$item.Type]) {
                $typeScores[$item.Type] = $item.Weight
            }
        } else {
            $typeScores[$item.Type] = $item.Weight
        }
    }
    $total = 0
    foreach ($type in $typeScores.Keys) { $total += $typeScores[$type] }
    return @{Total=$total; PerType=$typeScores}
}

function Get-ScoreColor {
    param($score)
    if ($score -ge 35) { return "Red" }
    elseif ($score -ge 20) { return "Yellow" }
    elseif ($score -ge 10) { return "Magenta" }
    else { return "Green" }
}

function Show-SandboxSummary {
    param($DetectionResults)
    Write-Host ""
    Write-Host "====================[ SANDBOX / VM / ANALYSIS DETECTION REPORT ]====================" -ForegroundColor Cyan
    Write-Host (" Date: {0,-25} User: {1,-18}" -f (Get-Date), $env:USERNAME) -ForegroundColor White
    Write-Host (" Hostname: {0,-20} OS: {1,-22}" -f $env:COMPUTERNAME, (Get-WmiObject Win32_OperatingSystem).Caption) -ForegroundColor White
    Write-Host "------------------------------------------------------------------------------------" -ForegroundColor DarkGray
    if ($DetectionResults.Count -gt 0) {
        $sorted = $DetectionResults | Sort-Object -Property Weight -Descending
        Write-Host "`nTop 5 indicators (by weight):" -ForegroundColor Yellow
        foreach ($item in $sorted | Select-Object -First 5) {
            Write-Host ("- [{0,2} pts] {1,-14} {2,-25} {3}" -f $item.Weight, $item.Type, $item.Indicator, $item.Details) -ForegroundColor Magenta
        }
        $scoreObj = Get-DetectionScore $DetectionResults

        Write-Host "`nScore per indicator type:" -ForegroundColor Yellow
        foreach ($k in $scoreObj.PerType.Keys) {
            Write-Host ("- {0,-14}: {1,2} pts" -f $k, $scoreObj.PerType[$k]) -ForegroundColor Gray
        }
        $scoreColor = Get-ScoreColor $scoreObj.Total
        Write-Host "`n------------------------------------------------------------------------------------" -ForegroundColor DarkGray
        Write-Host (" Final Machine Score: {0,3} " -f $scoreObj.Total) -ForegroundColor $scoreColor

        $criticalTypes = @("Hardware","BIOS","Baseboard","MAC","Service","Process","AnalysisTool")
        $verdict = $false
        foreach ($type in $criticalTypes) {
            if ($scoreObj.PerType.ContainsKey($type)) { $verdict = $true }
        }

        $isHyperVHost = IsHyperVHost $DetectionResults

        Write-Host ""
        if ($isHyperVHost) {
            Write-Host "[ Hyper-V Host detected, not a VM/Sandbox. ]" -ForegroundColor Cyan
        }
        elseif ($verdict -and $scoreObj.Total -ge 15) {
            Write-Host "[ SANDBOX DETECTED ]" -ForegroundColor Red
            exit 42
        } elseif ($scoreObj.Total -ge 25) {
            Write-Host "[ Potential sandbox/analysis environment ]" -ForegroundColor Yellow
        } elseif ($scoreObj.Total -ge 10) {
            Write-Host "[ Suspicious indicators detected ]" -ForegroundColor Magenta
        } else {
            Write-Host "[ No sandbox/VM/analysis/debug detected ]" -ForegroundColor Green
        }
        Write-Host "`n====================================================================================" -ForegroundColor Cyan

        # --- Always show all indicators if requested ---
        if ($ShowAllDetails) {
            Write-Host "`nAll detected indicators:" -ForegroundColor Yellow
            foreach ($item in $DetectionResults | Sort-Object -Property Weight -Descending) {
                Write-Host ("- [{0,2} pts] {1,-14} {2,-25} {3}" -f $item.Weight, $item.Type, $item.Indicator, $item.Details) -ForegroundColor Gray
            }
            Write-Host "`n====================================================================================" -ForegroundColor Cyan
        }
    } else {
        Write-Host "`nNo sandbox/VM/analysis/debug detected." -ForegroundColor Green
        Write-Host "`n====================================================================================" -ForegroundColor Cyan
    }
}

Show-SandboxSummary $global:DetectionResults      

# -------------- [End] -------------- #  
exit 0
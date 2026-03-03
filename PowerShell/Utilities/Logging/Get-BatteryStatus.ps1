########################################################################################
#                                                                                      |
#                 ███▄ ▄███▓ ██▓ ██▓ ██▀███   ▄▄▄      ▄▄▄       ██ ▄█▀                |
#                ▓██▒▀█▀ ██▒▓██▒▓██▒▓██ ▒ ██▒▒████▄   ▒████▄     ██▄█▒                 |
#                ▓██    ▓██░▒██▒▒██▒▓██ ░▄█ ▒▒██  ▀█▄ ▒██  ���█▄  ▓███▄░                 |
#                ▒██    ▒██ ░██░░██░▒██▀▀█▄  ░██▄▄▄▄██░██▄▄▄▄██ ▓██ █▄                 |
#                ▒██▒   ░██▒░██░░██░░██▓ ▒██▒ ▓█   ▓██▒▓█   ▓██▒▒██▒ █▄                |
#                ░ ▒░   ░  ░░▓  ░▓  ░ ▒▓ ░▒▓░ ▒▒   ▓▒█░▒▒   ▓▒█░▒ ▒▒ ▓▒                |
#                ░  ░      ░ ▒ ░ ▒ ░  ░▒ ░ ▒░  ▒   ▒▒ ░ ▒   ▒▒ ░░ ░▒ ▒░                |
#                ░      ░    ▒ ░ ▒ ░  ░░   ░   ░   ▒    ░   ▒   ░ ░░ ░                 |
#                       ░    ░   ░     ░           ░  ░     ░  ░░  ░                   |
#                                                                                      |
#     Title        : Get-BatteryStatus.ps1                                             |
#     Link         : https://github.com/Miiraak/Scripts/tree/master/PowerShell/Utilities/Logging/   |
#     Version      : 5.3                                                               |
#     Category     : utilities/logging                                                 |
#     Target       : Windows 10/11                                                     |
#     Description  : Battery analysis report - health, consumption & runtime estimate  |
########################################################################################

<#
.SYNOPSIS
  Displays a structured battery analysis report in the console.

.DESCRIPTION
  - Machine identity (computer name, CPU)
  - Battery health: Design vs Current capacity, wear %
  - Usage statistics: session count + average consumption (W)
  - Runtime estimation: current battery vs new battery
  - All data sourced from a single powercfg /batteryreport HTML file.
    CPU name falls back to Win32_Processor if absent from the report.

.EXAMPLE
  .\Get-BatteryStatus.ps1

.EXAMPLE
  .\Get-BatteryStatus.ps1 -Verbose
#>

[CmdletBinding()]
param()

#region -- Helpers ----------------------------------------------------------------

function Format-Runtime ([double]$Hours) {
    if ($Hours -le 0) { return "N/A" }
    $h = [int][math]::Floor($Hours)
    $m = [int][math]::Round(($Hours - $h) * 60)
    if ($m -eq 60) { $h++; $m = 0 }
    "{0} h {1:D2} min" -f $h, $m
}

function Write-Header ([string]$Title) {
    Write-Host ""
    Write-Host $Title -ForegroundColor White
    Write-Host ("-" * $Title.Length) -ForegroundColor DarkGray
}

function Write-KV ([string]$Key, $Value, [int]$Width = 30) {
    if ($null -eq $Value -or "$Value" -eq "") { return }
    Write-Host ("{0,-$Width}: {1}" -f $Key, $Value)
}

# Strips HTML tags and collapses whitespace from a raw cell string
function Strip-Html ([string]$s) {
    ($s -replace '<[^>]+>', ' ' -replace '\s+', ' ').Trim()
}

# Parses "90 005 mWh" or "67 864 mWh" -> int in mWh (removes all non-digits)
function Parse-MWh ([string]$s) {
    $clean = $s -replace '[^\d]', ''
    if ($clean) { [int]$clean } else { $null }
}

#endregion

#region -- powercfg report --------------------------------------------------------

function Get-BatteryReportHtml {
    $tmp = Join-Path $env:TEMP ("batteryreport_{0}.html" -f [guid]::NewGuid().ToString("N"))
    try {
        Write-Verbose "Generating: $tmp"
        $p = Start-Process powercfg.exe `
            -ArgumentList "/batteryreport /output `"$tmp`"" `
            -Wait -PassThru -NoNewWindow -ErrorAction Stop
        if ($p.ExitCode -ne 0 -or -not (Test-Path $tmp)) {
            Write-Verbose "powercfg exited $($p.ExitCode) or file missing."
            return $null
        }
        Get-Content $tmp -Raw -ErrorAction Stop
    }
    catch {
        Write-Verbose "powercfg failed: $($_.Exception.Message)"
        $null
    }
    finally {
        Remove-Item $tmp -Force -ErrorAction SilentlyContinue
    }
}

#endregion

#region -- Parsers ----------------------------------------------------------------

function Get-MachineInfoFromHtml ([string]$Html) {
    # COMPUTER NAME row:        <td class="label">COMPUTER NAME</td><td>APOCRYPHA</td>
    $computer = if ($Html -match '(?is)COMPUTER\s+NAME\s*</td>\s*<td[^>]*>\s*([^<]+)') {
        $matches[1].Trim()
    } else { $env:COMPUTERNAME }

    # SYSTEM PRODUCT NAME row -> this is the machine model, not the CPU
    $model = if ($Html -match '(?is)SYSTEM\s+PRODUCT\s+NAME\s*</td>\s*<td[^>]*>\s*([^<]+)') {
        $matches[1].Trim()
    }

    # CPU is not in the powercfg report -> single targeted CIM call
    $cpu = try {
        (Get-CimInstance -ClassName Win32_Processor -ErrorAction Stop |
         Select-Object -First 1).Name.Trim()
    } catch { "N/A" }

    [pscustomobject]@{
        Computer = if ($model) { $model } else { $computer }
        CPU      = $cpu
    }
}

function Get-CapacitiesFromHtml ([string]$Html) {
    if (-not $Html) { return $null }

    # Target the "Installed batteries" table:
    # <span class="label">DESIGN CAPACITY</span></td><td>90 005 mWh\n      </td>
    # <span class="label">FULL CHARGE CAPACITY</span></td><td>67 864 mWh\n      </td>
    $design = if ($Html -match '(?is)DESIGN\s+CAPACITY</span></td>\s*<td[^>]*>\s*([\d\s]+)\s*mWh') {
        Parse-MWh $matches[1]
    }
    $full = if ($Html -match '(?is)FULL\s+CHARGE\s+CAPACITY</span></td>\s*<td[^>]*>\s*([\d\s]+)\s*mWh') {
        Parse-MWh $matches[1]
    }

    if (-not $design -and -not $full) { return $null }
    [pscustomobject]@{ DesignMWh = $design; FullMWh = $full }
}

function Get-SessionStats ([string]$Html) {
    if (-not $Html) { return $null }

    # Isolate the "Battery usage" table (between the two <h2> tags that surround it)
    # Sessions rows have class="dc" and contain:
    #   <td class="hms">0:16:21</td>   <- duration
    #   <td class="mw">5 376 mWh</td>  <- energy drained

    $watts = foreach ($row in [regex]::Matches($Html, '(?is)<tr[^>]*class="[^"]*dc[^"]*"[^>]*>(.*?)</tr>')) {
        $inner = $row.Groups[1].Value

        # Duration cell: <td class="hms">h:mm:ss</td>
        $durMatch = [regex]::Match($inner, '(?is)<td[^>]*class="[^"]*hms[^"]*"[^>]*>\s*(\d+:\d{2}:\d{2})\s*</td>')
        if (-not $durMatch.Success) { continue }

        # Energy cell: <td class="mw">5 376 mWh</td>
        $mwhMatch = [regex]::Match($inner, '(?is)<td[^>]*class="[^"]*mw[^"]*"[^>]*>\s*([\d\s]+)\s*mWh')
        if (-not $mwhMatch.Success) { continue }

        $p   = $durMatch.Groups[1].Value -split ':'
        $sec = [int]$p[0] * 3600 + [int]$p[1] * 60 + [int]$p[2]
        $mWh = Parse-MWh $mwhMatch.Groups[1].Value

        if ($sec -lt 120 -or -not $mWh -or $mWh -le 0) { continue }

        $w = ($mWh / 1000.0) / ($sec / 3600.0)
        if ($w -gt 0 -and $w -le 200) { $w }
    }

    if (-not $watts) { return $null }
    [pscustomobject]@{
        Count   = @($watts).Count
        AvgWatt = [math]::Round(($watts | Measure-Object -Average).Average, 1)
    }
}

#endregion

#region -- Battery presence -------------------------------------------------------

function Test-BatteryPresent {
    Add-Type -AssemblyName System.Windows.Forms -ErrorAction SilentlyContinue
    $ps = [System.Windows.Forms.SystemInformation]::PowerStatus
    $ps.BatteryChargeStatus -ne [System.Windows.Forms.BatteryChargeStatus]::NoBattery
}

#endregion

#region -- Main -------------------------------------------------------------------

if (-not (Test-BatteryPresent)) {
    Write-Host "No battery detected." -ForegroundColor Red
    exit 2
}

$html = Get-BatteryReportHtml

if (-not $html) {
    Write-Host "Failed to generate battery report. Try running as Administrator." -ForegroundColor Red
    exit 1
}

$machineName = $env:COMPUTERNAME
$machine  = Get-MachineInfoFromHtml $html
$caps     = Get-CapacitiesFromHtml  $html
$sessions = Get-SessionStats        $html

$designWh = if ($caps -and $caps.DesignMWh) { [int][math]::Round($caps.DesignMWh / 1000) }
$fullWh   = if ($caps -and $caps.FullMWh)   { [int][math]::Round($caps.FullMWh   / 1000) }

$wearPct   = $null
$healthPct = $null
if ($designWh -and $fullWh -and $designWh -gt 0) {
    $wearPct   = [int][math]::Max(0, [math]::Round((1 - $fullWh / $designWh) * 100))
    $healthPct = 100 - $wearPct
}

$rtCurrent = $null
$rtNew     = $null
$gainMin   = $null
if ($sessions -and $sessions.AvgWatt -gt 0) {
    if ($fullWh)   { $rtCurrent = $fullWh   / $sessions.AvgWatt }
    if ($designWh) { $rtNew     = $designWh / $sessions.AvgWatt }
    if ($rtCurrent -and $rtNew) {
        $gainMin = [int][math]::Round(($rtNew - $rtCurrent) * 60)
    }
}

#endregion

#region -- Output -----------------------------------------------------------------

Write-Host ""
Write-Host "==== BATTERY ANALYSIS REPORT ====" -ForegroundColor Cyan
Write-Host ""
Write-KV "Report generated" (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Write-KV "Machine name"   $machineName
Write-KV "Computer" $machine.Computer
Write-KV "CPU"      $machine.CPU

Write-Header "Battery information"
Write-KV "Design Capacity"  $(if ($designWh)            { "$designWh Wh" }  else { "N/A" })
Write-KV "Current Capacity" $(if ($fullWh)              { "$fullWh Wh" }    else { "N/A" })
Write-KV "Battery Health"   $(if ($null -ne $healthPct) { "$healthPct %" }  else { "N/A" })

Write-Header "Usage statistics"
if ($sessions) {
    Write-KV "Analyzed sessions"   $sessions.Count
    Write-KV "Average consumption" "$($sessions.AvgWatt) W"
} else {
    Write-Host "  No discharge sessions found." -ForegroundColor DarkYellow
}

Write-Header "Battery life estimation"
if ($rtCurrent -or $rtNew) {
    Write-KV "Estimated runtime (current battery)" (Format-Runtime $rtCurrent) 38
    Write-KV "Estimated runtime (new battery)"     (Format-Runtime $rtNew)     38
} else {
    Write-Host "  Insufficient data for runtime estimation." -ForegroundColor DarkYellow
}

Write-Header "Conclusion"
if ($null -ne $wearPct) {
    if ($wearPct -lt 5) {
        Write-Host "  Battery is in good condition. No replacement needed." -ForegroundColor Green
    } else {
        Write-KV "Battery wear detected" "$wearPct %"
        if ($null -ne $gainMin -and $gainMin -gt 0) {
            Write-Host "  Replacing the battery would increase runtime by ~$gainMin minutes."
        } elseif ($null -ne $gainMin) {
            Write-Host "  Battery wear present but runtime gain would be negligible." -ForegroundColor DarkYellow
        } else {
            Write-Host "  Could not estimate runtime gain (missing data)." -ForegroundColor DarkYellow
        }
    }
} else {
    Write-Host "  Unable to determine battery wear (capacity data unavailable)." -ForegroundColor DarkYellow
}

Write-Host ""
Write-Host "Tip: run with -Verbose for detailed query information." -ForegroundColor DarkGray
exit 0

#endregion
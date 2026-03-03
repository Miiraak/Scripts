# Get-BatteryStatus.ps1

## Overview
**Get-BatteryStatus.ps1** is a PowerShell script for Windows 10/11 that prints a **structured battery analysis report directly in the console**.

It provides a clear, technician-readable summary of battery health, real-world consumption and runtime estimates — without having to open an HTML file.  
All data is sourced from a single **`powercfg /batteryreport`** HTML file generated temporarily at runtime.

## What it shows

### Machine identity
- Computer name (from `$env`)
- Computer model (from `SYSTEM PRODUCT NAME` in the powercfg report)
- CPU name (via `Win32_Processor`)

### Battery information
- **Design capacity** *(factory/original maximum)* in **Wh**
- **Current capacity** *(current maximum)* in **Wh**
- **Battery health (%)** computed from Design vs Current capacity

### Usage statistics
- Number of **analyzed discharge sessions** (parsed from the powercfg report)
- **Average power consumption** in **Watts** across all sessions

### Battery life estimation
- **Estimated runtime** with the current battery
- **Estimated runtime** with a new (design capacity) battery

### Conclusion
- **Wear level (%)** 
- Potential **runtime gain** from replacing the battery (in minutes)

## Data sources
All data comes from a single source:

| Data | Source |
|---|---|
| Computer name | `$env:COMPUTERNAME` |
| Computer model | `powercfg /batteryreport` HTML (`SYSTEM PRODUCT NAME`) |
| Design / Current capacity | `powercfg /batteryreport` HTML (`Installed batteries` table) |
| Discharge sessions (duration + energy) | `powercfg /batteryreport` HTML (`Battery usage` table) |
| CPU name | `Win32_Processor` (CIM, single call — not in powercfg report) |
| Battery presence | `System.Windows.Forms.SystemInformation.PowerStatus` |

The script generates a **temporary** HTML file in `%TEMP%`, parses the needed values, then **deletes it immediately**.

## Parameters
This script does not take any custom parameters.  
You can use standard PowerShell common parameters such as:
- `-Verbose` to see the path of the generated report and any internal diagnostic messages.

## Usage
```powershell
.\Get-BatteryStatus.ps1
```

Verbose mode (recommended for troubleshooting):
```powershell
.\Get-BatteryStatus.ps1 -Verbose
```

## Output example
```text
==== BATTERY ANALYSIS REPORT ====

Computer                      : HP EliteBook 840 G8
CPU                           : Intel Core i5-1135G7

Battery information
-------------------
Design Capacity               : 53 Wh
Current Capacity              : 37 Wh
Battery Health                : 70 %

Usage statistics
----------------
Analyzed sessions             : 34
Average consumption           : 12 W

Battery life estimation
-----------------------
Estimated runtime (current battery)   : 2 h 33 min
Estimated runtime (new battery)       : 3 h 43 min

Conclusion
----------
Battery wear detected         : 24 %
  Replacing the battery would increase runtime by ~70 minutes.
```

## Help & documentation
```powershell
Get-Help .\Get-BatteryStatus.ps1
```

## Troubleshooting

### "No battery detected"
You are likely running the script on a desktop, a VM, or a device without a battery.

### "Failed to generate battery report"
`powercfg` requires elevated privileges on some systems.  
Try running PowerShell **as Administrator**.

### Capacity shows "N/A"
The `powercfg /batteryreport` HTML structure may differ on non-English Windows installations.  
Run with `-Verbose` to confirm the report was generated, then inspect the HTML file manually before it is deleted (add a breakpoint or comment out the `finally` block temporarily).

### No discharge sessions found
This can happen if the machine has only been used on AC power recently, or if the battery report does not contain any discharge entries for the last 7 days.

## Requirements
- Windows 10 / 11
- PowerShell 5.1 or PowerShell 7+
- `powercfg.exe` available (built-in on all Windows versions)
- Administrator rights may be required for `powercfg /batteryreport`

## License
```text
MIT License

Copyright (c) 2025 Miiraak

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
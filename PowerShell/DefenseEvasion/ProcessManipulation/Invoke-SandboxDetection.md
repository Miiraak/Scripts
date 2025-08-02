# Invoke-SandboxDetection.ps1

## Overview
**Invoke-SandboxDetection.ps1** is an advanced PowerShell script for detecting sandbox, virtual machine, and analysis environments on Windows 10/11. It uses a weighted scoring system and a comprehensive set of indicators across hardware, BIOS, services, registry, files, MAC addresses, user environment, debugging, and more. The report provides a summary verdict (sandbox/VM detected, suspicious, clean, etc.) and can show all detected indicators in detail.

## Features
- **Weighted Detection:** Each indicator type (hardware, BIOS, service, process, registry, etc.) has a configurable weight for scoring.
- **Multiple Detection Vectors:** Checks hardware, BIOS, baseboard, running processes, services, registry keys, files, MAC addresses, environment variables, user names, timing anomalies, debugger presence, screen size, mouse activity, and PowerShell monitoring.
- **Scoring & Verdict:** Final score determines the verdict, with color-coded output (Red, Yellow, Magenta, Green).
- **False Positive Handling:** Includes logic to avoid false positives (e.g., Hyper-V host detection).
- **Verbose & Detailed Output:** Optional verbose logging and full indicator listing.
- **Customizable:** Sleep time between checks can be adjusted.

## Parameters
| Name            | Type    | Default | Description                                                        |
|-----------------|---------|---------|--------------------------------------------------------------------|
| Verbose         | switch  | Off     | Show detailed log output of each detection step                    |
| ShowAllDetails  | switch  | Off     | Show all detected indicators in the final report                   |
| SleepTime       | int     | 2       | Sleep time (seconds) for timing anomaly detection                  |

## Usage
Basic scan:
```powershell
.\Invoke-SandboxDetection.ps1
```

Verbose output:
```powershell
.\Invoke-SandboxDetection.ps1 -Verbose
```

Show all detected indicators in summary:
```powershell
.\Invoke-SandboxDetection.ps1 -ShowAllDetails
```

Adjust sleep time (timing anomaly detection):
```powershell
.\Invoke-SandboxDetection.ps1 -SleepTime 5
```

## Output Example
```
====================[ SANDBOX / VM / ANALYSIS DETECTION REPORT ]====================
 Date: 2025-07-29 19:23:59         User: Miiraak            
 Hostname: MYPC               OS: Microsoft Windows 10 Pro    
------------------------------------------------------------------------------------
Top 5 indicators (by weight):
- [10 pts] Hardware      VMware                     BIOS/Manufacturer/Model
- [ 9 pts] BIOS          VMware                     BIOS
- [ 8 pts] Service       VBoxService                Service
- [ 7 pts] Process       vboxtray.exe               Process
- [ 6 pts] MAC           00:0C:29:AA:BB:CC          Network

Score per indicator type:
- Hardware      : 10 pts
- BIOS          : 9 pts
- Service       : 8 pts
- Process       : 7 pts
- MAC           : 6 pts

 Final Machine Score: 40 
[ SANDBOX DETECTED ]

====================================================================================
```

## Help & Documentation
```powershell
Get-Help .\Invoke-SandboxDetection.ps1
man .\Invoke-SandboxDetection.ps1
```

## Troubleshooting
- **False Positives:** Hyper-V hosts are detected and excluded from VM/sandbox verdicts.
- **Performance:** Some checks (services, processes, registry, files) may take longer on large systems.
- **SleepTime Parameter:** Adjust for more accurate timing anomaly detection.
- **Verbose Mode:** Use `-Verbose` for detailed log of every check.

## License
```
MIT License

Copyright (c) 2025 Miiraak

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
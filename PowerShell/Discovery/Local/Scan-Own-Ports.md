# Scan-Own-Ports.ps1

## Overview
**Scan-Own-Ports.ps1** is a PowerShell script for Windows 10/11 that performs a comprehensive scan for open ports on the local machine using Nmap. If Nmap is not present, it will automatically download and install it from a custom repository. Scan results are saved to a report folder on the desktop.

## Features
- **Local Port Scanning:** Scans a specified port range (default: 1–1024) on your own machine (`localhost`).
- **Aggressive Nmap Scan:** Uses Nmap's aggressive scan flags for deep service and OS detection.
- **Automatic Nmap Setup:** Downloads and extracts Nmap from a custom repository if not already present.
- **Report Generation:** Stores scan results in XML, Nmap, and GNmap formats in a timestamped folder on your desktop.
- **Input Validation:** Checks for valid port ranges before running the scan.

## Requirements
- **Windows 10/11**
- **PowerShell 5.1+**
- **Internet connection** (for Nmap download if not present)
- **Permissions to create folders and files on the desktop**

## Parameters
| Name      | Type | Default | Description                          |
|-----------|------|---------|--------------------------------------|
| StartPort | int  | 1       | First port in the scan range         |
| EndPort   | int  | 1024    | Last port in the scan range          |

## Usage
### Basic Example
```powershell
.\Scan-Own-Ports.ps1
```

### Custom Port Range
```powershell
.\Scan-Own-Ports.ps1 -StartPort 80 -EndPort 443
```

## Script Workflow
1. **Validate Input:** Checks port range values.
2. **Ensure Nmap:** Downloads and extracts Nmap if not found in the script's `nmap` subfolder.
3. **Prepare Report Directory:** Creates a timestamped folder on the desktop for scan results.
4. **Run Scan:** Executes Nmap with aggressive options and outputs results in XML, Nmap, and GNmap formats.
5. **Success/Error Reporting:** Displays the location of the scan report or an error message if the scan fails.

## Output
- **Scan Reports:** XML, Nmap, and GNmap files in a folder named `NmapReports\<timestamp>` on your desktop.

## Help & Documentation
You can get help directly in PowerShell using:

```powershell
Get-Help .\Scan-Own-Ports.ps1
```

or

```powershell
man .\Scan-Own-Ports.ps1
```

## Troubleshooting
- Ensure you have an internet connection for the first run (for Nmap download).
- If you see `[ERROR] Invalid port range specified.`, double-check your `StartPort` and `EndPort`.
- Run as administrator if you encounter permission issues.

## License
```
MIT License

Copyright (c) 2025 Miiraak

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
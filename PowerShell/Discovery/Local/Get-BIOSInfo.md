# Get-BIOSProfile.ps1

## Overview
**Get-BIOSProfile.ps1** is a PowerShell script for Windows 10/11 that collects and displays a comprehensive BIOS and firmware profile, including detailed information about the motherboard, system, UEFI/Secure Boot, TPM, BitLocker status, SMBIOS, enclosure, CPU, and OS. It can export the entire profile as a JSON file for auditing and inventory purposes.

## Features
- **Detailed BIOS/Firmware Audit:** Gathers BIOS, motherboard, enclosure, CPU, and OS information.
- **UEFI/Secure Boot Detection:** Checks boot mode and Secure Boot status.
- **TPM & BitLocker Audit:** Reports TPM presence, version, and BitLocker status.
- **SMBIOS & Language Info:** Shows SMBIOS capabilities and supported languages.
- **Summary Section:** Outputs a concise object with key information.
- **JSON Export:** Optionally exports all collected data as a structured JSON file.

## Requirements
- **Windows 10/11**
- **PowerShell 5.1+**
- **Administrator privileges** may be needed for some hardware queries.

## Parameters
| Name       | Type   | Mandatory | Description                                              |
|------------|--------|-----------|----------------------------------------------------------|
| ExportJson | switch | No        | If set, exports the full profile as JSON.                |
| JsonPath   | string | No        | Path for JSON export file (default: BIOSProfile_*.json). |

## Usage

### Basic Example
```powershell
.\Get-BIOSProfile.ps1
```

### Export to JSON
```powershell
.\Get-BIOSProfile.ps1 -ExportJson
```

### Custom JSON Path
```powershell
.\Get-BIOSProfile.ps1 -ExportJson -JsonPath "C:\Audit\MyBIOSProfile.json"
```

## Script Workflow
1. **Sectioned Output:** Prints information in colored sections for easy reading.
2. **WMI Queries:** Collects hardware info using WMI classes (Win32_BIOS, Win32_BaseBoard, etc.).
3. **UEFI/Secure Boot/TPM/BitLocker:** Checks security features and boot mode.
4. **Summary Object:** Displays key data for quick reference.
5. **Optional JSON Export:** Writes the full profile to a JSON file if requested.

## Output
- **Console:** Displays all hardware and firmware details in sections.
- **JSON File:** If `-ExportJson` is used, writes all collected data to file.

## Help & Documentation
Get help in PowerShell:

```powershell
Get-Help .\Get-BIOSProfile.ps1
```

or

```powershell
man .\Get-BIOSProfile.ps1
```

## Troubleshooting
- Run PowerShell as administrator for full access.
- Some items (TPM, BitLocker) may not be present on all systems.
- If export fails, check file path and permissions.

## License
```
MIT License

Copyright (c) 2025 Miiraak

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
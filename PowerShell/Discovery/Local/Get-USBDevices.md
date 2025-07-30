# Get-USBDevices.ps1

## Overview
**Get-USBDevices.ps1** is a PowerShell script for Windows 10/11 that lists all currently connected USB storage devices. It uses WMI to query disk drives attached via the USB interface and displays key information about each device.

## Features
- **USB Storage Detection:** Filters and lists only USB-attached disk drives.
- **Device Details:** Shows model, device ID, interface type, and size.
- **No Dependencies:** Uses built-in PowerShell and WMI.

## Requirements
- **Windows 10/11**
- **PowerShell 5.1+**

## Usage
```powershell
.\Get-USBDevices.ps1
```

## Script Workflow
1. Queries `Win32_DiskDrive` via WMI.
2. Filters for drives where `InterfaceType` is `USB`.
3. Selects and displays Model, DeviceID, InterfaceType, and Size.

## Output Example
| Model           | DeviceID            | InterfaceType | Size       |
|-----------------|--------------------|--------------|------------|
| SanDisk Ultra   | \\.\PHYSICALDRIVE2 | USB          | 1565568000 |
| Kingston Data   | \\.\PHYSICALDRIVE3 | USB          | 3121136000 |

## Help & Documentation
```powershell
Get-Help .\Get-USBDevices.ps1
man .\Get-USBDevices.ps1
```

## Troubleshooting
- If no devices are listed, ensure a USB storage device is connected.
- Some devices may require administrator privileges to be detected.

## License
```
MIT License

Copyright (c) 2025 Miiraak

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
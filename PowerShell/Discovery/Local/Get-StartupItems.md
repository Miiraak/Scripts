# Get-StartupItems.ps1

## Overview
**Get-StartupItems.ps1** is a PowerShell script for Windows 10/11 that enumerates startup programs and scripts configured to run automatically when a user logs in. It gathers information from both common registry locations and the Startup folder, providing a consolidated list of all startup items.

## Features
- **Multiple Sources:** Checks user and system registry keys as well as the Startup folder.
- **Comprehensive Listing:** Displays the location, name, and launch command/value of each startup item.
- **Color-Coded Output:** Highlights sections and results for readability.
- **Sorted Table:** Results are sorted by location and name for clarity.

## Requirements
- **Windows 10/11**
- **PowerShell 5.1+**

## Usage
```powershell
.\Get-StartupItems.ps1
```

## Script Workflow
1. Checks three locations for startup items:
    - User Startup Folder: `%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup`
    - Registry (Current User): `HKCU:\Software\Microsoft\Windows\CurrentVersion\Run`
    - Registry (Local Machine): `HKLM:\Software\Microsoft\Windows\CurrentVersion\Run`
2. For each location:
    - Displays the current location in the console.
    - If found, lists all startup entries except PowerShell metadata properties.
    - Adds each entry to a results array with location, name, and value.
3. At the end, displays a sorted table of all startup items found.

## Output Example
| Location                                                         | Name       | Value                    |
|------------------------------------------------------------------|------------|--------------------------|
| HKCU:\Software\Microsoft\Windows\CurrentVersion\Run              | OneDrive   | C:\...\OneDrive.exe      |
| HKLM:\Software\Microsoft\Windows\CurrentVersion\Run              | Security   | C:\...\Security.exe      |
| %APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup          | updater.lnk| C:\...\updater.lnk       |

## Help & Documentation
```powershell
Get-Help .\Get-StartupItems.ps1
man .\Get-StartupItems.ps1
```

## Troubleshooting
- If no startup items are found, check that you have access to these locations.
- Not all startup items may be listed if they are stored in other registry or group policy locations.

## License
```
MIT License

Copyright (c) 2025 Miiraak

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
# Get-InstalledPrograms.ps1

## Overview
**Get-InstalledPrograms.ps1** is a PowerShell script for Windows 10/11 that lists all installed programs by reading from the registry. It collects program names, versions, and publishers from both 32-bit and 64-bit registry locations, sorts them alphabetically, removes duplicates, and displays the results in tabular format.

## Features
- **Comprehensive Listing:** Retrieves installed applications from both 32-bit and 64-bit registry paths.
- **Key Details:** Displays program name, version, and publisher.
- **Sorted & Unique:** Outputs a sorted, deduplicated list for easy readability.
- **No Dependencies:** Works out of the box with PowerShell.

## Requirements
- **Windows 10/11**
- **PowerShell 5.1+**

## Usage
```powershell
.\Get-InstalledPrograms.ps1
```

## Script Workflow
1. **Registry Query:** Reads installed program entries from registry locations:
    - `HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*`
    - `HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*`
2. **Filtering & Selection:** Keeps only entries with a display name, selecting name, version, and publisher.
3. **Sorting & Deduplication:** Sorts results alphabetically by program name and removes duplicates.
4. **Display:** Outputs results in a formatted table.

## Output Example
| DisplayName            | DisplayVersion | Publisher      |
|------------------------|----------------|---------------|
| 7-Zip                  | 21.07          | Igor Pavlov   |
| Google Chrome          | 112.0.5615.49  | Google LLC    |
| Microsoft Edge         | 114.0.1823.51  | Microsoft     |

## Help & Documentation
```powershell
Get-Help .\Get-InstalledPrograms.ps1
man .\Get-InstalledPrograms.ps1
```

## Troubleshooting
- If you receive no output, ensure you run PowerShell with sufficient rights.
- Programs installed per-user may not appear unless you also check `HKCU` registry paths.

## License
```
MIT License

Copyright (c) 2025 Miiraak

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
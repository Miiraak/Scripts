# Get-BatteryStatus.ps1

## Overview
**Get-BatteryStatus.ps1** is a PowerShell script for Windows 10/11 that displays your laptop's battery percentage and charging status. The script uses the .NET `System.Windows.Forms` library to access battery information and provides a color-coded status output for quick visual feedback.

## Features
- **Battery Detection:** Checks if a battery is present on the system.
- **Battery Percentage:** Displays the current battery level as a percentage.
- **Charging Status:** Shows whether the device is plugged in or running on battery.
- **Color-Coded Output:** Uses different colors for different battery levels:
  - **Green:** 80% and above
  - **Blue:** 50% to 79%
  - **Yellow:** 20% to 49%
  - **Red:** Below 20% or if no battery detected

## Parameters
This script does **not** take any parameters.

## Usage
```powershell
.\Get-BatteryStatus.ps1
```

## Output Example
```
Battery Percentage: 95% (Online)
Battery Percentage: 67% (Offline)
Battery Percentage: 24% (Offline)
Battery Percentage: 8% (Offline)
No battery detected.
```

## Help & Documentation
```powershell
Get-Help .\Get-BatteryStatus.ps1
man .\Get-BatteryStatus.ps1
```

## Troubleshooting
- **No Battery Detected:** If you run the script on a desktop or a device without a battery, you'll see "No battery detected."
- **Requires Windows:** The script only works on Windows 10/11 and requires PowerShell 5+.
- **Color Output:** Colors are visible only in terminals that support colored output.

## License
```
MIT License

Copyright (c) 2025 Miiraak

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
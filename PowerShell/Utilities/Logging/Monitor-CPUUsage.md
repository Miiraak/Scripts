# Monitor-CPUUsage.ps1

## Overview
**Monitor-CPUUsage.ps1** is a PowerShell script for Windows 10/11 that monitors system CPU usage in real time. The script displays the current CPU usage percentage in the console, updating every second. It uses the most accurate method available (`Get-Counter`), and automatically falls back to WMI (`Win32_Processor`) if needed. The script requires administrator privileges and stops when any key is pressed.

## Features
- **Real-Time Monitoring:** Displays live CPU usage with a timestamp, updating every second.
- **Automatic Fallback:** Uses `Get-Counter` for accuracy, but falls back to WMI if unavailable.
- **Color Output:** Different colors for normal and fallback modes.
- **Admin Check:** Ensures the script is run with administrator rights.
- **Graceful Stop:** Press any key to stop monitoring.
- **Robust Error Handling:** Notifies if a method fails and automatically switches to backup.

## Parameters
This script does **not** accept any parameters.

## Usage
```powershell
.\Monitor-CPUUsage.ps1
```

## Output Example
```
Monitoring CPU usage... Press any key to stop.

12:31:05 - CPU Usage: 17.2%
12:31:06 - CPU Usage: 19.0%
12:31:07 - CPU Usage: 20.1%
...
Monitoring stopped.
```

## Help & Documentation
```powershell
Get-Help .\Monitor-CPUUsage.ps1
man .\Monitor-CPUUsage.ps1
```

## Troubleshooting
- **Run as Administrator:** The script must be run with administrator rights for `Get-Counter` to work correctly.
- **Fallback to WMI:** If `Get-Counter` fails, the script automatically switches to WMI for CPU load.
- **Windows Only:** Works on Windows 10/11 with PowerShell 5+.
- **Key Press Detection:** Monitoring stops when any key is pressed in the console.

## License
```
MIT License

Copyright (c) 2025 Miiraak

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
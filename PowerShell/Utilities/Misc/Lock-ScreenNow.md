# Lock-ScreenNow.ps1

## Overview
**Lock-ScreenNow.ps1** is a PowerShell script for Windows 10/11 that instantly locks the user's workstation. This provides a quick way to secure your session and prevent unauthorized access.

## Features
- **Instant Lock:** Immediately locks the current user's session.
- **No Parameters Needed:** Run directly without any arguments.
- **Minimal and Fast:** Executes with a single command for maximum speed and simplicity.

## Requirements
- **Windows 10/11**
- **PowerShell 5.1+**
- **User permission** to run `rundll32.exe`

## Usage

### Basic Usage
```powershell
.\Lock-ScreenNow.ps1
```

## Script Workflow
1. **Lock Command:** Calls `rundll32.exe user32.dll,LockWorkStation` to instantly lock the screen.

## Help & Documentation
You can get help directly in PowerShell using:

```powershell
Get-Help .\Lock-ScreenNow.ps1
```

or
```powershell
man .\Lock-ScreenNow.ps1
```

## Troubleshooting
- If nothing happens when running the script, ensure you have permission to execute `rundll32.exe`.
- The script must be run on a Windows system that supports `LockWorkStation`.

## License
```
MIT License

Copyright (c) 2025 Miiraak

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

```

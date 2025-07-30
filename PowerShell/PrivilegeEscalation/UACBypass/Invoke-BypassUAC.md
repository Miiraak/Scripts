# Invoke-BypassUAC.ps1

## Overview
**Invoke-BypassUAC.ps1** is a PowerShell script for Windows 10/11 designed to bypass User Account Control (UAC) via an `eventvwr.exe` registry hijack. It robustly logs all actions, allows cleanup/removal of traces, and provides a simple switch to erase all evidence of its execution.

## Features
- **UAC Bypass:** Attempts privilege escalation without prompting for UAC using a registry hijack for `eventvwr.exe`.
- **Logging:** All actions are logged to a timestamped file in `%APPDATA%\UACBypassLogs`.
- **Full Cleanup:** Remove both registry changes and log files using the `-FullClean` switch.
- **Automatic Trace Removal:** Registry and log files are always cleaned after operation.
- **Safety Checks:** Script will not run bypass if already elevated (admin).
- **Colored Output:** Clear, color-coded messages for progress and errors.

## Requirements
- Windows 10/11
- PowerShell 5+
- Non-elevated (standard user) context for the bypass to be useful
- Administrator rights needed only for cleanup (not for bypass attempt)

## Usage

### Run UAC Bypass
```powershell
.\Invoke-BypassUAC.ps1
```

- Attempts to escalate privileges by hijacking the registry key used by `eventvwr.exe`.
- Produces a log file in your `%APPDATA%\UACBypassLogs` folder.
- Cleans up registry traces after execution.

### Full Cleanup
```powershell
.\Invoke-BypassUAC.ps1 -FullClean
```

- Removes all registry modifications and deletes log files/folders related to the script.

## Parameters
| Name      | Type   | Description                                                    |
|-----------|--------|----------------------------------------------------------------|
| FullClean | switch | If set, removes all registry traces and log files, then exits. |

## Output Example
```
[INFO] Attempting UAC bypass (eventvwr hijack)
[SUCCESS] Payload injected: powershell.exe ...
[STEP] Launching eventvwr.exe ...
[INFO] eventvwr.exe launched.
[FINAL] UAC bypass finished. Check for an elevated PowerShell console.
```

## Help & Documentation
```powershell
Get-Help .\Invoke-BypassUAC.ps1
man .\Invoke-BypassUAC.ps1
```

## Troubleshooting
- If you are already running as administrator, the bypass is unnecessary and will not proceed.
- Always use `-FullClean` to remove all traces after testing.
- If an error occurs, see the log file in `%APPDATA%\UACBypassLogs`.

## License
```
MIT License

Copyright (c) 2025 Miiraak

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
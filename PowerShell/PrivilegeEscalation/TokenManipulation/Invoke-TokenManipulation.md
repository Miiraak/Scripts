# Invoke-TokenManipulation.ps1

## Overview
**Invoke-TokenManipulation.ps1** is a PowerShell script for advanced privilege escalation and persistence on Windows. It supports multiple strategies for token manipulation, advanced UAC bypass techniques, persistent access, deep environment scanning, and complete trace cleanup for stealth operations.

## Features
- **Token Manipulation:** Uses Windows API to duplicate process tokens and start elevated processes.
- **Multi-Strategy UAC Bypass:** Scheduled tasks (SYSTEM), SilentCleanup registry hijack, ShellExecute 'runas', and Start-Process -Verb RunAs.
- **Persistence:** Adds itself to registry startup and schedules a persistent task.
- **Deep Scan:** Gathers comprehensive system, user, and environment information for pentest reporting.
- **Cleanup:** Removes registry entries, scheduled tasks, log files, artifacts, and PowerShell/Windows events.
- **Verbose Logging:** Color-coded, timestamped output for every step.
- **Windows-only:** Detects platform compatibility and PowerShell version.

## Requirements
- Windows 10/11 (PowerShell 5+)
- Administrator rights for full effect

## Parameters
| Name         | Type    | Default            | Description                                                      |
|--------------|---------|--------------------|------------------------------------------------------------------|
| AppToRun     | string  | "powershell.exe"   | Application to launch with elevated privileges                   |
| AppArgs      | string  | ""                 | Arguments for the application                                    |
| Verbose      | switch  | Off                | Enables verbose logging                                          |
| Cleanup      | switch  | Off                | Removes all traces and exits                                     |
| Persistence  | switch  | Off                | Enables registry/task persistence                                |
| DeepScan     | switch  | Off                | Performs a deep scan of environment, tokens, tasks, artifacts    |

## Usage

### Launch an elevated application
```powershell
.\Invoke-TokenManipulation.ps1 -AppToRun "cmd.exe" -AppArgs "/c whoami" -Verbose
```

### Persist the script for startup/task
```powershell
.\Invoke-TokenManipulation.ps1 -Persistence
```

### Deep environment and token scan
```powershell
.\Invoke-TokenManipulation.ps1 -DeepScan
```

### Cleanup all traces
```powershell
.\Invoke-TokenManipulation.ps1 -Cleanup
```

## Output Example
```
[STEP] 2025-07-29 18:34:00 :: Current User: Miiraak
[SUCCESS] 2025-07-29 18:34:01 :: Elevated process started successfully.
[WARN] 2025-07-29 18:34:02 :: Scheduled task creation failed: <details>
[ERROR] 2025-07-29 18:34:03 :: No bypass succeeded. Please run as administrator for full effect.
```

## Help & Documentation
```powershell
Get-Help .\Invoke-TokenManipulation.ps1
man .\Invoke-TokenManipulation.ps1
```

## Troubleshooting
- **Run as Administrator:** For best results and full bypass, run as administrator.
- **Persistence:** Registry and scheduled task persistence will require proper permissions.
- **Cleanup:** Use `-Cleanup` to remove all known traces and artifacts.
- **Windows-Only:** The script will exit if run on non-Windows platforms.

## License
```
MIT License

Copyright (c) 2025 Miiraak

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
# Logoff-IdleSessions.ps1

## Overview
**Logoff-IdleSessions.ps1** is a PowerShell script for Windows 10/11 and Windows Server that logs off all idle or disconnected user sessions (RDP or console) based on customizable criteria. It uses the `quser` command to enumerate sessions and performs logoff actions, with options for filtering, dry run, and exporting results.

## Features
- **Session State Filtering:** Filter sessions by state (e.g., Disc, Idle, Disconnected).
- **Idle Time Threshold:** Specify a minimum idle time (in minutes) for targeted logoff.
- **Export Support:** Export selected sessions to CSV or JSON files.
- **Dry Run Mode:** Simulate logoff actions without executing them.
- **Admin Check:** Requires administrator rights to perform logoff operations.
- **Progress and Reporting:** Displays session details and logoff results in the console.

## Requirements
- **Windows 10/11 or Windows Server**
- **PowerShell 5.1+**
- **Administrator privileges**
- **quser and logoff commands available**

## Parameters
| Name         | Type     | Default                                   | Description                                                  |
|--------------|----------|-------------------------------------------|--------------------------------------------------------------|
| StateFilter  | string[] | `@("Disc", "Idle", "Disconnected")`       | States to filter for session logoff.                         |
| IdleMinutesMin| int     | 0                                         | Minimum idle time in minutes for logoff.                     |
| ExportCsv    | switch   | Off                                       | Export filtered sessions to CSV.                             |
| CsvPath      | string   | `IdleSessions_yyyyMMdd_HHmmss.csv`        | Path for CSV export.                                         |
| ExportJson   | switch   | Off                                       | Export filtered sessions to JSON.                            |
| JsonPath     | string   | `IdleSessions_yyyyMMdd_HHmmss.json`       | Path for JSON export.                                        |
| DryRun       | switch   | Off                                       | Show logoff actions without performing them.                 |

## Usage

### Basic Example
```powershell
.\Logoff-IdleSessions.ps1
```

### Filter by Idle Minutes
```powershell
.\Logoff-IdleSessions.ps1 -IdleMinutesMin 30
```

### Export to CSV
```powershell
.\Logoff-IdleSessions.ps1 -ExportCsv
```

### Dry Run Simulation
```powershell
.\Logoff-IdleSessions.ps1 -DryRun
```

## Script Workflow
1. **Admin Check:** Ensures the script is run with administrator rights.
2. **Session Enumeration:** Uses `quser` to get all user sessions.
3. **Filtering:** Filters sessions by state and idle time.
4. **Session Reporting:** Displays sessions to be logged off.
5. **Export (Optional):** Exports filtered session data to CSV/JSON if requested.
6. **Logoff (or Dry Run):** Logs off matching sessions or simulates actions.
7. **Summary:** Reports the total number of sessions logged off.

## Help & Documentation
You can get help directly in PowerShell using:

```powershell
Get-Help .\Logoff-IdleSessions.ps1
```

or

```powershell
man .\Logoff-IdleSessions.ps1
```

## Troubleshooting
- Run as administrator to avoid permission errors.
- If `quser` or `logoff` are not recognized, check your system PATH or run in a Windows environment.
- Use `-DryRun` to preview actions before actual logoff.

## License
```
MIT License

Copyright (c) 2025 Miiraak

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
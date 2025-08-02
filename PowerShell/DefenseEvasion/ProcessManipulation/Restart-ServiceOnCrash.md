# Restart-ServiceOnCrash.ps1

## Overview
**Restart-ServiceOnCrash.ps1** is a PowerShell script for Windows 10/11/Server that continuously monitors a specified critical service. If the service stops or crashes, the script attempts to restart it up to a configurable maximum number of times, logging every attempt and optionally exporting logs in CSV or JSON format. It is ideal for ensuring uptime of important services.

## Features
- **Service Monitoring:** Watches a specified service and detects when it is stopped or not found.
- **Automatic Recovery:** Attempts to restart the service up to a configurable number of times (`MaxAttempts`).
- **Logging:** Logs each stop and restart attempt with timestamps, status, and result.
- **Export:** Optionally exports log data to CSV and/or JSON.
- **Configurable:** Choose monitoring interval, max restart attempts, and log export formats.
- **User Feedback:** Color-coded, clear messages and summary at session end.

## Parameters
| Name           | Type    | Required | Default                                             | Description                           |
|----------------|---------|----------|-----------------------------------------------------|---------------------------------------|
| Service        | string  | Yes      | -                                                   | Service name to monitor (short name)  |
| IntervalSeconds| int     | No       | 30                                                  | Monitoring interval (seconds)         |
| MaxAttempts    | int     | No       | 3                                                   | Maximum restart attempts per failure  |
| ExportLogCsv   | switch  | No       | Off                                                 | Export log as CSV                     |
| CsvPath        | string  | No       | ServiceRestartLog_${Service}_<timestamp>.csv        | Path for CSV export                   |
| ExportLogJson  | switch  | No       | Off                                                 | Export log as JSON                    |
| JsonPath       | string  | No       | ServiceRestartLog_${Service}_<timestamp>.json       | Path for JSON export                  |

## Usage
**Monitor and auto-restart a service:**
```powershell
.\Restart-ServiceOnCrash.ps1 -Service "Spooler"
```

**Export logs to CSV and JSON:**
```powershell
.\Restart-ServiceOnCrash.ps1 -Service "wuauserv" -ExportLogCsv -ExportLogJson
```

**Set custom interval and max attempts:**
```powershell
.\Restart-ServiceOnCrash.ps1 -Service "WinRM" -IntervalSeconds 60 -MaxAttempts 5
```

## Output Example
```
Surveillance du service critique : Spooler
==========================================
Démarrage de la surveillance. (Ctrl+C pour arrêter)
2025-07-29 19:27:34 | Attention : Le service 'Spooler' n'est pas démarré (état = Stopped).
2025-07-29 19:27:34 | Redémarrage du service 'Spooler' réussi (tentative 1).
Résumé : Service stoppé 2 fois, redémarré 2 fois.
[FIN] Surveillance terminée.
```

## Help & Documentation
```powershell
Get-Help .\Restart-ServiceOnCrash.ps1
man .\Restart-ServiceOnCrash.ps1
```

## Troubleshooting

- **Correct Service Name:** Use the short name as shown in `services.msc` (e.g., `Spooler` for the Print Spooler).
- **Permissions:** Some services require Administrator rights to restart.
- **Export Paths:** By default, logs are saved in the script directory with timestamps.
- **Session End:** Logs are exported when script exits (e.g., Ctrl+C).

## License
```
MIT License

Copyright (c) 2025 Miiraak

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
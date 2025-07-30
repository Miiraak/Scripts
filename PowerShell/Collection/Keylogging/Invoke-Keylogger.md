# Invoke-Keylogger.ps1

## Overview

**Invoke-Keylogger.ps1** is an advanced PowerShell keylogger script for Windows 10/11. It records keystrokes to a log file, supports stealth mode, log rotation, error handling, and allows you to stop the keylogger with a configurable hotkey. A confirmation popup appears when the hotkey is pressed, letting you confirm or cancel stopping the keylogger.

## Features

- **Keylogging:** Captures all keyboard input and writes it to a log file.
- **Stealth Mode:** Optionally hides the console window for stealth operation.
- **Log Rotation:** Automatically rotates the log file when it exceeds a specified size.
- **Flush Interval:** Periodically flushes the log to disk for reliability.
- **Hotkey Stop:** Use a configurable hotkey (default: Ctrl+Shift+Q) to stop the keylogger, with confirmation popup.
- **Error Handling:** Logs errors and kills the process after repeated failures.
- **User-Friendly Output:** Displays configuration and status information at startup.

## Parameters

| Name           | Type    | Default                              | Description                                               |
|----------------|---------|--------------------------------------|-----------------------------------------------------------|
| LogPath        | string  | `$env:APPDATA\keylogger.txt`         | Path to the log file                                      |
| MaxLogSizeKB   | int     | 1024                                 | Maximum log file size in KB before rotation               |
| FlushInterval  | int     | 100                                  | Number of keystrokes before flushing log to disk          |
| StealthMode    | switch  | Off                                  | Hide console window (stealth operation)                   |
| Hotkey         | string  | "Ctrl+Shift+Q"                       | Hotkey to stop keylogger (format: Modifier+Key, e.g., Ctrl+Shift+Q) |

## Usage

```powershell
.\Invoke-Keylogger.ps1
```

**Custom log path & hotkey:**
```powershell
.\Invoke-Keylogger.ps1 -LogPath "C:\log.txt" -Hotkey "Ctrl+Alt+Z" -StealthMode
```

## Output Example

```
[*] Log File      : C:\Users\user\AppData\Roaming\keylogger.txt
[*] Max Log Size  : 1024 KB
[*] Flush Interval: 100
[*] Hotkey        : Ctrl+Shift+Q
[*] Stealth Mode  : True
```

When the hotkey is pressed, a confirmation popup appears:
```
Do you want to stop the keylogger? [Yes/No]
```

## Help & Documentation

```powershell
Get-Help .\Invoke-Keylogger.ps1
man .\Invoke-Keylogger.ps1
```

## Troubleshooting

- **Admin Rights:** Not required, but the script must be run on Windows 10/11.
- **Hotkey Format:** Use the format "Ctrl+Shift+Q" (case-insensitive, key last).
- **Log Rotation:** If the log file exceeds MaxLogSizeKB, it is renamed with `.old` and a new log file is created.
- **Error Handling:** Errors are logged to a `.err` file; after 5 errors, the process is killed.

## License
```
MIT License

Copyright (c) 2025 Miiraak

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```

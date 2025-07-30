# Get-IPConfigSummary.ps1

## Overview
**Get-IPConfigSummary.ps1** is a PowerShell script for Windows 10/11 that provides a simplified summary of the current IPv4 address, gateway, and DNS settings for a chosen active network adapter. The script interactively lists all active adapters and prompts the user to select one, then displays its key networking details.

## Features
- **Lists Active Adapters:** Shows all network adapters that are currently up and available.
- **Interactive Selection:** Prompts the user to choose which adapter to inspect.
- **IP/Gateway/DNS Summary:** Displays the IPv4 address, default gateway, and DNS servers for the selected adapter.
- **Clear Console Output:** Uses color-coded messages for user guidance and error handling.

## Requirements
- **Windows 10/11**
- **PowerShell 5.1+**
- **Administrator rights** may be required for some network queries.

## Usage
Simply run the script:

```powershell
.\Get-IPConfigSummary.ps1
```

**Workflow:**
1. The script lists all active network adapters.
2. You enter the number of the adapter you want to inspect.
3. The script displays the IP address, gateway, and DNS servers of your selection.

## Output Example
```
Available Network Adapters:
[1] Ethernet - Up
[2] Wi-Fi - Up
Enter the number of the network adapter you want to inspect: 2

Selected adapter: Wi-Fi
IP Address  : 192.168.1.105
Gateway     : 192.168.1.1
DNS Servers : 8.8.8.8, 8.8.4.4
```

## Help & Documentation
You can get help directly in PowerShell using:

```powershell
Get-Help .\Get-IPConfigSummary.ps1
```

or

```powershell
man .\Get-IPConfigSummary.ps1
```

## Troubleshooting
- If you see "No active network adapters found", check your network connections.
- Make sure you enter a valid number when prompted.
- If any information is missing, ensure the network adapter is properly configured.

## License
```
MIT License

Copyright (c) 2025 Miiraak

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
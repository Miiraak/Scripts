# Export-WiFiPasswords.ps1

## Overview
**Export-WiFiPasswords.ps1** is a PowerShell script for Windows 10/11 that extracts all saved WiFi profiles and their associated passwords from the system. It requires administrator privileges to run and outputs the results in a readable file on the user's desktop.

## Features
- **Lists all saved WiFi profiles.**
- **Extracts and displays cleartext passwords for each profile.**
- **Writes results to a UTF-8 text file on the desktop.**
- **Handles profiles in any language (looks for password lines in multiple languages).**
- **Overwrites previous export file to keep results up-to-date.**

## Requirements
- Windows 10/11
- PowerShell 5+
- Administrator rights (to access WiFi password details)

## Usage
```powershell
.\Export-WiFiPasswords.ps1
```
> The script will create (or overwrite) `WiFiPasswords.txt` on your desktop, listing each WiFi profile and its password.

## Output Example
```
WiFi Passwords List
===================
Profile : HomeNetwork
Password: mySecretPassword123
----------------------------------------
Profile : OfficeWiFi
Password: office$ecure2025
----------------------------------------
```

## Help & Documentation
You can read the inline help by using:

```powershell
Get-Help .\Export-WiFiPasswords.ps1
man .\Export-WiFiPasswords.ps1
```

## Troubleshooting
- Run the script as administrator or it may not be able to read passwords.
- If you see "Not found" for a profile, it means there is no saved password for that network or you do not have permission.
- Results are overwritten each run.

## License
```
MIT License

Copyright (c) 2025 Miiraak

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
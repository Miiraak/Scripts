# user-credential.ps1

## Overview
**user-credential.ps1** is an advanced PowerShell script for Windows 10/11 (PowerShell 5+) designed for deep local user credential extraction, management, and audit. It supports info retrieval, password disabling, setting, checking, NTLM hash extraction (SYSTEM required), and automated Mimikatz SYSTEM dump for raw credential secrets. Output is color-coded and optionally logged.

## Features
- **User Info:** Detailed properties, admin status, groups, SID, and timestamps.
- **Advanced Extraction:** Automated Mimikatz SYSTEM dump for credentials, NTLM hash, DPAPI, vault, tickets, and secrets.
- **Password Management:** Disable (set to blank), set, or validate local account password.
- **Hash Extraction:** NTLM hash extraction (requires SYSTEM, e.g., via PsExec).
- **Logging & Silent Mode:** All actions logged to file; silent mode for automation.
- **Automatic Binaries Download:** Downloads mimikatz.exe and PsExec.exe from GitHub if missing.
- **Help & Usage Examples:** Built-in help with action descriptions and command samples.
- **Visual Feedback:** CapsLock LED flashes after execution.

## Requirements
- **Windows 10/11**
- **PowerShell 5.1+**
- **Local admin rights** (most actions), SYSTEM rights (for NTLM hash/Mimikatz dump)
- **Internet connection** (for downloading binaries if missing)

## Parameters
| Name         | Type    | Default                | Description                                              |
|--------------|---------|------------------------|----------------------------------------------------------|
| Action       | string  | "info"                 | info, disable, set, check, hash, help, show              |
| Username     | string  | $env:USERNAME          | Local user account name                                  |
| NewPassword  | string  | ""                     | New password for `set` action                            |
| TestPassword | string  | ""                     | Password to validate with `check` action                 |
| Silent       | switch  | Off                    | Only logs output, no screen messages                     |
| LogPath      | string  | %TEMP%\user-credential.log | Path for log file                                   |

## Usage

### Show user info
```powershell
.\user-credential.ps1 -Action info
```

### Extract advanced credentials (Mimikatz SYSTEM dump)
```powershell
.\user-credential.ps1 -Action show -Username Bob
```

### Disable password (set blank)
```powershell
.\user-credential.ps1 -Action disable -Username Bob
```

### Set password
```powershell
.\user-credential.ps1 -Action set -Username Bob -NewPassword "NouveauMDP2025"
```

### Check password validity
```powershell
.\user-credential.ps1 -Action check -Username Bob -TestPassword "EssaiMDP"
```

### Extract NTLM hash (SYSTEM rights required)
```powershell
.\user-credential.ps1 -Action hash -Username Bob
```

### Show help
```powershell
.\user-credential.ps1 -Action help
```

## Actions
- `info`: Safe display of all user properties, group membership, timestamps.
- `show`: Automated SYSTEM-level credential extraction with Mimikatz (full secrets dump).
- `disable`: Sets local password to blank.
- `set`: Sets local password to specified value.
- `check`: Tests a password for the given local account.
- `hash`: Attempts to extract NTLM hash (SYSTEM required).
- `help`: Displays usage information.

## Troubleshooting
- Run as **administrator** for most actions. For NTLM hash/Mimikatz dump, use SYSTEM (e.g., PsExec).
- If mimikatz.exe or PsExec.exe are missing, they are downloaded from the repo. Place manually if download fails.
- If antivirus blocks binaries, restore manually and whitelist if necessary.
- All output is logged to file (see `-LogPath`). Use `-Silent` for automation.

## License
```
MIT License

Copyright (c) 2025 Miiraak

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```

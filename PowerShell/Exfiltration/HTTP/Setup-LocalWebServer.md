# Setup-LocalWebServer.ps1

## Overview
**Setup-LocalWebServer.ps1** is a PowerShell script for Windows 10/11 that quickly starts a simple HTTP web server using Python, hosting files from a customizable template directory. It automatically downloads a website template if needed, personalizes it with domain and port, updates the Windows `hosts` file for local domain resolution, and can open the site in a browser. Server stop and cleanup is also included.

## Features
- **Custom Domain and TLD:** Serve content at `yourdomain.tld:port` using the local hosts file.
- **Automatic Template Download:** Fetches and extracts a website template if not present.
- **Template Personalization:** Replaces variables in HTML/CSS/JS files with your domain, TLD, and port.
- **Python HTTP Server:** Uses Python's built-in HTTP server to host files.
- **Hosts File Patching:** Adds/removes custom local domain to `hosts` file for easy access.
- **Browser Integration:** Optionally opens the site in your default browser.
- **Server Stop & Cleanup:** Stops the Python process and restores the hosts file when requested.

## Requirements
- **Windows 10/11**
- **PowerShell 5.1+**
- **Python (in PATH)**
- **Administrator privileges** (to modify hosts file)

## Parameters
| Name           | Type   | Mandatory | Description                                                |
|----------------|--------|-----------|------------------------------------------------------------|
| Domain         | string | Yes       | The domain for local serving (e.g., `mytestsite`)          |
| TLD            | string | Yes       | The top-level domain (e.g., `local`, `dev`)                |
| Port           | int    | No        | HTTP port (default: 8080)                                  |
| TemplateUrl    | string | No        | URL to download website template ZIP                       |
| TemplateFolder | string | No        | Local folder for template files (default: `template`)      |
| NoBrowser      | switch | No        | Prevents automatic browser launch                          |
| StopServer     | switch | No        | Stops server, restores hosts file, and exits               |

## Usage
### Start the Web Server
```powershell
.\Setup-LocalWebServer.ps1 -Domain "mytestsite" -TLD "local"
```

### Use a Custom Port and No Browser Launch
```powershell
.\Setup-LocalWebServer.ps1 -Domain "mytestsite" -TLD "dev" -Port 9090 -NoBrowser
```

### Stop the Server and Restore Hosts
```powershell
.\Setup-LocalWebServer.ps1 -StopServer -Domain "mytestsite" -TLD "local"
```

## Script Workflow
1. **Template Preparation:** Downloads/extracts template if needed, personalizes content.
2. **Hosts File Patch:** Adds domain to hosts for local resolution.
3. **Start Server:** Runs Python HTTP server in background.
4. **Browser Launch:** Opens site unless `-NoBrowser` specified.
5. **Stop Operation:** Kills server and restores hosts file when `-StopServer` used.
6. **Cleanup:** Removes temporary files after stopping the server.

## Output
- Website available at `http://yourdomain.tld:port/`
- Template files in local `template` folder
- Hosts file patched and restored as needed

## Help & Documentation
Get help in PowerShell:

```powershell
Get-Help .\Setup-LocalWebServer.ps1
```

or

```powershell
man .\Setup-LocalWebServer.ps1
```

## Troubleshooting
- Run PowerShell as Administrator to modify hosts file.
- Ensure Python is installed and in your system PATH.
- If the template fails to download, check the TemplateUrl or internet connection.
- Use `-StopServer` to clean up and avoid lingering hosts entries.

## License
MIT License
Copyright (c) 2025 Miiraak

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
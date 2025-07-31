########################################################################################
#                                                                                      |
#                 ███▄ ▄███▓ ██▓ ██▓ ██▀███   ▄▄▄      ▄▄▄       ██ ▄█▀                |
#                ▓██▒▀█▀ ██▒▓██▒▓██▒▓██ ▒ ██▒▒████▄   ▒████▄     ██▄█▒                 |
#                ▓██    ▓██░▒██▒▒██▒▓██ ░▄█ ▒▒██  ▀█▄ ▒██  ▀█▄  ▓███▄░                 |
#                ▒██    ▒██ ░██░░██░▒██▀▀█▄  ░██▄▄▄▄██░██▄▄▄▄██ ▓██ █▄                 |
#                ▒██▒   ░██▒░██░░██░░██▓ ▒██▒ ▓█   ▓██▒▓█   ▓██▒▒██▒ █▄                |
#                ░ ▒░   ░  ░░▓  ░▓  ░ ▒▓ ░▒▓░ ▒▒   ▓▒█░▒▒   ▓▒█░▒ ▒▒ ▓▒                |
#                ░  ░      ░ ▒ ░ ▒ ░  ░▒ ░ ▒░  ▒   ▒▒ ░ ▒   ▒▒ ░░ ░▒ ▒░                |
#                ░      ░    ▒ ░ ▒ ░  ░░   ░   ░   ▒    ░   ▒   ░ ░░ ░                 |
#                       ░    ░   ░     ░           ░  ░     ░  ░░  ░                   |
#                                                                                      |
#     Title        : Setup-LocalWebServer.ps1                                          |
#     Link         : https://github.com/Miiraak/Scripts/tree/master/Exfiltration/HTTP/ |
#     Version      : 2.5                                                               |
#     Category     : exfiltration/http                                                 |
#     Target       : Windows 10/11                                                     |
#     Description  : Starts a simple HTTP server serving files from a folder.          |
#                                                                                      |
########################################################################################

<#
.SYNOPSIS
    Starts a simple HTTP server serving files from a folder using Python. Auto-downloads template if missing.

.DESCRIPTION
    Sets up a local web server hosted at your chosen domain and TLD, using Python's http.server.
    Downloads and customizes a template if needed, patches hosts file for local domain, and can open browser automatically.
    Supports stopping the server and restoring hosts file.

.PARAMETER Domain
    Custom domain to serve locally (e.g. "mytestsite").

.PARAMETER TLD
    Top-level domain (e.g. "local", "dev").

.PARAMETER Port
    Port to host the HTTP server (default: 8080).

.PARAMETER TemplateUrl
    URL to download website template ZIP.

.PARAMETER TemplateFolder
    Local folder for template files (default: "html").

.PARAMETER NoBrowser
    Prevents automatic browser launch.

.PARAMETER StopServer
    Stops Python server and restores hosts file.

.EXAMPLE
    .\Setup-LocalWebServer.ps1 -Domain "mytestsite" -TLD "local" -Port 8080
#>

# ---------------[Parameters]--------------- #
param (
    [Parameter(Mandatory=$true)][string]$Domain,
    [Parameter(Mandatory=$true)][string]$TLD,
    [int]$Port = 8080,
    [string]$TemplateUrl = "https://github.com/Miiraak/Scripts/tree/master/Tools/html.zip",
    [string]$TemplateFolder = "html",
    [switch]$NoBrowser,
    [switch]$StopServer
)

# ---------------[Variables]--------------- #
$ScriptDir      = Split-Path -Parent $MyInvocation.MyCommand.Path
$TemplatePath   = Join-Path $ScriptDir $TemplateFolder
$ServerAddress  = "$Domain.$TLD"
$PythonExe      = "python"
$HostsPath      = "$env:SystemRoot\System32\drivers\etc\hosts"
$HostsEntry     = "127.0.0.1`t$ServerAddress"
$HostsBackup    = "$HostsPath.bak_psweb"

# ---------------[Functions]------------------ #
function Download-Template {
    Write-Host "Downloading template..."
    $ZipPath = Join-Path $ScriptDir "html.zip"
    Invoke-WebRequest -Uri $TemplateUrl -OutFile $ZipPath
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $ExtractTemp = Join-Path $ScriptDir "html_temp"
    if (Test-Path $ExtractTemp) { Remove-Item $ExtractTemp -Recurse -Force }
    [System.IO.Compression.ZipFile]::ExtractToDirectory($ZipPath, $ExtractTemp)
    # If zip contains a root folder, move its content
    $First = Get-ChildItem -Directory $ExtractTemp | Select-Object -First 1
    if ($First) {
        Move-Item -Path (Join-Path $First.FullName "*") -Destination $TemplatePath -Force
    } else {
        Move-Item -Path (Join-Path $ExtractTemp "*") -Destination $TemplatePath -Force
    }
    Remove-Item $ZipPath
    Remove-Item $ExtractTemp -Recurse -Force
}

function Replace-Variables-In-Files {
    Write-Host "Customizing template files..."
    Get-ChildItem -Path $TemplatePath -Recurse -Include *.html,*.css,*.js | ForEach-Object {
        (Get-Content $_.FullName) -replace "{{domain}}", $Domain -replace "{{tld}}", $TLD -replace "{{port}}", $Port | Set-Content $_.FullName
    }
}

function Patch-Hosts {
    if (-not (Select-String -Path $HostsPath -Pattern $ServerAddress -Quiet)) {
        Write-Host "Adding $ServerAddress to hosts file..."
        Copy-Item $HostsPath $HostsBackup -Force
        Add-Content -Path $HostsPath -Value $HostsEntry
    }
}

function Restore-Hosts {
    if (Test-Path $HostsBackup) {
        Write-Host "Restoring hosts file..."
        Copy-Item $HostsBackup $HostsPath -Force
        Remove-Item $HostsBackup
    } else {
        $Lines = Get-Content $HostsPath | Where-Object { $_ -notmatch $ServerAddress }
        Set-Content $HostsPath $Lines
    }
}

function Start-PythonServer {
    Write-Host "Starting web server on port $Port..."
    $Args = "-m http.server $Port --directory `"$TemplatePath`""
    Start-Process -FilePath $PythonExe -ArgumentList $Args -WindowStyle Hidden
    Start-Sleep -Seconds 2
    Write-Host "Server started at http://localhost:${Port}/"
}

function Open-Browser {
    $Url = "http://${ServerAddress}:${Port}/"
    Start-Process $Url
}

function Stop-PythonServer {
    Write-Host "Stopping Python web server and restoring hosts file..."
    Get-Process -Name python -ErrorAction SilentlyContinue | Stop-Process -Force
    Restore-Hosts
    Write-Host "Server stopped. Hosts file restored."
}

# ---------------[Execution]------------------ #
if ($StopServer) {
    Stop-PythonServer
    exit
}

if (-not (Test-Path $TemplatePath)) {
    Download-Template
} else {
    Write-Host "Template folder already exists, using existing files."
}
Replace-Variables-In-Files
Patch-Hosts
Start-PythonServer
if (-not $NoBrowser) { Open-Browser }

# ---------------[Output]------------------ #
Write-Host "Access your site at: http://${ServerAddress}:${Port}/"
Write-Host "To stop and restore hosts: .\Setup-LocalWebServer.ps1 -StopServer"
Write-Host "Web folder in use: $TemplatePath"
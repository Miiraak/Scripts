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
#     Link         : https://github.com/Miiraak/Scripts/tree/master/PowerShell/Exfiltration/HTTP/ |
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
    Local folder for template files (default: "template").

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
    [switch]$NoBrowser,
    [switch]$StopServer
)   

# ---------------[Variables]--------------- #
$ScriptDir      = Split-Path -Parent $MyInvocation.MyCommand.Path
$TemplatePath   = Join-Path $ScriptDir "html"
$ServerAddress  = "$Domain.$TLD"
$PythonExe      = "python"
$HostsPath      = "$env:SystemRoot\System32\drivers\etc\hosts"
$HostsEntry     = "127.0.0.1`t$ServerAddress"
$HostsBackup    = "$HostsPath.bak_psweb"

# ---------------[Functions]------------------ #
function DownloadTemplate {
    Write-Output "Downloading template..."
    $ZipPath = Join-Path $ScriptDir "html.zip"
    Invoke-WebRequest -Uri "https://github.com/Miiraak/Scripts/raw/master/Tools/html.zip" -OutFile $ZipPath
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $ExtractTemp = Join-Path $ScriptDir "html_temp"
    if (Test-Path $ExtractTemp) { Remove-Item $ExtractTemp -Recurse -Force }
    try {
        [System.IO.Compression.ZipFile]::ExtractToDirectory($ZipPath, $ExtractTemp)
    } catch {
        Write-Error "Extraction of the zip file failed. Please check that the downloaded file is a valid zip. File: $ZipPath"
        Remove-Item $ZipPath -Force
        return
    }

    $First = Get-ChildItem -Directory $ExtractTemp | Select-Object -First 1
    if ($First) {
        if (-not (Test-Path $TemplatePath)) { New-Item -ItemType Directory -Path $TemplatePath | Out-Null }
        Move-Item -Path (Join-Path $First.FullName "*") -Destination $TemplatePath -Force
    } else {
        if (-not (Test-Path $TemplatePath)) { New-Item -ItemType Directory -Path $TemplatePath | Out-Null }
        Move-Item -Path (Join-Path $ExtractTemp "*") -Destination $TemplatePath -Force
    }
    Remove-Item $ZipPath
    Remove-Item $ExtractTemp -Recurse -Force

    if (-not (Test-Path $TemplatePath)) {
        throw "Error: The template folder was not created after extraction."
    }
}

function ReplaceVariablesInFiles {
    Write-Output "Customizing template files..."
    if (-not (Test-Path $TemplatePath)) {
        Write-Error "Impossible to access files: the template folder does not exist or is corrupt."
        return
    }
    Get-ChildItem -Path $TemplatePath -Recurse -Include *.html,*.css,*.js | ForEach-Object {
        (Get-Content $_.FullName) -replace "{{domain}}", $Domain -replace "{{tld}}", $TLD -replace "{{port}}", $Port | Set-Content $_.FullName
    }
}

function PatchHosts {
    if (-not (Select-String -Path $HostsPath -Pattern $ServerAddress -Quiet)) {
        Write-Output "Adding $ServerAddress to hosts file..."
        Copy-Item $HostsPath $HostsBackup -Force
        Add-Content -Path $HostsPath -Value $HostsEntry
    }
}

function RestoreHosts {
    if (Test-Path $HostsBackup) {
        Write-Output "Restoring hosts file..."
        Copy-Item $HostsBackup $HostsPath -Force
        Remove-Item $HostsBackup
    } else {
        $Lines = Get-Content $HostsPath | Where-Object { $_ -notmatch $ServerAddress }
        Set-Content $HostsPath $Lines
    }
}

function StartPythonServer {
    Write-Output "Starting web server on port $Port..."
    if (-not (Test-Path $TemplatePath)) {
        Write-Error "The web folder ($TemplatePath) does not exist. Unable to start the server."
        return
    }
    $Args = "-m http.server $Port --directory `"$TemplatePath`""
    Start-Process -FilePath $PythonExe -ArgumentList $Args -WindowStyle Hidden
    Start-Sleep -Seconds 2
    Write-Output "Server started at http://localhost:${Port}/"
}

function OpenBrowser {
    $Url = "http://${ServerAddress}:${Port}/"
    Start-Process $Url
}

function StopPythonServer {
    Write-Output "Stopping Python web server and restoring hosts file..."
    Get-Process -Name python -ErrorAction SilentlyContinue | Stop-Process -Force
    RestoreHosts
    Write-Output "Server stopped. Hosts file restored."
    if (Test-Path $TemplatePath) {
        Write-Output "Removing template folder: $TemplatePath"
        RemoveItem $TemplatePath -Recurse -Force
    } else {
        Write-Output "Template folder does not exist, nothing to remove."
    }
}

# ---------------[Execution]------------------ #
if ($StopServer) {
    StopPythonServer
    exit
}

if ($TLD.StartsWith(".")) {
    $TLD = $TLD.Substring(1)
    $ServerAddress = "$Domain.$TLD"
}

if (-not (Test-Path $TemplatePath)) {
    DownloadTemplate
    if (-not (Test-Path $TemplatePath)) {
        Write-Error "The template could not be downloaded or extracted. Abandon."
        exit 1
    }
} else {
    Write-Output "Template folder already exists, using existing files."
}
ReplaceVariablesInFiles
PatchHosts
StartPythonServer
if (-not $NoBrowser) { OpenBrowser }

# ---------------[Output]------------------ #
Write-Output "Access your site at: http://${ServerAddress}:${Port}/"
Write-Output "To stop and restore hosts: .\Setup-LocalWebServer.ps1 -StopServer"
Write-Output "Web folder in use: $TemplatePath"

# ---------------[End of Script]------------------ #
exit 0
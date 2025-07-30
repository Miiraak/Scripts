######################################################################################################
#                                                                                                    |
#                 ███▄ ▄███▓ ██▓ ██▓ ██▀███   ▄▄▄      ▄▄▄       ██ ▄█▀                              |
#                ▓██▒▀█▀ ██▒▓██▒▓██▒▓██ ▒ ██▒▒████▄   ▒████▄     ██▄█▒                               |
#                ▓██    ▓██░▒██▒▒██▒▓██ ░▄█ ▒▒██  ▀█▄ ▒██  ▀█▄  ▓███▄░                               |
#                ▒██    ▒██ ░██░░██░▒██▀▀█▄  ░██▄▄▄▄██░██▄▄▄▄██ ▓██ █▄                               |
#                ▒██▒   ░██▒░██░░██░░██▓ ▒██▒ ▓█   ▓██▒▓█   ▓██▒▒██▒ █▄                              |
#                ░ ▒░   ░  ░░▓  ░▓  ░ ▒▓ ░▒▓░ ▒▒   ▓▒█░▒▒   ▓▒█░▒ ▒▒ ▓▒                              |
#                ░  ░      ░ ▒ ░ ▒ ░  ░▒ ░ ▒░  ▒   ▒▒ ░ ▒   ▒▒ ░░ ░▒ ▒░                              |
#                ░      ░    ▒ ░ ▒ ░  ░░   ░   ░   ▒    ░   ▒   ░ ░░ ░                               |
#                       ░    ░   ░     ░           ░  ░     ░  ░░  ░                                 |
#                                                                                                    |
#     Title        : Capture-Screen.ps1                                                              |
#     Link         : https://github.com/miiraak/Scripts/PowerShell/collection/screencapture/         |
#     Version      : 1.3                                                                             |
#     Category     : collection/screencapture                                                        |
#     Target       : Windows 10/11                                                                   |
#     Description  : Captures a screenshot and saves it as PNG.                                      |
#                                                                                                    |
######################################################################################################

<#
.SYNOPSIS
    Captures a screenshot of the primary screen and saves it as an image file.

.DESCRIPTION
    This script captures the content of the primary display and saves it as an image file (PNG, JPEG, or BMP)
    in the specified directory. You can set a countdown delay, output directory, filename, and image format.

.PARAMETER Delay
    Countdown in seconds before the screenshot is taken. Default is 2.

.PARAMETER OutputPath
    Directory where the screenshot will be saved. Default is the script directory.

.PARAMETER OutputFile
    Name of the output image file. Default is 'screenshot_<timestamp>'.

.PARAMETER ImageFormat
    Format of the output image file. Allowed values: PNG, JPEG, BMP. Default is PNG.

.EXAMPLE
    .\Capture-Screen.ps1 -Delay 5 -OutputPath "C:\Screenshots" -OutputFile "Capture1" -ImageFormat "JPEG"
#>

# ---------------[Parameters]--------------- #
param (
    [Parameter(Mandatory=$false, HelpMessage="Countdown in seconds before screenshot is taken.")]
    [int]$Delay = 2,

    [Parameter(Mandatory=$false, HelpMessage="Directory where the screenshot will be saved.")]
    [string]$OutputPath = "$PSScriptRoot",

    [Parameter(Mandatory=$false, HelpMessage="Name of the output image file.")]
    [string]$OutputFile = "screenshot_$(Get-Date -Format 'yyyyMMdd_HHmmss')",

    [Parameter(Mandatory=$false, HelpMessage="Image format: PNG, JPEG, or BMP.")]
    [ValidateSet("PNG", "JPEG", "BMP")]
    [string]$ImageFormat = "PNG"
)

$OutputFormat = "$OutputFile.$ImageFormat".ToLower()

# ---------------[Execution]--------------- #
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

for ($i = 0; $i -lt $Delay; $i++) {
    Write-Host "Taking screenshot in $($Delay - $i) seconds..."
    Start-Sleep -Seconds 1
}

$bmp = New-Object Drawing.Bitmap ([System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width,
                                  [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height)
$graphics = [Drawing.Graphics]::FromImage($bmp)
$graphics.CopyFromScreen(0, 0, 0, 0, $bmp.Size)
$bmp.Save("$OutputPath\$OutputFormat", [System.Drawing.Imaging.ImageFormat]::$ImageFormat)
Write-Host "Screenshot saved to $OutputPath\$OutputFormat"

# ---------------[End]--------------- #
$graphics.Dispose()
$bmp.Dispose()
exit 0
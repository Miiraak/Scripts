###################################################################################################
#                                                                                                 #
#                   ███▄ ▄███▓ ██▓ ██▓ ██▀███   ▄▄▄      ▄▄▄       ██ ▄█▀                         #
#                  ▓██▒▀█▀ ██▒▓██▒▓██▒▓██ ▒ ██▒▒████▄   ▒████▄     ██▄█▒                          #
#                  ▓██    ▓██░▒██▒▒██▒▓██ ░▄█ ▒▒██  ▀█▄ ▒██  ▀█▄  ▓███▄░                          #
#                  ▒██    ▒██ ░██░░██░▒██▀▀█▄  ░██▄▄▄▄██░██▄▄▄▄██ ▓██ █▄                          #
#                  ▒██▒   ░██▒░██░░██░░██▓ ▒██▒ ▓█   ▓██▒▓█   ▓██▒▒██▒ █▄                         #
#                  ░ ▒░   ░  ░░▓  ░▓  ░ ▒▓ ░▒▓░ ▒▒   ▓▒█░▒▒   ▓▒█░▒ ▒▒ ▓▒                         #
#                  ░  ░      ░ ▒ ░ ▒ ░  ░▒ ░ ▒░  ▒   ▒▒ ░ ▒   ▒▒ ░░ ░▒ ▒░                         #
#                  ░      ░    ▒ ░ ▒ ░  ░░   ░   ░   ▒    ░   ▒   ░ ░░ ░                          #
#                         ░    ░   ░     ░           ░  ░     ░  ░░  ░                            #
#                                                                                                 #
#     Title        : Get-BIOSProfile.ps1                                                          #
#     Link         : https://github.com/Miiraak/Scripts/tree/master/PowerShell/Discovery/Local/   #
#     Version      : 2.1                                                                          #
#     Category     : discovery/local                                                              #
#     Target       : Windows 10/11                                                                #
#     Description  : Full BIOS/Firmware profile + JSON export                                     #
#                                                                                                 #
###################################################################################################

<#
.SYNOPSIS
    Collects and displays a complete BIOS and firmware profile, with optional JSON export.

.DESCRIPTION
    Audits and displays BIOS, motherboard, enclosure, CPU, OS, UEFI/Secure Boot, TPM, BitLocker, SMBIOS, languages, and more.
    Optionally exports all collected data as a structured JSON file.

.PARAMETER ExportJson
    Export the full hardware/firmware profile as JSON.

.PARAMETER JsonPath
    Path for the exported JSON file.

.EXAMPLE
    .\Get-BIOSProfile.ps1
    .\Get-BIOSProfile.ps1 -ExportJson
    .\Get-BIOSProfile.ps1 -ExportJson -JsonPath "C:\Audit\MyBIOSProfile.json"
#>

# ---------------[Parameters]--------------- #
[CmdletBinding()]
param (
    [switch]$ExportJson,
    [string]$JsonPath = "$PSScriptRoot\BIOSProfile_$((Get-Date).ToString('yyyyMMdd_HHmmss')).json"
)

# ---------------[Functions]--------------- #
function Write-Section {
    param([string]$Title)
    Write-Host ""
    Write-Host $Title -ForegroundColor Cyan
    Write-Host ('=' * ($Title.Length)) -ForegroundColor Cyan
}

# ---------------[Execution]--------------- #
# -- BIOS --
Write-Section "BIOS (Win32_BIOS)"
$bios = Get-WmiObject -Class Win32_BIOS
$biosDetails = $bios | Select-Object *, @{Name="BIOSCharacteristicsDesc";Expression={($_.BIOSCharacteristics -join ', ')}}
$biosDetails | Format-List Manufacturer, Name, Version, SerialNumber, SMBIOSBIOSVersion, ReleaseDate, BIOSVersion, BIOSCharacteristicsDesc

# -- BaseBoard --
Write-Section "Carte Mère (Win32_BaseBoard)"
$board = Get-WmiObject -Class Win32_BaseBoard
$boardDetails = $board | Select-Object *
$boardDetails | Format-List Manufacturer, Product, Version, SerialNumber

# -- ComputerSystem --
Write-Section "Système (Win32_ComputerSystem)"
$sys = Get-WmiObject -Class Win32_ComputerSystem
$sysDetails = $sys | Select-Object *
$sysDetails | Format-List Model, Manufacturer, SystemType, NumberOfProcessors, TotalPhysicalMemory

# -- Firmware/UEFI/TPM/BitLocker --
Write-Section "Firmware/UEFI, Secure Boot, TPM, BitLocker"
# UEFI detection
$uefi = $false
try {
    $firm = $sys.BootupState
    if ($firm -match "EFI") { $uefi = $true }
} catch {}

Write-Host "Mode de démarrage (UEFI) : $uefi" -ForegroundColor Magenta

# Secure Boot
$secureBoot = $null
try { $secureBoot = Confirm-SecureBootUEFI } catch {}
Write-Host "Secure Boot activé : $secureBoot" -ForegroundColor Magenta

# TPM
$tpmDetails = $null
try { $tpmDetails = Get-WmiObject -Namespace "Root\CIMv2\Security\MicrosoftTpm" -Class Win32_Tpm } catch {}
if ($tpmDetails) {
    Write-Host "TPM Manufacturer: $($tpmDetails.ManufacturerID)" -ForegroundColor Yellow
    Write-Host "TPM Version: $($tpmDetails.SpecVersion)" -ForegroundColor Yellow
    Write-Host "TPM Enabled: $($tpmDetails.IsEnabled)" -ForegroundColor Yellow
} else {
    Write-Host "TPM: Not Found" -ForegroundColor Yellow
}

# BitLocker
$bitlockerDetails = $null
try { $bitlockerDetails = Get-BitLockerVolume } catch {}
if ($bitlockerDetails) {
    Write-Host "BitLocker Protection Status:" -ForegroundColor DarkYellow
    $bitlockerDetails | Select-Object MountPoint, ProtectionStatus, VolumeStatus | Format-Table
}

# -- SMBIOS & Langues --
Write-Section "SMBIOS Capabilities & Langues"
if ($bios) {
    Write-Host "SMBIOS Version: $($bios.SMBIOSBIOSVersion)" -ForegroundColor Green
    Write-Host "BIOS Characteristics: $($bios.BIOSCharacteristics -join ', ')" -ForegroundColor Green
    Write-Host "BIOS Languages: $($bios.BIOSLanguage)" -ForegroundColor Green
    Write-Host "BIOS ReleaseDate: $($bios.ReleaseDate)" -ForegroundColor Green
}

# -- Châssis --
Write-Section "Enclosure / Châssis"
$enclosureDetails = Get-WmiObject -Class Win32_SystemEnclosure | Select-Object *
$enclosureDetails | Format-List ChassisTypes, Manufacturer, SerialNumber

# -- CPU --
Write-Section "Processeur"
$cpuDetails = Get-WmiObject -Class Win32_Processor | Select-Object *
$cpuDetails | Format-List Name, Manufacturer, MaxClockSpeed, SocketDesignation

# -- OS --
Write-Section "OS Info"
$osDetails = Get-WmiObject -Class Win32_OperatingSystem | Select-Object *
$osDetails | Format-List Caption, Version, InstallDate, OSArchitecture

# -- Résumé condensé --
Write-Section "Résumé condensé"
$summary = [PSCustomObject]@{
    BIOS_Manufacturer = $bios.Manufacturer
    BIOS_Version = $bios.Version
    BIOS_ReleaseDate = $bios.ReleaseDate
    BIOS_SMBIOSVersion = $bios.SMBIOSBIOSVersion
    BIOS_Language = $bios.BIOSLanguage
    Board_Manufacturer = $board.Manufacturer
    Board_Product = $board.Product
    System_Model = $sys.Model
    Boot_UEFI = $uefi
    SecureBoot = $secureBoot
    TPM_Version = $tpmDetails.SpecVersion
    BitLocker_Status = $bitlockerDetails.ProtectionStatus
    OS = $osDetails.Caption
    OS_Arch = $osDetails.OSArchitecture
}
$summary | Format-List

# -- Export JSON complet --
if ($ExportJson) {
    $exportObject = [PSCustomObject]@{
        BIOS        = $biosDetails
        BaseBoard   = $boardDetails
        Computer    = $sysDetails
        UEFI        = $uefi
        SecureBoot  = $secureBoot
        TPM         = $tpmDetails
        BitLocker   = $bitlockerDetails
        SMBIOS      = @{
            Version         = $bios.SMBIOSBIOSVersion
            Characteristics = $bios.BIOSCharacteristics
            Languages       = $bios.BIOSLanguage
            ReleaseDate     = $bios.ReleaseDate
        }
        Enclosure   = $enclosureDetails
        CPU         = $cpuDetails
        OS          = $osDetails
        Summary     = $summary
    }
    $exportObject | ConvertTo-Json -Depth 4 | Set-Content -Path $JsonPath -Encoding UTF8
    Write-Host ""
    Write-Host "Export complet en JSON: $JsonPath" -ForegroundColor Cyan
}

Write-Host ""

# ---------------[End]--------------- #
Write-Host "[FIN] Profil BIOS & firmware complet." -ForegroundColor White -BackgroundColor DarkGreen
exit 0
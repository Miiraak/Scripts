# PowerShell Script Issues Report
_This file is generated automatically by Script Analysis workflow_


### Errors

| File | Line | Rule | Message |
| ---- | ---- | ---- | ------- |
| Check-InternetConnection.ps1 | 59 | PSAvoidUsingComputerNameHardcoded | The ComputerName parameter of cmdlet 'Test-Connection' is hardcoded. This will expose sensitive information about the... |
| User-Credential.ps1 | 339 | PSAvoidUsingConvertToSecureStringWithPlainText | File 'User-Credential.ps1' uses ConvertTo-SecureString with plaintext. This will expose secure information. Encrypted... |

### Warnings

| File | Line | Rule | Message |
| ---- | ---- | ---- | ------- |
| Capture-Screen.ps1 |  | PSUseBOMForUnicodeEncodedFile | Missing BOM encoding for non-ASCII encoded file 'Capture-Screen.ps1' |
| Capture-Screen.ps1 | 69 | PSAvoidUsingWriteHost | File 'Capture-Screen.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not wo... |
| Capture-Screen.ps1 | 78 | PSAvoidUsingWriteHost | File 'Capture-Screen.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not wo... |
| Check-InternetConnection.ps1 |  | PSUseBOMForUnicodeEncodedFile | Missing BOM encoding for non-ASCII encoded file 'Check-InternetConnection.ps1' |
| Check-InternetConnection.ps1 | 49 | PSAvoidUsingWriteHost | File 'Check-InternetConnection.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, d... |
| Check-InternetConnection.ps1 | 55 | PSAvoidUsingWriteHost | File 'Check-InternetConnection.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, d... |
| Check-InternetConnection.ps1 | 60 | PSAvoidUsingWriteHost | File 'Check-InternetConnection.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, d... |
| Check-InternetConnection.ps1 | 64 | PSAvoidUsingWriteHost | File 'Check-InternetConnection.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, d... |
| Export-WiFiPasswords.ps1 |  | PSUseBOMForUnicodeEncodedFile | Missing BOM encoding for non-ASCII encoded file 'Export-WiFiPasswords.ps1' |
| Export-WiFiPasswords.ps1 | 53 | PSAvoidUsingWriteHost | File 'Export-WiFiPasswords.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does ... |
| Export-WiFiPasswords.ps1 | 58 | PSAvoidAssignmentToAutomaticVariable | The Variable 'profile' is an automatic variable that is built into PowerShell, assigning to it might have undesired s... |
| Export-WiFiPasswords.ps1 | 82 | PSAvoidUsingWriteHost | File 'Export-WiFiPasswords.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does ... |
| Export-WiFiPasswords.ps1 | 87 | PSAvoidUsingWriteHost | File 'Export-WiFiPasswords.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does ... |
| Get-BatteryStatus.ps1 |  | PSUseBOMForUnicodeEncodedFile | Missing BOM encoding for non-ASCII encoded file 'Get-BatteryStatus.ps1' |
| Get-BatteryStatus.ps1 | 43 | PSAvoidUsingWriteHost | File 'Get-BatteryStatus.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not... |
| Get-BatteryStatus.ps1 | 51 | PSAvoidUsingWriteHost | File 'Get-BatteryStatus.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not... |
| Get-BatteryStatus.ps1 | 54 | PSAvoidUsingWriteHost | File 'Get-BatteryStatus.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not... |
| Get-BatteryStatus.ps1 | 57 | PSAvoidUsingWriteHost | File 'Get-BatteryStatus.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not... |
| Get-BatteryStatus.ps1 | 60 | PSAvoidUsingWriteHost | File 'Get-BatteryStatus.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not... |
| Get-BIOSInfo.ps1 |  | PSUseBOMForUnicodeEncodedFile | Missing BOM encoding for non-ASCII encoded file 'Get-BIOSInfo.ps1' |
| Get-BIOSInfo.ps1 | 52 | PSAvoidUsingWriteHost | File 'Get-BIOSInfo.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not work... |
| Get-BIOSInfo.ps1 | 53 | PSAvoidUsingWriteHost | File 'Get-BIOSInfo.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not work... |
| Get-BIOSInfo.ps1 | 54 | PSAvoidUsingWriteHost | File 'Get-BIOSInfo.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not work... |
| Get-BIOSInfo.ps1 | 60 | PSAvoidUsingWMICmdlet | File 'Get-BIOSInfo.ps1' uses WMI cmdlet. For PowerShell 3.0 and above, use CIM cmdlet which perform the same tasks as... |
| Get-BIOSInfo.ps1 | 66 | PSAvoidUsingWMICmdlet | File 'Get-BIOSInfo.ps1' uses WMI cmdlet. For PowerShell 3.0 and above, use CIM cmdlet which perform the same tasks as... |
| Get-BIOSInfo.ps1 | 72 | PSAvoidUsingWMICmdlet | File 'Get-BIOSInfo.ps1' uses WMI cmdlet. For PowerShell 3.0 and above, use CIM cmdlet which perform the same tasks as... |
| Get-BIOSInfo.ps1 | 83 | PSAvoidUsingEmptyCatchBlock | Empty catch block is used. Please use Write-Error or throw statements in catch blocks. |
| Get-BIOSInfo.ps1 | 85 | PSAvoidUsingWriteHost | File 'Get-BIOSInfo.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not work... |
| Get-BIOSInfo.ps1 | 89 | PSAvoidUsingEmptyCatchBlock | Empty catch block is used. Please use Write-Error or throw statements in catch blocks. |
| Get-BIOSInfo.ps1 | 90 | PSAvoidUsingWriteHost | File 'Get-BIOSInfo.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not work... |
| Get-BIOSInfo.ps1 | 94 | PSAvoidUsingWMICmdlet | File 'Get-BIOSInfo.ps1' uses WMI cmdlet. For PowerShell 3.0 and above, use CIM cmdlet which perform the same tasks as... |
| Get-BIOSInfo.ps1 | 94 | PSAvoidUsingEmptyCatchBlock | Empty catch block is used. Please use Write-Error or throw statements in catch blocks. |
| Get-BIOSInfo.ps1 | 96 | PSAvoidUsingWriteHost | File 'Get-BIOSInfo.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not work... |
| Get-BIOSInfo.ps1 | 97 | PSAvoidUsingWriteHost | File 'Get-BIOSInfo.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not work... |
| Get-BIOSInfo.ps1 | 98 | PSAvoidUsingWriteHost | File 'Get-BIOSInfo.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not work... |
| Get-BIOSInfo.ps1 | 100 | PSAvoidUsingWriteHost | File 'Get-BIOSInfo.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not work... |
| Get-BIOSInfo.ps1 | 105 | PSAvoidUsingEmptyCatchBlock | Empty catch block is used. Please use Write-Error or throw statements in catch blocks. |
| Get-BIOSInfo.ps1 | 107 | PSAvoidUsingWriteHost | File 'Get-BIOSInfo.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not work... |
| Get-BIOSInfo.ps1 | 114 | PSAvoidUsingWriteHost | File 'Get-BIOSInfo.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not work... |
| Get-BIOSInfo.ps1 | 115 | PSAvoidUsingWriteHost | File 'Get-BIOSInfo.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not work... |
| Get-BIOSInfo.ps1 | 116 | PSAvoidUsingWriteHost | File 'Get-BIOSInfo.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not work... |
| Get-BIOSInfo.ps1 | 117 | PSAvoidUsingWriteHost | File 'Get-BIOSInfo.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not work... |
| Get-BIOSInfo.ps1 | 122 | PSAvoidUsingWMICmdlet | File 'Get-BIOSInfo.ps1' uses WMI cmdlet. For PowerShell 3.0 and above, use CIM cmdlet which perform the same tasks as... |
| Get-BIOSInfo.ps1 | 127 | PSAvoidUsingWMICmdlet | File 'Get-BIOSInfo.ps1' uses WMI cmdlet. For PowerShell 3.0 and above, use CIM cmdlet which perform the same tasks as... |
| Get-BIOSInfo.ps1 | 132 | PSAvoidUsingWMICmdlet | File 'Get-BIOSInfo.ps1' uses WMI cmdlet. For PowerShell 3.0 and above, use CIM cmdlet which perform the same tasks as... |
| Get-BIOSInfo.ps1 | 177 | PSAvoidUsingWriteHost | File 'Get-BIOSInfo.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not work... |
| Get-BIOSInfo.ps1 | 178 | PSAvoidUsingWriteHost | File 'Get-BIOSInfo.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not work... |
| Get-BIOSInfo.ps1 | 181 | PSAvoidUsingWriteHost | File 'Get-BIOSInfo.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not work... |
| Get-BIOSInfo.ps1 | 184 | PSAvoidUsingWriteHost | File 'Get-BIOSInfo.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not work... |
| Get-FilenameList.ps1 |  | PSUseBOMForUnicodeEncodedFile | Missing BOM encoding for non-ASCII encoded file 'Get-FilenameList.ps1' |
| Get-FilenameList.ps1 | 54 | PSAvoidUsingWriteHost | File 'Get-FilenameList.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not ... |
| Get-FilenameList.ps1 | 55 | PSAvoidUsingWriteHost | File 'Get-FilenameList.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not ... |
| Get-InstalledPrograms.ps1 |  | PSUseBOMForUnicodeEncodedFile | Missing BOM encoding for non-ASCII encoded file 'Get-InstalledPrograms.ps1' |
| Get-IPConfigSummary.ps1 |  | PSUseBOMForUnicodeEncodedFile | Missing BOM encoding for non-ASCII encoded file 'Get-IPConfigSummary.ps1' |
| Get-IPConfigSummary.ps1 | 38 | PSAvoidUsingWriteHost | File 'Get-IPConfigSummary.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does n... |
| Get-IPConfigSummary.ps1 | 44 | PSAvoidUsingWriteHost | File 'Get-IPConfigSummary.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does n... |
| Get-IPConfigSummary.ps1 | 47 | PSAvoidUsingWriteHost | File 'Get-IPConfigSummary.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does n... |
| Get-IPConfigSummary.ps1 | 55 | PSAvoidUsingWriteHost | File 'Get-IPConfigSummary.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does n... |
| Get-IPConfigSummary.ps1 | 65 | PSAvoidUsingWriteHost | File 'Get-IPConfigSummary.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does n... |
| Get-IPConfigSummary.ps1 | 66 | PSAvoidUsingWriteHost | File 'Get-IPConfigSummary.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does n... |
| Get-IPConfigSummary.ps1 | 67 | PSAvoidUsingWriteHost | File 'Get-IPConfigSummary.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does n... |
| Get-IPConfigSummary.ps1 | 68 | PSAvoidUsingWriteHost | File 'Get-IPConfigSummary.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does n... |
| Get-StartupItems.ps1 | 43 | PSAvoidUsingWriteHost | File 'Get-StartupItems.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not ... |
| Get-StartupItems.ps1 | 61 | PSAvoidUsingWriteHost | File 'Get-StartupItems.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not ... |
| Get-StartupItems.ps1 | 66 | PSAvoidUsingWriteHost | File 'Get-StartupItems.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not ... |
| Get-StartupItems.ps1 | 69 | PSAvoidUsingWriteHost | File 'Get-StartupItems.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not ... |
| Get-USBDevices.ps1 |  | PSUseBOMForUnicodeEncodedFile | Missing BOM encoding for non-ASCII encoded file 'Get-USBDevices.ps1' |
| Get-USBDevices.ps1 | 34 | PSAvoidUsingWMICmdlet | File 'Get-USBDevices.ps1' uses WMI cmdlet. For PowerShell 3.0 and above, use CIM cmdlet which perform the same tasks ... |
| Get-Weather.ps1 |  | PSUseBOMForUnicodeEncodedFile | Missing BOM encoding for non-ASCII encoded file 'Get-Weather.ps1' |
| Get-Weather.ps1 | 44 | PSAvoidUsingWriteHost | File 'Get-Weather.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not work ... |
| Get-Weather.ps1 | 52 | PSAvoidUsingWriteHost | File 'Get-Weather.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not work ... |
| Invoke-BypassUAC.ps1 |  | PSUseBOMForUnicodeEncodedFile | Missing BOM encoding for non-ASCII encoded file 'Invoke-BypassUAC.ps1' |
| Invoke-BypassUAC.ps1 | 55 | PSUseApprovedVerbs | The cmdlet 'Ensure-LogDir' uses an unapproved verb. |
| Invoke-BypassUAC.ps1 | 61 | PSAvoidOverwritingBuiltInCmdlets | 'Write-Log' is a cmdlet that is included with PowerShell (version core-6.1.0-windows) whose definition should not be ... |
| Invoke-BypassUAC.ps1 | 69 | PSAvoidUsingWriteHost | File 'Invoke-BypassUAC.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not ... |
| Invoke-BypassUAC.ps1 | 82 | PSAvoidUsingWriteHost | File 'Invoke-BypassUAC.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not ... |
| Invoke-BypassUAC.ps1 | 83 | PSAvoidUsingWriteHost | File 'Invoke-BypassUAC.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not ... |
| Invoke-BypassUAC.ps1 | 93 | PSUseApprovedVerbs | The cmdlet 'Cleanup-Registry' uses an unapproved verb. |
| Invoke-BypassUAC.ps1 | 106 | PSUseApprovedVerbs | The cmdlet 'Full-CleanTraces' uses an unapproved verb. |
| Invoke-BypassUAC.ps1 | 106 | PSUseSingularNouns | The cmdlet 'Full-CleanTraces' uses a plural noun. A singular noun should be used instead. |
| Invoke-BypassUAC.ps1 | 112 | PSAvoidUsingWriteHost | File 'Invoke-BypassUAC.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not ... |
| Invoke-BypassUAC.ps1 | 114 | PSAvoidUsingWriteHost | File 'Invoke-BypassUAC.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not ... |
| Invoke-BypassUAC.ps1 | 117 | PSAvoidUsingWriteHost | File 'Invoke-BypassUAC.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not ... |
| Invoke-BypassUAC.ps1 | 121 | PSUseApprovedVerbs | The cmdlet 'Check-Elevation' uses an unapproved verb. |
| Invoke-BypassUAC.ps1 | 130 | PSAvoidUsingWriteHost | File 'Invoke-BypassUAC.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not ... |
| Invoke-BypassUAC.ps1 | 141 | PSAvoidUsingWriteHost | File 'Invoke-BypassUAC.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not ... |
| Invoke-BypassUAC.ps1 | 168 | PSAvoidUsingWriteHost | File 'Invoke-BypassUAC.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not ... |
| Invoke-BypassUAC.ps1 | 173 | PSAvoidUsingWriteHost | File 'Invoke-BypassUAC.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not ... |
| Invoke-Keylogger.ps1 |  | PSUseBOMForUnicodeEncodedFile | Missing BOM encoding for non-ASCII encoded file 'Invoke-Keylogger.ps1' |
| Invoke-Keylogger.ps1 | 64 | PSAvoidUsingWriteHost | File 'Invoke-Keylogger.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not ... |
| Invoke-Keylogger.ps1 | 201 | PSAvoidUsingWriteHost | File 'Invoke-Keylogger.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not ... |
| Invoke-Keylogger.ps1 | 202 | PSAvoidUsingWriteHost | File 'Invoke-Keylogger.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not ... |
| Invoke-Keylogger.ps1 | 203 | PSAvoidUsingWriteHost | File 'Invoke-Keylogger.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not ... |
| Invoke-Keylogger.ps1 | 204 | PSAvoidUsingWriteHost | File 'Invoke-Keylogger.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not ... |
| Invoke-Keylogger.ps1 | 205 | PSAvoidUsingWriteHost | File 'Invoke-Keylogger.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not ... |
| Invoke-SandboxDetection.ps1 |  | PSUseBOMForUnicodeEncodedFile | Missing BOM encoding for non-ASCII encoded file 'Invoke-SandboxDetection.ps1' |
| Invoke-SandboxDetection.ps1 | 48 | PSReviewUnusedParameter | The parameter 'Verbose' has been declared but not used. |
| Invoke-SandboxDetection.ps1 | 49 | PSReviewUnusedParameter | The parameter 'ShowAllDetails' has been declared but not used. |
| Invoke-SandboxDetection.ps1 | 55 | PSAvoidOverwritingBuiltInCmdlets | 'Write-Log' is a cmdlet that is included with PowerShell (version core-6.1.0-windows) whose definition should not be ... |
| Invoke-SandboxDetection.ps1 | 59 | PSAvoidUsingWriteHost | File 'Invoke-SandboxDetection.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, do... |
| Invoke-SandboxDetection.ps1 | 138 | PSAvoidGlobalVars | Found global variable 'global:DetectionResults'. |
| Invoke-SandboxDetection.ps1 | 142 | PSAvoidGlobalVars | Found global variable 'global:DetectionResults'. |
| Invoke-SandboxDetection.ps1 | 153 | PSAvoidUsingWMICmdlet | File 'Invoke-SandboxDetection.ps1' uses WMI cmdlet. For PowerShell 3.0 and above, use CIM cmdlet which perform the sa... |
| Invoke-SandboxDetection.ps1 | 154 | PSAvoidUsingWMICmdlet | File 'Invoke-SandboxDetection.ps1' uses WMI cmdlet. For PowerShell 3.0 and above, use CIM cmdlet which perform the sa... |
| Invoke-SandboxDetection.ps1 | 155 | PSAvoidUsingWMICmdlet | File 'Invoke-SandboxDetection.ps1' uses WMI cmdlet. For PowerShell 3.0 and above, use CIM cmdlet which perform the sa... |
| Invoke-SandboxDetection.ps1 | 156 | PSAvoidUsingWMICmdlet | File 'Invoke-SandboxDetection.ps1' uses WMI cmdlet. For PowerShell 3.0 and above, use CIM cmdlet which perform the sa... |
| Invoke-SandboxDetection.ps1 | 221 | PSAvoidUsingWMICmdlet | File 'Invoke-SandboxDetection.ps1' uses WMI cmdlet. For PowerShell 3.0 and above, use CIM cmdlet which perform the sa... |
| Invoke-SandboxDetection.ps1 | 248 | PSPossibleIncorrectComparisonWithNull | $null should be on the left side of equality comparisons. |
| Invoke-SandboxDetection.ps1 | 374 | PSAvoidUsingWMICmdlet | File 'Invoke-SandboxDetection.ps1' uses WMI cmdlet. For PowerShell 3.0 and above, use CIM cmdlet which perform the sa... |
| Invoke-SandboxDetection.ps1 | 430 | PSAvoidGlobalVars | Found global variable 'global:DetectionResults'. |
| Invoke-TokenManipulation.ps1 |  | PSUseBOMForUnicodeEncodedFile | Missing BOM encoding for non-ASCII encoded file 'Invoke-TokenManipulation.ps1' |
| Invoke-TokenManipulation.ps1 | 78 | PSAvoidUsingWriteHost | File 'Invoke-TokenManipulation.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, d... |
| Invoke-TokenManipulation.ps1 | 92 | PSUseApprovedVerbs | The cmdlet 'Cleanup-Traces' uses an unapproved verb. |
| Invoke-TokenManipulation.ps1 | 92 | PSUseSingularNouns | The cmdlet 'Cleanup-Traces' uses a plural noun. A singular noun should be used instead. |
| Invoke-TokenManipulation.ps1 | 165 | PSAvoidUsingEmptyCatchBlock | Empty catch block is used. Please use Write-Error or throw statements in catch blocks. |
| Invoke-TokenManipulation.ps1 | 172 | PSAvoidUsingEmptyCatchBlock | Empty catch block is used. Please use Write-Error or throw statements in catch blocks. |
| Invoke-TokenManipulation.ps1 | 179 | PSUseShouldProcessForStateChangingFunctions | Function 'Set-Persistence' has verb that could change system state. Therefore, the function has to support 'ShouldPro... |
| Invoke-TokenManipulation.ps1 | 199 | PSUseApprovedVerbs | The cmdlet 'Deep-Scan' uses an unapproved verb. |
| Invoke-TokenManipulation.ps1 | 221 | PSAvoidUsingEmptyCatchBlock | Empty catch block is used. Please use Write-Error or throw statements in catch blocks. |
| Invoke-TokenManipulation.ps1 | 369 | PSUseDeclaredVarsMoreThanAssignments | The variable 'runOut' is assigned but never used. |
| Lock-ScreenNow.ps1 |  | PSUseBOMForUnicodeEncodedFile | Missing BOM encoding for non-ASCII encoded file 'Lock-ScreenNow.ps1' |
| Logoff-IdleSessions.ps1 |  | PSUseBOMForUnicodeEncodedFile | Missing BOM encoding for non-ASCII encoded file 'Logoff-IdleSessions.ps1' |
| Logoff-IdleSessions.ps1 | 71 | PSAvoidUsingWriteHost | File 'Logoff-IdleSessions.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does n... |
| Logoff-IdleSessions.ps1 | 72 | PSAvoidUsingWriteHost | File 'Logoff-IdleSessions.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does n... |
| Logoff-IdleSessions.ps1 | 73 | PSAvoidUsingWriteHost | File 'Logoff-IdleSessions.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does n... |
| Logoff-IdleSessions.ps1 | 78 | PSAvoidUsingWriteHost | File 'Logoff-IdleSessions.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does n... |
| Logoff-IdleSessions.ps1 | 87 | PSAvoidUsingWriteHost | File 'Logoff-IdleSessions.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does n... |
| Logoff-IdleSessions.ps1 | 109 | PSAvoidUsingWriteHost | File 'Logoff-IdleSessions.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does n... |
| Logoff-IdleSessions.ps1 | 132 | PSAvoidUsingWriteHost | File 'Logoff-IdleSessions.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does n... |
| Logoff-IdleSessions.ps1 | 137 | PSAvoidUsingWriteHost | File 'Logoff-IdleSessions.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does n... |
| Logoff-IdleSessions.ps1 | 143 | PSAvoidUsingWriteHost | File 'Logoff-IdleSessions.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does n... |
| Logoff-IdleSessions.ps1 | 147 | PSAvoidUsingWriteHost | File 'Logoff-IdleSessions.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does n... |
| Logoff-IdleSessions.ps1 | 159 | PSAvoidUsingWriteHost | File 'Logoff-IdleSessions.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does n... |
| Logoff-IdleSessions.ps1 | 162 | PSAvoidUsingWriteHost | File 'Logoff-IdleSessions.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does n... |
| Logoff-IdleSessions.ps1 | 165 | PSAvoidUsingWriteHost | File 'Logoff-IdleSessions.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does n... |
| Logoff-IdleSessions.ps1 | 169 | PSAvoidUsingWriteHost | File 'Logoff-IdleSessions.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does n... |
| Logoff-IdleSessions.ps1 | 170 | PSAvoidUsingWriteHost | File 'Logoff-IdleSessions.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does n... |
| Logoff-IdleSessions.ps1 | 173 | PSAvoidUsingWriteHost | File 'Logoff-IdleSessions.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does n... |
| Monitor-CPUUsage.ps1 |  | PSUseBOMForUnicodeEncodedFile | Missing BOM encoding for non-ASCII encoded file 'Monitor-CPUUsage.ps1' |
| Monitor-CPUUsage.ps1 | 39 | PSAvoidUsingWriteHost | File 'Monitor-CPUUsage.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not ... |
| Monitor-CPUUsage.ps1 | 48 | PSAvoidUsingWriteHost | File 'Monitor-CPUUsage.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not ... |
| Monitor-CPUUsage.ps1 | 52 | PSAvoidUsingWriteHost | File 'Monitor-CPUUsage.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not ... |
| Monitor-CPUUsage.ps1 | 53 | PSAvoidUsingWriteHost | File 'Monitor-CPUUsage.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not ... |
| Monitor-CPUUsage.ps1 | 63 | PSAvoidUsingWriteHost | File 'Monitor-CPUUsage.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not ... |
| Monitor-CPUUsage.ps1 | 65 | PSAvoidUsingWriteHost | File 'Monitor-CPUUsage.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not ... |
| Monitor-CPUUsage.ps1 | 72 | PSAvoidUsingWMICmdlet | File 'Monitor-CPUUsage.ps1' uses WMI cmdlet. For PowerShell 3.0 and above, use CIM cmdlet which perform the same task... |
| Monitor-CPUUsage.ps1 | 73 | PSAvoidUsingWriteHost | File 'Monitor-CPUUsage.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not ... |
| Monitor-CPUUsage.ps1 | 75 | PSAvoidUsingWriteHost | File 'Monitor-CPUUsage.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not ... |
| Monitor-CPUUsage.ps1 | 82 | PSAvoidUsingWriteHost | File 'Monitor-CPUUsage.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not ... |
| Scan-Own-Ports.ps1 |  | PSUseBOMForUnicodeEncodedFile | Missing BOM encoding for non-ASCII encoded file 'Scan-Own-Ports.ps1' |
| Scan-Own-Ports.ps1 | 57 | PSAvoidUsingWriteHost | File 'Scan-Own-Ports.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not wo... |
| Scan-Own-Ports.ps1 | 63 | PSAvoidUsingWriteHost | File 'Scan-Own-Ports.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not wo... |
| Scan-Own-Ports.ps1 | 67 | PSAvoidUsingWriteHost | File 'Scan-Own-Ports.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not wo... |
| Scan-Own-Ports.ps1 | 72 | PSAvoidUsingWriteHost | File 'Scan-Own-Ports.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not wo... |
| Scan-Own-Ports.ps1 | 76 | PSAvoidUsingWriteHost | File 'Scan-Own-Ports.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not wo... |
| Scan-Own-Ports.ps1 | 78 | PSAvoidUsingWriteHost | File 'Scan-Own-Ports.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not wo... |
| Scan-Own-Ports.ps1 | 107 | PSAvoidUsingWriteHost | File 'Scan-Own-Ports.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not wo... |
| Scan-Own-Ports.ps1 | 113 | PSAvoidUsingWriteHost | File 'Scan-Own-Ports.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not wo... |
| Scan-Own-Ports.ps1 | 114 | PSAvoidUsingWriteHost | File 'Scan-Own-Ports.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not wo... |
| Scan-Own-Ports.ps1 | 116 | PSAvoidUsingWriteHost | File 'Scan-Own-Ports.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not wo... |
| Setup-LocalWebServer.ps1 | 142 | PSAvoidAssignmentToAutomaticVariable | The Variable 'Args' is an automatic variable that is built into PowerShell, assigning to it might have undesired side... |
| User-Credential.ps1 |  | PSUseBOMForUnicodeEncodedFile | Missing BOM encoding for non-ASCII encoded file 'User-Credential.ps1' |
| User-Credential.ps1 | 62 | PSReviewUnusedParameter | The parameter 'NewPassword' has been declared but not used. |
| User-Credential.ps1 | 62 | PSAvoidUsingPlainTextForPassword | Parameter '$NewPassword' should not use String type but either SecureString or PSCredential, otherwise it increases t... |
| User-Credential.ps1 | 63 | PSAvoidUsingPlainTextForPassword | Parameter '$TestPassword' should not use String type but either SecureString or PSCredential, otherwise it increases ... |
| User-Credential.ps1 | 63 | PSReviewUnusedParameter | The parameter 'TestPassword' has been declared but not used. |
| User-Credential.ps1 | 65 | PSReviewUnusedParameter | The parameter 'LogPath' has been declared but not used. |
| User-Credential.ps1 | 88 | PSAvoidOverwritingBuiltInCmdlets | 'Write-Log' is a cmdlet that is included with PowerShell (version core-6.1.0-windows) whose definition should not be ... |
| User-Credential.ps1 | 101 | PSAvoidUsingWriteHost | File 'User-Credential.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not w... |
| User-Credential.ps1 | 105 | PSUseApprovedVerbs | The cmdlet 'Abort-IfNotAdmin' uses an unapproved verb. |
| User-Credential.ps1 | 113 | PSUseApprovedVerbs | The cmdlet 'Download-ExternalBinary' uses an unapproved verb. |
| User-Credential.ps1 | 128 | PSUseApprovedVerbs | The cmdlet 'Ensure-ExternalBinaries' uses an unapproved verb. |
| User-Credential.ps1 | 128 | PSUseSingularNouns | The cmdlet 'Ensure-ExternalBinaries' uses a plural noun. A singular noun should be used instead. |
| User-Credential.ps1 | 201 | PSPossibleIncorrectComparisonWithNull | $null should be on the left side of equality comparisons. |
| User-Credential.ps1 | 212 | PSAvoidUsingEmptyCatchBlock | Empty catch block is used. Please use Write-Error or throw statements in catch blocks. |
| User-Credential.ps1 | 324 | PSUseShouldProcessForStateChangingFunctions | Function 'Set-Password' has verb that could change system state. Therefore, the function has to support 'ShouldProcess'. |
| User-Credential.ps1 | 334 | PSUseApprovedVerbs | The cmdlet 'Check-Password' uses an unapproved verb. |
| User-Credential.ps1 | 349 | PSUseApprovedVerbs | The cmdlet 'Flash-CapsLock' uses an unapproved verb. |
| User-Credential.ps1 | 400 | PSAvoidUsingWriteHost | File 'User-Credential.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts, does not w... |

### Info

| File | Line | Rule | Message |
| ---- | ---- | ---- | ------- |
| Get-InstalledPrograms.ps1 | 43 | PSAvoidTrailingWhitespace | Line has trailing whitespace |
| Get-USBDevices.ps1 | 34 | PSAvoidTrailingWhitespace | Line has trailing whitespace |
| Invoke-BypassUAC.ps1 | 97 | PSAvoidUsingPositionalParameters | Cmdlet 'Write-Log' has positional parameter. Please use named parameters instead of positional parameters when callin... |
| Invoke-BypassUAC.ps1 | 99 | PSAvoidUsingPositionalParameters | Cmdlet 'Write-Log' has positional parameter. Please use named parameters instead of positional parameters when callin... |
| Invoke-BypassUAC.ps1 | 102 | PSAvoidUsingPositionalParameters | Cmdlet 'Write-Log' has positional parameter. Please use named parameters instead of positional parameters when callin... |
| Invoke-BypassUAC.ps1 | 136 | PSAvoidUsingPositionalParameters | Cmdlet 'Write-Log' has positional parameter. Please use named parameters instead of positional parameters when callin... |
| Invoke-BypassUAC.ps1 | 137 | PSAvoidUsingPositionalParameters | Cmdlet 'Write-Log' has positional parameter. Please use named parameters instead of positional parameters when callin... |
| Invoke-BypassUAC.ps1 | 140 | PSAvoidUsingPositionalParameters | Cmdlet 'Write-Log' has positional parameter. Please use named parameters instead of positional parameters when callin... |
| Invoke-BypassUAC.ps1 | 149 | PSAvoidUsingPositionalParameters | Cmdlet 'Write-Log' has positional parameter. Please use named parameters instead of positional parameters when callin... |
| Invoke-BypassUAC.ps1 | 152 | PSAvoidUsingPositionalParameters | Cmdlet 'Write-Log' has positional parameter. Please use named parameters instead of positional parameters when callin... |
| Invoke-BypassUAC.ps1 | 155 | PSAvoidUsingPositionalParameters | Cmdlet 'Write-Log' has positional parameter. Please use named parameters instead of positional parameters when callin... |
| Invoke-BypassUAC.ps1 | 157 | PSAvoidUsingPositionalParameters | Cmdlet 'Write-Log' has positional parameter. Please use named parameters instead of positional parameters when callin... |
| Invoke-BypassUAC.ps1 | 161 | PSAvoidUsingPositionalParameters | Cmdlet 'Write-Log' has positional parameter. Please use named parameters instead of positional parameters when callin... |
| Invoke-BypassUAC.ps1 | 164 | PSAvoidUsingPositionalParameters | Cmdlet 'Write-Log' has positional parameter. Please use named parameters instead of positional parameters when callin... |
| Invoke-BypassUAC.ps1 | 167 | PSAvoidUsingPositionalParameters | Cmdlet 'Write-Log' has positional parameter. Please use named parameters instead of positional parameters when callin... |
| Invoke-BypassUAC.ps1 | 171 | PSAvoidUsingPositionalParameters | Cmdlet 'Write-Log' has positional parameter. Please use named parameters instead of positional parameters when callin... |
| Invoke-Keylogger.ps1 | 50 | PSAvoidTrailingWhitespace | Line has trailing whitespace |
| Invoke-SandboxDetection.ps1 | 318 | PSAvoidTrailingWhitespace | Line has trailing whitespace |
| Invoke-SandboxDetection.ps1 | 430 | PSAvoidTrailingWhitespace | Line has trailing whitespace |
| Invoke-SandboxDetection.ps1 | 432 | PSAvoidTrailingWhitespace | Line has trailing whitespace |
| User-Credential.ps1 | 170 | PSAvoidTrailingWhitespace | Line has trailing whitespace |
| User-Credential.ps1 | 173 | PSAvoidTrailingWhitespace | Line has trailing whitespace |
| User-Credential.ps1 | 177 | PSAvoidTrailingWhitespace | Line has trailing whitespace |

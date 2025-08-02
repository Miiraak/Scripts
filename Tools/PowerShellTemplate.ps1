########################################################################################
#                                                                                      |
#     Title        : <scriptname>.ps1                                                  |
#     Link         : https://github.com/miiraak/Scripts/PowerShell/<folder>/subfolder> |
#     Author       : XXXXXXXXXx                                                        |
#     Version      : X.X.X                                                             |
#     Category     : <category>                                                        |
#     Target       : <system target>                                                   |
#     Description  : Blablablablabalbalbalbalbablablabalblab                           |
#                                                                                      |
########################################################################################

# ---------------[Parameters]--------------- #
param (
    [string]$param1 = "param1",
    [string]$param2 = "param2"
)

# ---------------[Variables]--------------- #
$Parameter1 = $param1
$Parameter2 = $param2
$Parameter3 = $null

# ---------------[Functions]--------------- #
function functionName {
    $Parameter3 = $Parameter1 + $Parameter2
    Write-Output "The result is: $Parameter3"
}

# ---------------[Execution]--------------- #
functionName

# ---------------[End]--------------- #
exit 0

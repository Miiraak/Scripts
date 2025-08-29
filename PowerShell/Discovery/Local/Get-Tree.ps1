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
#     Title        : Get-Tree.ps1                                                                 #
#     Link         : https://github.com/Miiraak/Scripts/tree/master/PowerShell/Discovery/Local/   #
#     Version      : 1.1                                                                          #
#     Category     : Discovery / Local                                                            #
#     Target       : Windows 10/11                                                                #
#     Description  : Display a recursive ASCII tree of files and folders for a given path.        #
#                                                                                                 #
###################################################################################################

<#
.SYNOPSIS
    Displays a visual ASCII tree of the directory structure for a specified folder.

.DESCRIPTION
    Recursively audits and prints all files and subdirectories within the given folder,
    presenting them in a clear, indented ASCII tree format. Useful for quickly inspecting
    the layout and contents of any directory.

.PARAMETER Folder
    The root folder path whose tree structure will be displayed.

.EXAMPLE
    .\Get-Tree.ps1 "C:\MyFolder"
    Shows the complete tree structure of the folder "C:\MyFolder" and all its subfolders.
#>

# ---------------[Parameters]--------------- #
param (
    [Parameter(Mandatory = $true)]
    [string]$Folder
)

# ---------------[Functions]--------------- #
function Show-Tree {
    param (
        [string]$Path,
        [string]$Prefix = ""
    )
    $items = Get-ChildItem -Path $Path
    $count = $items.Count
    for ($i = 0; $i -lt $count; $i++) {
        $item = $items[$i]
        if ($i -eq $count - 1) {
            $connector = "└── "
        } else {
            $connector = "├── "
        }
        Write-Output "$Prefix$connector$item"
        if ($item.PSIsContainer) {
            if ($i -eq $count - 1) {
                $newPrefix = $Prefix + "    "
            } else {
                $newPrefix = $Prefix + "│   "
            }
            Show-Tree -Path $item.FullName -Prefix $newPrefix
        }
    }
}

function Show-Summary {
    param (
        [string]$Path
    )
    $totalFiles = (Get-ChildItem -Path $Path -Recurse -File).Count
    $totalDirs = (Get-ChildItem -Path $Path -Recurse -Directory).Count
    $totalSize = (Get-ChildItem -Path $Path -Recurse -File | Measure-Object -Property Length -Sum).Sum
    Write-Output ""
    Write-Output "Total : $totalDirs dir, $totalFiles files, $totalSize bytes"
}

# ------------[Execution]------------ #
Write-Output (Split-Path $Folder -Leaf)
Show-Tree -Path $Folder
Show-Summary -Path $Folder

# ---------------[End]--------------- #
exit 0
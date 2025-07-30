# Get-FilenameList.ps1

## Overview
**Get-FilenameList.ps1** is a PowerShell script that lists all file names in a specified folder and displays them in the console. It is a simple tool to quickly view file names within a directory.

## Features
- **Mandatory Path Argument:** Requires the folder path as input.
- **File Listing:** Retrieves only files (not directories) in the given folder.
- **Console Output:** Prints the list of file names in color for better readability.
- **Error Handling:** Displays an error and exits if the specified folder does not exist.

## Requirements
- **Windows 10/11**
- **PowerShell 5.1+**

## Parameters
| Name | Type   | Mandatory | Description                      |
|------|--------|-----------|----------------------------------|
| Path | string | Yes       | Path to the folder to list files |

## Usage

### Basic Example
```powershell
.\Get-FilenameList.ps1 -Path "C:\MyFolder"
```

Or using positional parameter:

```powershell
.\Get-FilenameList.ps1 "C:\MyFolder"
```

## Script Workflow
1. **Folder Existence Check:** Verifies that the specified folder exists.
2. **File Retrieval:** Gets all file names (ignores directories) from the folder.
3. **Display:** Prints the file names to the console in cyan color.

## Help & Documentation
You can get help directly in PowerShell using:

```powershell
Get-Help .\Get-FilenameList.ps1
```

or

```powershell
man .\Get-FilenameList.ps1
```

## Troubleshooting

- Make sure the folder exists before running the script.
- The script lists files only; subfolders are not included.

## License
```
MIT License

Copyright (c) 2025 Miiraak

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
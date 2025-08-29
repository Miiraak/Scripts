# Get-Tree.ps1

## Overview
**Get-Tree.ps1** is a PowerShell script for Windows 10/11 that generates a recursive, ASCII directory tree of files and folders for a specified path.

## Features
- **Tree generation:** Creates an ASCII tree structure of a given directory, showing nested folders and files.
- **Recursive listing:** Explores all subdirectories and displays their contents in a hierarchical view.
- **Easy to use:** Specify any folder to instantly visualize its structure.

## Requirements
- **Windows 10/11**
- **PowerShell 5.1+**
- **A folder** (as input parameter)

## Parameters
| Name   | Type   | Mandatory | Description                                 |
|--------|--------|-----------|---------------------------------------------|
| Folder | string | Yes       | The path of the folder to display as a tree |

## Usage
### Basic Example
```powershell
.\Get-Tree.ps1 ./MyFolder
.\Get-Tree.ps1 C:\Users\Miiraak\Desktop\
```

## Script Workflow
1. **Initialize:** Displays the root folder name.
2. **Recursively gathers items:** Lists all files and folders starting from the provided path.
3. **Formats output:** Prints each item with ASCII branches, clearly showing the folder structure.

## Output
- **Console:**  
  Displays the recursive tree structure, e.g.:
  ```
  MyFolder
  ├── file1.txt
  ├── SubFolder
  │   ├── anotherfile.docx
  │   └── image.png
  └── README.md
  ```

## Help & Documentation
Get help in PowerShell:

```powershell
Get-Help .\Get-Tree.ps1
```
or
```powershell
man .\Get-Tree.ps1
```

## Troubleshooting
- Run PowerShell as administrator for full access to all directories.
- Some folders may require elevated permissions to access their contents.
- If nothing is displayed, ensure the path is correct and the folder exists.

## License
```
MIT License

Copyright (c) 2025 Miiraak

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
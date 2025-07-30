# Capture-Screen.ps1

## Overview
**Capture-Screen.ps1** is a PowerShell script that captures a screenshot of your primary display and saves it as an image file (PNG, JPEG, or BMP) on Windows 10/11. It is useful for quickly automating full-screen captures directly from scripts or the command line.

## Features
- **Customizable Delay:** Set a countdown before the screenshot is taken.
- **Flexible Output Location and Name:** Specify the directory and filename for your screenshot.
- **Multiple Image Formats:** Save the screenshot as PNG, JPEG, or BMP.
- **Automatic Filename Timestamp:** Default filename includes the current date and time.
- **Uses .NET Drawing Libraries:** No external dependencies required.

## Requirements
- **Windows 10/11**
- **PowerShell 5.1+**
- **.NET Framework (System.Windows.Forms, System.Drawing)**

## Parameters
| Name        | Type   | Default                                   | Description                                                  |
|-------------|--------|-------------------------------------------|--------------------------------------------------------------|
| Delay       | int    | 2                                         | Countdown in seconds before the screenshot is taken.         |
| OutputPath  | string | `$PSScriptRoot`                           | Directory path to save the image (defaults to script folder). |
| OutputFile  | string | `screenshot_yyyyMMdd_HHmmss`              | Name of the image file (timestamped by default).             |
| ImageFormat | string | PNG                                       | Format of the image: PNG, JPEG, or BMP.                      |

## Usage

### Basic Example
```powershell
.\Capture-Screen.ps1
```

### Custom Output and Delay
```powershell
.\Capture-Screen.ps1 -Delay 5 -OutputPath "C:\Screenshots" -OutputFile "DesktopCapture" -ImageFormat "JPEG"
```

## Script Workflow
1. **Parameters:** Accepts delay, output location, filename, and image format.
2. **Countdown:** Displays a countdown before capture.
3. **Screenshot:** Captures the primary screen and saves it in the specified format and location.
4. **Resource Cleanup:** Disposes of graphics objects after saving.

## Help & Documentation
You can get help directly in PowerShell using:

```powershell
Get-Help .\Capture-Screen.ps1
```

or

```powershell
man .\Capture-Screen.ps1
```

## Troubleshooting
- If you get errors about missing types, ensure Windows PowerShell is running with .NET available.
- The script captures only the primary screen.
- The output directory must be writable; otherwise, the script will fail to save the image.

## License
```
MIT License

Copyright (c) 2025 Miiraak

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```

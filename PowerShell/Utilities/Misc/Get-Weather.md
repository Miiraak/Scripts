
# Get-Weather.ps1

## Overview
**Get-Weather.ps1** is a PowerShell script for Windows 10/11 that displays the current weather information for a specified city by querying [wttr.in](https://wttr.in). It is lightweight, requires no API key, and works entirely from your console using PowerShell's built-in web request capabilities.

---

## Features
- **Simple Query:** Enter any city name to get instant weather data.
- **Fast & Lightweight:** No dependencies or API registration required.
- **Error Handling:** Friendly color-coded messages for missing or invalid city names.
- **Cross-version:** Compatible with Windows PowerShell and PowerShell Core (7+).

---

## Parameters
| Name      | Type   | Required | Description                      |
|-----------|--------|----------|----------------------------------|
| City      | string | Yes      | Name of the city for weather     |

---

## Usage
Get the weather for a city (example: Bern):

```powershell
.\Get-Weather.ps1 -City "Bern"
```

If you omit the `-City` parameter or provide an invalid city name, the script will prompt you to enter a valid city.

---

## Output Example
```
Weather report: Bern

      \   /     Clear
       .-.      22 °C
    ― (   ) ―   ↙ 10 km/h
       `-’      0.0 mm
      /   \     10 km
```

If the city name is missing or the weather cannot be retrieved:

```
Please provide a city name.
Could not retrieve weather information for 'bern'. Please check the city name.
```

---

## Help & Documentation
Display the script's built-in help:

```powershell
Get-Help .\Get-Weather.ps1
man .\Get-Weather.ps1
```

---

## Troubleshooting
- **Execution Policy:** If `Get-Help` or the script fails to run, ensure your PowerShell execution policy is set to `Bypass` or less restrictive.  
  Example to set for the current session:
  ```powershell
  Set-ExecutionPolicy Bypass -Scope Process
  ```
- **Internet Connection:** The script requires an active internet connection to query [wttr.in](https://wttr.in).
- **City Names:** Make sure to use valid city names. If the city is ambiguous or not recognized, try with country or region (e.g., `"Paris, France"`).

---

## License
```
MIT License

Copyright (c) Year Miiraak

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

```

---
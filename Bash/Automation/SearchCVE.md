# SearchCVE.sh

## Overview
**SearchCVE.sh** is a Bash script for automated CVE searches in Metasploit. It allows you to check multiple CVEs at once, either from a file or as a single argument, and supports parallel execution for faster results.

## Features
- **Search for one or many CVEs in Metasploit**
- **Read CVEs from a file or as a direct argument**
- **Parallel execution with configurable threads**
- **Automatic detection of Metasploit installation**
- **Inline help for all usage options**

## Requirements
- Bash (Linux or macOS)
- Metasploit Framework (`msfconsole`) installed and accessible in your PATH

## Usage
```sh
# Search all CVEs in a file, one per line
./SearchCVE.sh -f cve.txt

# Search for a specific CVE
./SearchCVE.sh CVE-2022-41741

# Search all CVEs in a file with 5 parallel threads
./SearchCVE.sh -f cve.txt -t 5

# Show help
./SearchCVE.sh -h
```
> The script will print Metasploit search results for each CVE, clearly separated.

## Output Example
```
========== CVE:2021-36368 ==========
[-] No results from search
------------------------------

========== CVE-2023-20887 ==========

Matching Modules
================

   #  Name                                               Disclosure Date  Rank       Check  Description
   -  ----                                               ---------------  ----       -----  -----------
   0  exploit/linux/http/vmware_vrni_rce_cve_2023_20887  2023-06-07       excellent  Yes    VMWare Aria Operations for Networks (vRealize Network Insight) pre-authenticated RCE
   1    \_ target: Unix (In-Memory)                      .                .          .      .
   2    \_ target: Linux Dropper                         .                .          .      .


Interact with a module by name or index. For example info 2, use 2 or use exploit/linux/http/vmware_vrni_rce_cve_2023_20887
After interacting with a module you can manually set a TARGET with set TARGET 'Linux Dropper'
```

## Help & Documentation
You can read the inline help by using:

```sh
./SearchCVE.sh -h
```

## Troubleshooting
- If you see `[ERROR] Metasploit msfconsole is not installed or not detected.`, ensure Metasploit is installed and `msfconsole` is available in your PATH.
- If you see `[ERROR] File 'filename' not found.`, double-check the file location and name.

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
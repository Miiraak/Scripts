# Scripts 
[![Update INDEX.md](https://github.com/Miiraak/Scripts/actions/workflows/Update-Credits-List.yml/badge.svg?event=workflow_dispatch)](https://github.com/Miiraak/Scripts/actions/workflows/Update-Credits-List.yml)
[![Update CREDITS.md](https://github.com/Miiraak/Scripts/actions/workflows/Update-Repository-Index.yml/badge.svg?event=workflow_dispatch)](https://github.com/Miiraak/Scripts/actions/workflows/Update-Repository-Index.yml)
[![PowerShell Analysis](https://github.com/Miiraak/Scripts/actions/workflows/Analysis-Repo.yml/badge.svg?event=workflow_dispatch)](https://github.com/Miiraak/Scripts/actions/workflows/Analysis-Repo.yml)

_We truly appreciate every ⭐ and contributions, thanks for helping this project grow!_

---

## Introduction
**Scripts** is a meticulously curated repository featuring categorized scripts written in PowerShell, Bash, C#, C, and other languages.  
This collection is designed to empower security professionals, penetration testers, red and blue teamers, and learners with practical, real-world resources for security experimentation, research, and skill development. 

Inside, you'll find proof-of-concepts (PoCs), basics scripts, advanced techniques, and utilities that cover offensive operations, defensive strategies, and analytical processes.

- **Comprehensive Coverage:** Easily discover scripts for a wide range of scenarios.
- **Organized for Efficiency:** Categories are structured by purpose, complexity, and technique, enabling fast access to the right tools for your needs.
- **Practical and Educational:** Each script is documented to support learning, with real-world applications and clear, actionable examples.

> <div style="border:1px solid #4fa3ff; background-color:#435f74ff; border-radius:6px; padding:8px;">
> <strong>Who Should Use This Repository?</strong><br>
> IT, Security professionals, penetration testers, cyber defense enthusiasts, students, and lifelong learners.
> </div>

---

## Features
- **Broad Language Support:** Find scripts in PowerShell, Bash, C#, C, and more, enabling use across multiple platforms and environments.
- **Intuitive Categorization:** Scripts are systematically grouped by domain and technique, making navigation straightforward and efficient.
- **Real-World Security Techniques:** Experiment with PoCs, automation tools, and utilities for offensive, defensive, forensic or everyday life scenarios.
- **Scalable Complexity:** Whether you're beginning or advanced, the repository includes both simple utilities and sophisticated, multi-stage solutions.
- **Learning-Focused Documentation:** Each script is thoroughly annotated with usage instructions, examples, and context to facilitate hands-on learning or improving.
- **Continuous Improvement:** The repository is actively maintained and updated with fresh content and new techniques to stay relevant.

---

## Folder Structure
```plaintext
[Language]/
├── Automation/             # Any automation of action, elevation, etc...
├── Collection/             # Thematic script collections (Clipboard, Keylogging, etc.)
├── CredentialAccess/       # Credentials dumping, browser creds, tokens, WiFi
├── DefenseEvasion/         # AMSI bypass, in-memory execution, obfuscation
├── Discovery/              # Host, network, and domain discovery
├── Execution/              # Loaders, shellcode, reflective techniques
├── Exfiltration/           # Data exfiltration via DNS, HTTP, SMB, steganography
├── Impact/                 # Ransomware, destruction, persistence removal
├── InitialAccess/          # Initial foothold and access techniques
├── Persistence/            # Registry, scheduled tasks, WMI, DLL hijacking
├── PostExploitation/       # Lateral movement, pivoting, session control
├── PrivilegeEscalation/    # Exploits, process injection, token/UAC bypass
└── Utilities/              # Crypto, logging, misc tools, payload generators
```

You can see the full structure of the repository at [`INDEX.md`](INDEX.md). 

---

## Status
- All scripts meet at least Minimum Viable Product (MVP) standards.
- Scripts have been tested locally before inclusion.
- The repository is actively maintained and open for community feedback.

---

## Usage
Scripts in this repository range from standalone utilities to advanced, multi-stage solutions.  
Some can be executed immediately, while others may require dependencies, elevated privileges, or specific environments.  
Always review the documentation and comments within each script before execution.

---

## Requirements
> <div style="border:1px solid #ffe066; background-color: #9e8c30ff; border-radius:6px; padding:10px;">
> <strong>Note:</strong> There is <strong>no universal installation procedure</strong> for this repository.<br>
> Each script may have unique dependencies and setup instructions.<br>
> Please check individual script documentasstion or header comments for details.
> </div>

---

## Licenses
- Some scripts and tools may include or reference third-party binaries or code.
- All external licenses and attributions are provided in the [`/licenses/`](https://github.com/Miiraak/Scripts/tree/master/Licences) directory.
- Redistribution conditions are respected—consult license files before use or sharing.

---

## Contributing
All contributions are gladly welcome!  
Whether you’re submitting a new script, improving documentation, reporting issues, or suggesting new techniques, your input helps the project grow.
Please refer to [`CONTRIBUTING.md`](./CONTRIBUTING.md) for the contibutions standards.

If you would like to see the list of errors or warnings found in scripts requiring correction, you can take a look at [`FIXIT.md`](./FIXIT.md). 

---

## Contact & Contributors
- **Author:** Miiraak
- **Email:** [miiraak@miiraak.ch](mailto:miiraak@miiraak.ch)
- **Website:** [https://miiraak.ch](https://miiraak.ch)

You can find full list of contributors in the [`CREDITS.md`](./CREDITS.md) file.

---

## Disclaimer
> <strong>⚠️ For Educational & Authorized Use Only!</strong><br><br>
> These scripts are provided strictly for learning, experimentation, and use in authorized environments.<br>
> <strong>Do NOT deploy in production or real-world scenarios without explicit written consent.</strong><br>
> Unauthorized use may lead to unintended consequences and is strictly prohibited.<br><br>
> <strong>Liability Disclaimer:</strong><br>
> The authors, contributors, and repository owners cannot be held responsible for any misuse, damage, or consequences resulting from the use of these scripts.<br>
> Use at your own risk.
> </div>

---

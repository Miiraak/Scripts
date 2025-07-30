# Contributing

Thank you for considering contributing to this repository!  
All contributions are welcome—whether submitting scripts, documentation, improvements, or reporting issues.

## How to Contribute

1. **Open an Issue**  
   - Please create an issue before submitting a pull request, so we can discuss your proposal.
   - Use the relevant issue template for bug reports, feature requests, or script submissions.

2. **Submit a Pull Request**  
   - Reference the related issue in your pull request.
   - Ensure your script follows the repository standards (see below).

## Contribution Standards

- **Scripts**  
  - Must include a header with metadata:
    - Title
    - Link
    - Author
    - Version
    - Category
    - Target
    - Short description
  - Should be paired with a `.md` documentation file of the same name.
  - Segment and comment obfuscated code to maintain clarity.
  - Templates are available in the `template` folder.
  - Scripts supporting `man` or `Get-Help` must implement those features; otherwise, provide a `--h` option or equivalent.
    - .SYNOPSIS
    - .DESCRIPTION _(more consequent than header)_
    - .PARAMETER <param>
    - .EXAMPLE

- **Quality**  
  - Scripts must meet minimum viable product (MVP) standards.
  - Must work locally or in a controlled environment.
  - Concepts described must function or be clearly staged.

## Transparency & Security

- **Transparency:**  
  Scripts must not attempt to harm the direct user in an obfuscated or misleading fashion or in any ways.  
  If a script is inherently dangerous (e.g., deletes system files), its purpose must be clear and documented.  
  Misuse of such scripts is a user error, not a repository vulnerability.
- **Intent:**  
  Scripts must **never** be designed to target or harm any specific person (physical or legal entity), nor to harm the user in an undisclosed or hidden way.
- **Privacy:**  
  Do not disclose private, sensitive, or confidential information in public issues or pull requests. If you discover such a problem, contact the repository owner privately.

## Recognition & Credits

- All contributors are listed in [`CREDITS.md`](https://github.com/Miiraak/Scripts/tree/master/CREDITS.md).

## Inclusivity

- Contributions from all skill levels are encouraged.
- Please be respectful and constructive.

## Review Process

- Contributions are reviewed within a few hours or days by the repository owner or main maintainers.

## Questions

- Contact info is available on the repository owner’s [GitHub profile](https://github.com/Miiraak).

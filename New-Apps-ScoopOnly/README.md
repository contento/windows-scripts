
# Scoop-Only Workstation Bootstrap (No Admin)

Bootstrap a Windows development workstation using **Scoop only**, with **zero administrator access** required.

This project installs a curated set of CLI tools, GUI apps, and developer fonts **entirely in user scope**, making it suitable for:
- Corporate / locked-down laptops
- Consulting engagements
- Short-lived or disposable dev environments

No `winget`. No elevation. No machine-wide changes.

---

## What This Does

- Installs **Scoop** in the current user profile (if not already present)
- Adds required Scoop buckets
- Installs CLI tools, GUI applications, and Nerd Fonts
- Modifies **execution policy only for the current user / process**
- Is **idempotent** (safe to re-run)

Everything is installed under:

```text
C:\Users\<you>\scoop
````

***

## Requirements

*   Windows 10 (1809+) or Windows 11
*   PowerShell 5.1+ or PowerShell 7+
*   Internet access to GitHub
*   **No administrator privileges required**

***

## Project Structure

```text
.
├── New-Apps-ScoopOnly.ps1
└── README.md
```

***

## Installed Software

### CLI / Developer Tools (main bucket)

*   git
*   python
*   btop
*   eza
*   fastfetch
*   fzf
*   ghostscript
*   yazi
*   zoxide

### GUI Applications (extras bucket)

*   Visual Studio Code (portable)
*   Windows Terminal
*   Brave Browser
*   Notepad3

### Versioned Tools (versions bucket)

*   lightshot

### Fonts (nerd-fonts bucket, user scope)

*   Delugia Nerd Font (Complete)
*   FiraCode
*   FiraCode Nerd Font

Fonts are installed **per-user** and do not write to system-wide locations.

***

## Usage

### 1. Clone or copy the script

```powershell
git clone <repo-url>
cd <repo-folder>
```

Or download `New-Apps-ScoopOnly.ps1` directly.

***

### 2. Run the script (non-admin PowerShell)

```powershell
.\New-Apps-ScoopOnly.ps1
```

That’s it.

No UAC prompts.  
No registry writes to HKLM.  
No system PATH pollution.

***

## Execution Policy Behavior

The script sets execution policy **safely and locally**:

*   `Process` scope → `Bypass`
*   `CurrentUser` scope → `RemoteSigned`

No machine-level policy is changed.

***

## Re-running the Script

Safe and expected.

*   Already-installed apps are skipped
*   Existing buckets are reused
*   Scoop handles versioning and upgrades

To upgrade everything later:

```powershell
scoop update *
```

***

## Why Scoop Only?

*   Designed for **non-admin** usage
*   Fully portable installs
*   Clean uninstalls
*   Predictable filesystem layout
*   Ideal for consulting and enterprise environments

This repo intentionally avoids:

*   `winget`
*   MSI installers
*   System-wide configuration

***

## Customization

To add or remove software, edit this section in the script:

```powershell
$scoopPackages = @{
  "main"       = @( ... )
  "extras"     = @( ... )
  "versions"   = @( ... )
  "nerd-fonts" = @( ... )
}
```

Buckets are added automatically if missing.

***

## Known Limitations

*   Some GUI apps may not integrate with system file associations
*   Fonts require Windows 10 1809+ for user-scope installation
*   Corporate proxies may require additional configuration

***

## License

MIT (or internal-use — adjust as needed)

***

## Author

**Gonzalo Contento**

Consultant / Engineer  
Azure • Fabric • Microsoft 365 • Power BI

# Apps

Install a curated set of applications via **winget** and **Scoop**.

## Files

| File | Description |
| ---- | ----------- |
| [`New-Apps.ps1`](New-Apps.ps1) | Installs winget and Scoop packages; pass `-ScoopOnly` to skip winget |

## Usage

### Full install (winget + Scoop)

```powershell
.\New-Apps.ps1
```

### Scoop-only (no winget, no admin required)

```powershell
.\New-Apps.ps1 -ScoopOnly
```

## Packages installed

### winget

7-Zip, Bitwarden, Brave, Ditto, Total Commander, Git, IrfanView, TreeSize Free, lazygit, Microsoft Coreutils, PowerShell 7, Sysinternals, Teams, VS Code, Firefox, Nmap, Starship, portal, Python 3, Revo Uninstaller, Beyond Compare 5, Windows Terminal, Zen Browser, zoxide.

Coreutils is installed as a direct winget package; the profile intentionally avoids aliasing its GNU-style commands to prevent PowerShell pipeline conflicts.

### Scoop (default buckets)

`btop`, `eza`, `fastfetch`, `fzf`, `ghostscript`, `yazi`, `notepad3`, `sumatrapdf`, Delugia / FiraCode Nerd Fonts, lightshot.

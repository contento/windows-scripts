# Profile

PowerShell startup profile and setup scripts, compatible with Windows PowerShell 5.1 and PowerShell 7 (Core).

## Files

| File | Description |
|------|-------------|
| [`profile.ps1`](profile.ps1) | Main profile — Fastfetch, Starship, Zoxide, PSReadLine, aliases, eza/bat wrappers, env vars |
| [`Setup-Profile.ps1`](Setup-Profile.ps1) | Windows setup: creates hard links in `$PROFILE` locations for PS 7 and PS 5.1, copies Starship config |
| [`setup-profile.sh`](setup-profile.sh) | macOS / Linux setup: creates symlinks for the PowerShell profile |
| [`.config/starship/starship.toml`](.config/starship/starship.toml) | Bundled Starship prompt configuration (installed by `Setup-Profile.ps1`) |

## What the profile does

- **Fastfetch** — minimal system summary on startup (OS, shell, CPU, memory, uptime)
- **Starship** — initializes prompt with bundled `starship.toml`
- **Zoxide** — replaces `cd` with smart directory jumping (`z` / `zi`)
- **PSReadLine** — history predictions, list view, Tab menu, arrow-key history search
- **Aliases** — `Edit` → Notepad, `vim`/`v` → nvim, `y` → yazi
- **eza wrappers** — `l`, `ll`, `la`, `lla`, `lt` with icons, color, and git status
- **bat wrapper** — `cat` with syntax highlighting
- **Environment variables** — `Editor`, `MSYS2_ARG_CONV_EXCL`, `MSYS_NO_PATHCONV`, `YAZI_FILE_ONE`

## Setup

### Windows

```powershell
.\Setup-Profile.ps1
```

Creates hard links for both PowerShell 7 (`Documents\PowerShell`) and Windows PowerShell 5.1 (`Documents\WindowsPowerShell`), and copies Starship config to `~/.config/starship.toml`.

### macOS / Linux

```bash
./setup-profile.sh
```

# Windows Scripts

```text
  o  o
\______/
  |
     |    https://conten.to
--------
```

A collection of portable PowerShell scripts for Windows setup and daily use — version-controlled and easy to deploy on a new machine.

## Contents

| Folder | Description |
| ------ | ----------- |
| [profile/](profile/) | PowerShell startup profile (Fastfetch, Starship, Zoxide, PSReadLine, aliases) and setup scripts |
| [apps/](apps/) | Install a curated set of apps via winget and Scoop |
| [backup/](backup/) | Back up files and folders to OneDrive with automatic archiving |
| [compress-this/](compress-this/) | Timestamped 7-Zip archive of the current folder; `-Dev` excludes build artifacts and caches |
| [system/](system/) | One-time system setup: OpenSSH and user-folder symbolic links |
| [terminal/](terminal/) | Version-controlled Windows Terminal settings.json, symlinked into place |

## Quick start

1. **Install tools** — see [Apps](#apps) or run `apps\New-Apps.ps1`.
2. **Set up the profile** — see [Profile](#profile) or run `profile\Setup-Profile.ps1` (Windows) / `profile/setup-profile.sh` (macOS/Linux).
3. **Configure system** _(optional, admin required)_ — see [System](#system).
4. **Set up backups** _(optional)_ — see [Backup](#backup).
5. **Link Windows Terminal settings** _(optional, admin required)_ — see [Terminal](#terminal).

## Profile

PowerShell startup profile and setup scripts, compatible with Windows PowerShell 5.1 and PowerShell 7 (Core).

### Profile files

| File | Description |
| ---- | ----------- |
| [`profile/profile.ps1`](profile/profile.ps1) | Main profile — Fastfetch, Starship, Zoxide, PSReadLine, aliases, eza/bat wrappers, env vars |
| [`profile/Setup-Profile.ps1`](profile/Setup-Profile.ps1) | Windows setup: creates hard links in `$PROFILE` locations for PS 7 and PS 5.1, copies Starship config |
| [`profile/setup-profile.sh`](profile/setup-profile.sh) | macOS / Linux setup: creates symlinks for the PowerShell profile |
| [`profile/.config/starship/starship.toml`](profile/.config/starship/starship.toml) | Bundled Starship prompt configuration (installed by `Setup-Profile.ps1`) |

### What the profile does

- **Fastfetch** — minimal system summary on startup (OS, shell, CPU, memory, uptime)
- **Starship** — initializes prompt with bundled `starship.toml`
- **Zoxide** — replaces `cd` with smart directory jumping (`z` / `zi`)
- **PSReadLine** — history predictions, list view, Tab menu, arrow-key history search
- **Aliases** — `Edit` → Notepad, `vim`/`v` → nvim, `y` → yazi
- **No Coreutils aliases** — the profile avoids overriding `ls`, `cat`, `grep`, and similar commands, which can break PowerShell pipelines
- **eza wrappers** — `l`, `ll`, `la`, `lla`, `lt` with icons, color, and git status
- **bat wrapper** — `cat` with syntax highlighting
- **Environment variables** — `Editor`, `MSYS2_ARG_CONV_EXCL`, `MSYS_NO_PATHCONV`, `YAZI_FILE_ONE`

### Profile setup

#### Windows

```powershell
profile\Setup-Profile.ps1
```

Creates hard links for both PowerShell 7 (`Documents\PowerShell`) and Windows PowerShell 5.1 (`Documents\WindowsPowerShell`), and copies Starship config to `~/.config/starship.toml`.

#### macOS / Linux

```bash
profile/setup-profile.sh
```

## Apps

Install a curated set of applications via **winget** and **Scoop**.

### Why Scoop?

Scoop covers what winget can't:

- No admin rights required — installs to user-space, so `-ScoopOnly` works on a locked-down machine.
- Ships packages winget doesn't have (or only has stale versions of), like `eza`, `yazi`, and Nerd Fonts.
- Portable installs under one folder, so updates and removals don't touch the system.

### Apps files

| File | Description |
| ---- | ----------- |
| [`apps/New-Apps.ps1`](apps/New-Apps.ps1) | Installs winget and Scoop packages; pass `-ScoopOnly` to skip winget |

### Apps usage

Full install (winget + Scoop):

```powershell
apps\New-Apps.ps1
```

Scoop-only (no winget, no admin required):

```powershell
apps\New-Apps.ps1 -ScoopOnly
```

### Packages installed

**winget** — 7-Zip, Bitwarden, Brave, Ditto, Total Commander, Git, IrfanView, TreeSize Free, lazygit, Microsoft Coreutils, PowerShell 7, Sysinternals, Teams, VS Code, Firefox, Nmap, Starship, portal, Python 3, Revo Uninstaller, Beyond Compare 5, Windows Terminal, Zen Browser, zoxide.

Coreutils is installed as a direct winget package; the profile intentionally avoids aliasing its GNU-style commands to prevent PowerShell pipeline conflicts.

**Scoop** (default buckets) — `btop`, `eza`, `fastfetch`, `fd`, `fzf`, `ghostscript`, `yazi`, `notepad3`, `sumatrapdf`, Delugia / FiraCode Nerd Fonts, lightshot.

## Backup

Scripts for backing up files and folders to OneDrive, with automatic archiving of older copies.

### Backup files

| File | Description |
| ---- | ----------- |
| [`backup/Backup-Target.ps1`](backup/Backup-Target.ps1) | Core backup engine — copies or zips a path to a destination, archives files older than a threshold |
| [`backup/Backup-Me.ps1`](backup/Backup-Me.ps1) | Pre-configured wrapper that backs up `$PROFILE` to `OneDrive\Settings\PowerShell` |

### Backup usage

Back up the PowerShell profile:

```powershell
backup\Backup-Me.ps1
```

Back up any path directly:

```powershell
backup\Backup-Target.ps1 -Path C:\path\to\source -DestinationPath C:\path\to\dest
backup\Backup-Target.ps1 -Path C:\path\to\file.json -DestinationPath C:\backup -Uncompressed -DateFormat "yyyy-MM-dd"
```

### Parameters for `Backup-Target.ps1`

| Parameter | Default | Description |
| --------- | ------- | ----------- |
| `-Path` | _(required)_ | Source file or folder |
| `-DestinationPath` | _(required)_ | Destination folder |
| `-DateFormat` | `yyyy-MM-dd.HH.mm.ss` | Timestamp format in output filename |
| `-KeepOld` | `$false` | Keep old backups instead of archiving them |
| `-ArchiveThreshHold` | `1` | Months before a backup is moved to `Archive/` |
| `-Uncompressed` | `$false` | Copy as-is instead of zipping |

> **Requires PowerShell 6+**

## Compress-This

Creates a timestamped 7-Zip archive of the current working directory, saved under `OneDrive\Backup\<folder-name>\`. Designed for quick repo snapshots before risky changes.

### Parameters

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `-Help` | switch | — | Display help and exit |
| `-WhatIf` | switch | — | Show what would be archived and where, without creating the archive |
| `-Dev` | switch | — | Exclude generated files and caches for a clean repo backup |
| `-Format` | `zip` \| `7z` | `zip` | Archive format |
| `-BACKUP_PATH` | string | `OneDrive\Backup` | Override output root |
| `-SevenZip` | string | `7z` | Path or name of 7-Zip executable |
| `-Pause` | switch | — | Wait for keypress before exit |

### Dev-mode exclusions

When `-Dev` is set, the following are excluded:

| Category | What's excluded |
| --- | --- |
| Git | `.git` |
| Build outputs | `bin`, `obj`, `build`, `dist`, `out` |
| Dependencies | `node_modules`, `packages` |
| IDE/tooling | `.vs`, `.idea` |
| Python | `__pycache__`, `.pytest_cache`, `.mypy_cache`, `.ruff_cache`, `.tox`, `.nox`, `venv`, `.venv`, `__pypackages__`, `*.egg-info`, `.eggs`, `*.pyc`, `*.pyo`, `*.pyd` |
| uv | `.uv` |
| Node.js / JS | `.next`, `.nuxt`, `.output`, `.cache`, `.parcel-cache`, `.yarn`, `.turbo`, `*.tsbuildinfo` |
| Fabric | `.fabric` |
| Obsidian | `.obsidian`, `.trash` |
| Marp | `.marp-cache` |
| PowerShell builds | `output`, `release` |
| Test / coverage | `coverage`, `htmlcov`, `TestResults` |
| Logs | `logs` |
| Binaries & symbols | `*.dll`, `*.exe`, `*.pdb`, `*.obj` and related |
| NuGet | `*.nupkg`, `*.snupkg` |
| OS/editor noise | `*.tmp`, `*.bak`, `*.swp`, `Thumbs.db`, `desktop.ini` |
| Secrets | `.env`, `.env.*` |

### Compress-This requirements

- [7-Zip](https://www.7-zip.org/) on `PATH` (`scoop install 7zip` or `winget install 7zip.7zip`)

### Compress-This setup

The bundled [profile.ps1](profile/profile.ps1) already includes a wrapper function — no extra steps needed if you're using that profile.

If you manage your profile separately, add this to it:

```powershell
if (Test-Path -LiteralPath "$HOME\Projects\contento\windows-scripts\compress-this\Compress-This.ps1") {
    function Compress-This {
        & "$HOME\Projects\contento\windows-scripts\compress-this\Compress-This.ps1" @args
    }
}
```

### Compress-This usage

```powershell
# Standard backup
Compress-This

# Dev backup (excludes generated files)
Compress-This -Dev

# Dev backup as .7z
Compress-This -Dev -Format 7z

# Custom backup path
Compress-This -Dev -BACKUP_PATH "D:\Backups"

# Dry run — shows output path without creating the archive
Compress-This -Dev -WhatIf

# Show help
Compress-This -Help
```

Output is saved as `<folder>_yyyyMMdd_HHmmss.<format>` inside `BACKUP_PATH\<folder>\`.

## System

One-time Windows system configuration: OpenSSH setup and user-folder symbolic links.

### System files

| File | Description |
| ---- | ----------- |
| [`system/Setup-SSH.ps1`](system/Setup-SSH.ps1) | Installs OpenSSH Server, starts `sshd` and `ssh-agent`, configures firewall rule |
| [`system/New-SymbolicLinks.ps1`](system/New-SymbolicLinks.ps1) | Creates symbolic links mapping `C:\Backup`, `C:\Music`, `C:\Temp`, etc. to OneDrive or `$HOME` targets |

### System usage

Both scripts require **Administrator** privileges.

#### OpenSSH

```powershell
system\Setup-SSH.ps1
```

Installs the OpenSSH Server Windows capability, sets both services to start automatically, and opens TCP port 22 in the firewall. Prints the SSH connection string at the end.

#### Symbolic links

```powershell
system\New-SymbolicLinks.ps1
```

Creates (or recreates) the following links:

| Link | Target |
| ---- | ------ |
| `C:\Backup` | `OneDrive\Backup` |
| `C:\Logs` | `$HOME\Logs` |
| `C:\Music` | `OneDrive\Music` |
| `C:\Photos` | `OneDrive\Photos` |
| `C:\Pictures` | `OneDrive\Pictures` |
| `C:\Videos` | `OneDrive\Videos` |
| `C:\Temp` | `$HOME\Temp` |
| `$HOME\Downloads\Material` | `OneDrive\Pictures\Material` |
| `$HOME\Downloads\Temp` | `$HOME\Temp` |
| `$HOME\Downloads\WIP` | `OneDrive\WIP` |

Target directories are created automatically if they don't exist. Existing symbolic links at the source path are replaced; non-link items are skipped with a warning.

## Terminal

Version-controlled Windows Terminal `settings.json`, symlinked into place.

### Terminal files

| File | Description |
| ---- | ----------- |
| [`terminal/Setup-Terminal.ps1`](terminal/Setup-Terminal.ps1) | Creates a symbolic link from Windows Terminal's real settings.json to the bundled copy in this repo |
| [`terminal/.config/windows-terminal/settings.json`](terminal/.config/windows-terminal/settings.json) | Bundled Windows Terminal settings (profiles, color schemes, keybindings) |

### Terminal usage

```powershell
terminal\Setup-Terminal.ps1
```

Requires **Administrator** privileges or Developer Mode enabled, since creating a symbolic link otherwise requires elevation.

Targets the packaged/Store install of Windows Terminal:

```text
%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
```

Because the file is a symbolic link rather than a copy, edits made through the Windows Terminal UI (color schemes, keybindings, new profiles) are written straight back into the repo copy — commit them like any other change.

# Compress-This

Creates a timestamped 7-Zip archive of the current working directory, saved under `OneDrive\Backup\<folder-name>\`. Designed for quick repo snapshots before risky changes.

## Parameters

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `-Help` | switch | — | Display help and exit |
| `-WhatIf` | switch | — | Show what would be archived and where, without creating the archive |
| `-Dev` | switch | — | Exclude generated files and caches for a clean repo backup |
| `-Format` | `zip` \| `7z` | `zip` | Archive format |
| `-BACKUP_PATH` | string | `OneDrive\Backup` | Override output root |
| `-SevenZip` | string | `7z` | Path or name of 7-Zip executable |
| `-Pause` | switch | — | Wait for keypress before exit |

## Dev-mode exclusions

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

## Requirements

- [7-Zip](https://www.7-zip.org/) on `PATH` (`scoop install 7zip` or `winget install 7zip.7zip`)

## Setup

The bundled [profile.ps1](../profile/profile.ps1) already includes a wrapper function — no extra steps needed if you're using that profile.

If you manage your profile separately, add this to it:

```powershell
if (Test-Path -LiteralPath "$HOME\Projects\contento\windows-scripts\compress-this\Compress-This.ps1") {
    function Compress-This {
        & "$HOME\Projects\contento\windows-scripts\compress-this\Compress-This.ps1" @args
    }
}
```

## Usage

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

# PowerShell Profile

```text
  o  o
\______/
  |
     |    https://conten.to
--------
```

A portable PowerShell profile kept in version control, compatible with both Windows PowerShell 5.1 and PowerShell 7 (Core). Useful on machines where `$PROFILE` is unavailable, disabled, or write-protected.

## What it does

- **Fastfetch** — prints a minimal system summary on startup (OS, shell, CPU, memory, uptime)
- **Starship** — initializes the Starship prompt with bundled configuration (`.config/starship/starship.toml`)
- **Zoxide** — replaces `cd` with smart directory jumping (`z` / `zi`)
- **PSReadLine** — enables history-based inline predictions, list view, Tab menu completion, and arrow-key history search
- **Aliases** — `Edit` → Notepad, `vim`/`v` → nvim, `y` → yazi
- **eza wrappers** — `l`, `ll`, `la`, `lla`, `lt` with icons, color, and git status
- **bat wrapper** — `cat` with syntax highlighting
- **Environment variables** — sets `Editor`, `MSYS2_ARG_CONV_EXCL`, `MSYS_NO_PATHCONV`, `YAZI_FILE_ONE`

## Prerequisites

### Option 1 — winget

```powershell
winget install fastfetch-cli.fastfetch Starship.Starship ajeetdsouza.zoxide eza-community.eza sharkdp.bat sxyazi.yazi Neovim.Neovim
```

### Option 2 — Scoop

If Scoop is not installed yet:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod get.scoop.sh | Invoke-Expression
```

Then install the packages:

```powershell
scoop install fastfetch starship zoxide eza bat yazi neovim
```

## Setup

### Windows (PowerShell 7 + Windows PowerShell 5.1)

Run `Setup-Profile.ps1` from the repo to automatically create hard links in both PowerShell's $PROFILE locations:

```powershell
.\Setup-Profile.ps1
```

### macOS / Linux

Run `setup-profile.sh` from the repo:

```bash
./setup-profile.sh
```

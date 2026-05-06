# Pwsh-Profile

A portable PowerShell profile kept in version control, compatible with both Windows PowerShell 5.1 and PowerShell 7 (Core). Useful on machines where `$PROFILE` is unavailable, disabled, or write-protected.

## What it does

- **Fastfetch** — prints a minimal system summary on startup (OS, shell, CPU, memory, uptime)
- **Starship** — initializes the Starship prompt
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

### PowerShell 7 (Core)

**Option 1 — load without touching `$PROFILE`**

```powershell
"$Env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -NoExit -File "$Env:OneDrive\scripts\Pwsh-Profile.ps1"
```

**Option 2 — hard-link + dot-source from `$PROFILE`**

`$PROFILE` resolves to `%USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`

```powershell
cmd /c mklink /H "$Env:OneDrive\Scripts\Pwsh-Profile.ps1" "$HOME\Projects\contento\windows-scripts\Pwsh-Profile.ps1"
```

Then add to `$PROFILE`:

```powershell
. "$Env:OneDrive\Scripts\Pwsh-Profile.ps1"
```

### Windows PowerShell 5.1

**Option 1 — load without touching `$PROFILE`**

```powershell
"$Env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -NoExit -File "$Env:OneDrive\scripts\Pwsh-Profile.ps1"
```

**Option 2 — hard-link + dot-source from `$PROFILE`**

`$PROFILE` resolves to `%USERPROFILE%\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1`

```powershell
cmd /c mklink /H "$Env:OneDrive\Scripts\Pwsh-Profile.ps1" "$HOME\Projects\contento\windows-scripts\Pwsh-Profile.ps1"
```

Then add to `$PROFILE`:

```powershell
. "$Env:OneDrive\Scripts\Pwsh-Profile.ps1"
```

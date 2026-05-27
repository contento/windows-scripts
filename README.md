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
| [system/](system/) | One-time system setup: OpenSSH and user-folder symbolic links |

## Quick start

1. **Install tools** — see [apps/README.md](apps/README.md) or run `apps\New-Apps.ps1`.
2. **Set up the profile** — see [profile/README.md](profile/README.md) or run `profile\Setup-Profile.ps1` (Windows) / `profile/setup-profile.sh` (macOS/Linux).
3. **Configure system** _(optional, admin required)_ — see [system/README.md](system/README.md).
4. **Set up backups** _(optional)_ — see [backup/README.md](backup/README.md).

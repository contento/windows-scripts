# Backup

Scripts for backing up files and folders to OneDrive, with automatic archiving of older copies.

## Files

| File | Description |
|------|-------------|
| [`Backup-Target.ps1`](Backup-Target.ps1) | Core backup engine — copies or zips a path to a destination, archives files older than a threshold |
| [`Backup-Me.ps1`](Backup-Me.ps1) | Pre-configured wrapper that backs up `$PROFILE` to `OneDrive\Settings\PowerShell` |

## Usage

### Back up the PowerShell profile

```powershell
.\Backup-Me.ps1
```

### Back up any path directly

```powershell
.\Backup-Target.ps1 -Path C:\path\to\source -DestinationPath C:\path\to\dest
.\Backup-Target.ps1 -Path C:\path\to\file.json -DestinationPath C:\backup -Uncompressed -DateFormat "yyyy-MM-dd"
```

### Parameters for `Backup-Target.ps1`

| Parameter | Default | Description |
|-----------|---------|-------------|
| `-Path` | _(required)_ | Source file or folder |
| `-DestinationPath` | _(required)_ | Destination folder |
| `-DateFormat` | `yyyy-MM-dd.HH.mm.ss` | Timestamp format in output filename |
| `-KeepOld` | `$false` | Keep old backups instead of archiving them |
| `-ArchiveThreshHold` | `1` | Months before a backup is moved to `Archive/` |
| `-Uncompressed` | `$false` | Copy as-is instead of zipping |

> **Requires PowerShell 6+**

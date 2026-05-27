# System

One-time Windows system configuration: OpenSSH setup and user-folder symbolic links.

## Files

| File | Description |
|------|-------------|
| [`Setup-SSH.ps1`](Setup-SSH.ps1) | Installs OpenSSH Server, starts `sshd` and `ssh-agent`, configures firewall rule |
| [`New-SymbolicLinks.ps1`](New-SymbolicLinks.ps1) | Creates symbolic links mapping `C:\Backup`, `C:\Music`, `C:\Temp`, etc. to OneDrive or `$HOME` targets |

## Usage

Both scripts require **Administrator** privileges.

### OpenSSH

```powershell
.\Setup-SSH.ps1
```

Installs the OpenSSH Server Windows capability, sets both services to start automatically, and opens TCP port 22 in the firewall. Prints the SSH connection string at the end.

### Symbolic links

```powershell
.\New-SymbolicLinks.ps1
```

Creates (or recreates) the following links:

| Link | Target |
|------|--------|
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

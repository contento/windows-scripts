# windows-scripts

Nothing fancy: just classical scripts for Windows.

## Prerequisites

```sh
winget install git.git
```

Also, 

- Make sure SSH Open Server Agent is enabled.
- If you get errors because of your ssh client, see below.

### Open SSH and Git

```sh
Cloning into '{{repository}}'...
git@bitbucket.org: Permission denied (publickey).
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.
```

Use:

```sh
git config --global core.sshCommand c:/Windows/System32/OpenSSH/ssh.exe
# you may need to change the config if you are having buffering issues
#  git config --global core. Compression 0
```

## New-Apps

Install a bunch of apps

## Backup-Me.ps1

For example, to backup your PowerShell profile:

```powershell
    notepad $PROFILE # just checking
    ./Backup-Me.ps1  # the script

```

> Depends on `Backup-Target.ps1`

<#
.SYNOPSIS
  Create symbolic links for common user folders.

.DESCRIPTION
  This script ensures configured target directories exist and creates
  symbolic links for user folders such as Backup, Music, Pictures, and Temp.

.NOTES
  FileName: New-SymbolicLinks.ps1
  GitHub: https://github.com/contento
#>
#requires -RunAsAdministrator

if ($PSVersionTable.Platform -eq 'Unix') {
    Write-Host 'This script is intended for Windows PowerShell only.' -ForegroundColor Red
    exit 1
}

function Write-Info {
    param([string]$Message)
    Write-Host $Message -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host $Message -ForegroundColor Green
}

function Write-WarningLine {
    param([string]$Message)
    Write-Host $Message -ForegroundColor Yellow
}

function Write-ErrorLine {
    param([string]$Message)
    Write-Host $Message -ForegroundColor Red
}

$LinkInfo = @{
    'C:\Backup'                = "$Env:OneDriveConsumer\Backup";
    'C:\Logs'                  = "$Home\Logs";
    'C:\Music'                 = "$Env:OneDriveConsumer\Music";
    'C:\Photos'                = "$Env:OneDriveConsumer\Photos";
    'C:\Pictures'              = "$Env:OneDriveConsumer\Pictures";
    'C:\Videos'                = "$Env:OneDriveConsumer\Videos";
    'C:\Temp'                  = "$Home\Temp";
    "$Home\Downloads\Material" = "$Env:OneDriveConsumer\Pictures\Material";
    "$Home\Downloads\Temp"     = "$Home\Temp";
    "$Home\Downloads\WIP"      = "$Env:OneDriveConsumer\WIP";
}

foreach ($entry in $LinkInfo.GetEnumerator()) {
    $path = $entry.Key
    $target = $entry.Value

    if (-not (Test-Path -Path $target -PathType Container)) {
        Write-Info "**** Creating directory: $target"
        New-Item -ItemType Directory -Path $target -ErrorAction Stop | Out-Null
    }

    $existing = Get-Item -LiteralPath $path -ErrorAction SilentlyContinue
    if ($existing) {
        if ($existing.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
            Write-Info "Removing existing symbolic link: $path"
            Remove-Item -LiteralPath $path -Force -Recurse -ErrorAction Stop
        }
        else {
            Write-WarningLine "Skipping: non-link item exists at $path"
            continue
        }
    }

    Write-Success "Creating symbolic link: $path -> $target"
    try {
        New-Item -ItemType SymbolicLink -Path $path -Target $target -ErrorAction Stop | Out-Null
    }
    catch {
        Write-WarningLine ("Failed to create symbolic link for '{0}' -> '{1}': {2}" -f $path, $target, $_.Exception.Message)
    }
}

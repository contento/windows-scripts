<#
.SYNOPSIS
  Symlinks the bundled Windows Terminal settings.json into place.

.DESCRIPTION
  Points Windows Terminal's settings.json (packaged/Store install) at the
  version-controlled copy in this repo via a symbolic link, so changes made
  through the Windows Terminal UI and edits made in the repo stay in sync.

.NOTES
  Requires administrator privileges or Developer Mode enabled, since creating
  a symbolic link otherwise requires elevation.
#>

$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$SettingsSource = Join-Path $ScriptRoot '.config' 'windows-terminal' 'settings.json'
$SettingsDir = Join-Path $env:LOCALAPPDATA 'Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState'
$SettingsTarget = Join-Path $SettingsDir 'settings.json'

if (-not (Test-Path $SettingsSource)) {
    Write-Error "Bundled settings.json not found at: $SettingsSource"
    exit 1
}

if (-not (Test-Path $SettingsDir)) {
    Write-Error "Windows Terminal LocalState folder not found at: $SettingsDir (is the packaged/Store version installed?)"
    exit 1
}

$existing = Get-Item -LiteralPath $SettingsTarget -ErrorAction SilentlyContinue
if ($existing) {
    if ($existing.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
        Write-Host "Removing existing symbolic link: $SettingsTarget"
        Remove-Item -LiteralPath $SettingsTarget -Force
    }
    else {
        Write-Host "Windows Terminal settings.json already exists at: $SettingsTarget"
        $response = Read-Host "Overwrite? (y/n)"
        if ($response -ne 'y') {
            Write-Host "Skipped."
            exit 0
        }
        Remove-Item -LiteralPath $SettingsTarget -Force
    }
}

Write-Host "Creating symbolic link: $SettingsTarget -> $SettingsSource"
try {
    New-Item -ItemType SymbolicLink -Path $SettingsTarget -Target $SettingsSource -ErrorAction Stop | Out-Null
    Write-Host "✓ Windows Terminal settings linked successfully"
}
catch {
    Write-Error "Failed to create symbolic link (try running as Administrator or enable Developer Mode): $($_.Exception.Message)"
    exit 1
}

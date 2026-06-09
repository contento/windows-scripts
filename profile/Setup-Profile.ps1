<#
.SYNOPSIS
  Sets up PowerShell profile hard links for both PowerShell 7 and Windows PowerShell 5.1.

.DESCRIPTION
  Creates hard links in the standard $PROFILE locations that point to Pwsh-Profile.ps1 in this repo.
  Ensures the necessary directories exist before creating links.

.NOTES
  Run this with administrator privileges or from a location where you have write access to Documents.
#>

$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProfileSource = Join-Path $ScriptRoot 'profile.ps1'

if (-not (Test-Path $ProfileSource)) {
    Write-Error "Pwsh-Profile.ps1 not found at: $ProfileSource"
    exit 1
}

# PowerShell 7 (Core)
$DocumentsPath = [Environment]::GetFolderPath('MyDocuments')
$PS7ProfileDir = Join-Path $DocumentsPath 'PowerShell'
$PS7Profile = Join-Path $PS7ProfileDir 'Microsoft.PowerShell_profile.ps1'

# Windows PowerShell 5.1
$PS5ProfileDir = Join-Path $DocumentsPath 'WindowsPowerShell'
$PS5Profile = Join-Path $PS5ProfileDir 'Microsoft.PowerShell_profile.ps1'

function Setup-ProfileLink {
    param(
        [string]$ProfileDir,
        [string]$ProfilePath,
        [string]$VersionName
    )

    if (-not (Test-Path $ProfileDir)) {
        Write-Host "Creating directory: $ProfileDir"
        New-Item -ItemType Directory -Path $ProfileDir -Force | Out-Null
    }

    if (Test-Path $ProfilePath) {
        Write-Host "$VersionName profile already exists at: $ProfilePath"
        $response = Read-Host "Overwrite? (y/n)"
        if ($response -ne 'y') {
            Write-Host "Skipped."
            return
        }
        Remove-Item $ProfilePath -Force
    }

    Write-Host "Creating hard link for $VersionName..."
    cmd /c mklink /H "$ProfilePath" "$ProfileSource" | Out-Null

    if (Test-Path $ProfilePath) {
        Write-Host "✓ $VersionName profile linked successfully"
    } else {
        Write-Error "Failed to create link for $VersionName"
    }
}

function Initialize-StarshipConfig {
    $StarshipSource = Join-Path $ScriptRoot '.config' 'starship' 'starship.toml'
    $StarshipConfigDir = Join-Path $HOME '.config'
    $StarshipConfigPath = Join-Path $StarshipConfigDir 'starship.toml'

    if (-not (Test-Path $StarshipSource)) {
        Write-Host "⚠ Starship config not found at: $StarshipSource"
        return
    }

    if (-not (Test-Path $StarshipConfigDir)) {
        Write-Host "Creating directory: $StarshipConfigDir"
        New-Item -ItemType Directory -Path $StarshipConfigDir -Force | Out-Null
    }

    if (Test-Path $StarshipConfigPath) {
        Write-Host "Starship config already exists at: $StarshipConfigPath"
        $response = Read-Host "Overwrite? (y/n)"
        if ($response -ne 'y') {
            Write-Host "Skipped."
            return
        }
        Remove-Item $StarshipConfigPath -Force
    }

    Copy-Item $StarshipSource $StarshipConfigPath
    Write-Host "✓ Starship config copied successfully"
}

Write-Host "Setting up PowerShell profiles..."
Write-Host "Source: $ProfileSource`n"

Setup-ProfileLink -ProfileDir $PS7ProfileDir -ProfilePath $PS7Profile -VersionName "PowerShell 7 (Core)"
Setup-ProfileLink -ProfileDir $PS5ProfileDir -ProfilePath $PS5Profile -VersionName "Windows PowerShell 5.1"

Write-Host "`nSetting up Starship config..."
Initialize-StarshipConfig

Write-Host "`nDone!"

<#
.SYNOPSIS
  Script to install various applications using winget and Scoop.

.DESCRIPTION
  This script sets the execution policy for the current user to unrestricted,
  installs a predefined list of applications using winget, checks for Scoop installation,
  and installs Scoop along with a predefined list of applications and fonts.

.NOTES
  FileName: New-Apps.ps1
  Author: Gonzalo Contento
#>

$wingetPackages = @{
  "nullStore" = @(
    "7zip.7zip",
    "Bitwarden.Bitwarden",
    "Brave.Brave",
    "Ditto.Ditto",
    "ghisler.totalcommander",
    "git.git",
    "IrfanSkiljan.IrfanView",
    "JAMSoftware.TreeSize.Free",
    "JesseDuffield.lazygit",
    "Microsoft.PowerShell",
    "Microsoft.SysInternals",
    "Microsoft.Teams",
    "Microsoft.VisualStudioCode",
    "mozilla.firefox",
    "Insecure.Nmap",
    "Starship.Starship",
    "SpatiumPortae.portal",
    "Python.Python.3",
    "RevoUninstaller.RevoUninstaller",
    "Rustlang.Rustup",
    "ScooterSoftware.BeyondCompare.5",
    "Microsoft.WindowsTerminal",
    "Zen-Team.Zen-Browser",
    "zoxide"
  )
}

$scoopPackages = @{
  "default"    = @(
    "btop",  
    "eza", 
    "fzf", 
    "ghostscript",
    "yazi"); 
  "extras"     = @("notepad3");
  "nerd-fonts" = @("Delugia-Nerd-Font-Complete", "Firacode", "Firacode-NF");
  "versions"   = @("lightshot");
}

$cargoPackages = @(
  "pfetch"
)

function Set-ExecutionPolicyForCurrentUser {
  Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
}

function Install-WingetPackages {
  param (
    [Parameter(Mandatory = $true)]
    [hashtable]$Packages
  )

  Write-Host "[****] Installing winget packages..."

  $Packages.Keys | Sort-Object | ForEach-Object {
    $source = $_
    $sourceArgs = if ($source -ne "nullStore") { @("--source", $source) } else { @() }
    $Packages[$source] | Sort-Object | ForEach-Object {
      winget install $_ @sourceArgs --silent --accept-package-agreements --accept-source-agreements
    }
  }
}

function Install-ScoopPackages {
  param (
    [Parameter(Mandatory = $true)]
    [hashtable]$Packages
  )

  Write-Host "[****] Installing Scoop packages..."

  if (-not (Get-Command "scoop" -ErrorAction SilentlyContinue)) {
    # Security note: downloads and executes a remote script
    Invoke-Expression "& {$(Invoke-RestMethod get.scoop.sh)} -RunAsAdmin"
    # Refresh PATH so scoop is available in the current session
    $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" +
                [System.Environment]::GetEnvironmentVariable("PATH", "User")
  }

  $Packages.Keys | Sort-Object | ForEach-Object {
    $bucket = $_
    if ($bucket -ne "default") {
      scoop bucket add $bucket
    }
    $Packages[$bucket] | ForEach-Object {
      scoop install $_
    }
  }
}

function Install-CargoPackages {
  param (
    [string[]]$Packages
  )

  if (-not (Get-Command "cargo" -ErrorAction SilentlyContinue)) {
    Write-Warning "cargo not found. Ensure rustup is installed and restart your shell first."
    return
  }

  Write-Host "[****] Installing Cargo packages..."
  foreach ($package in $Packages) {
    cargo install $package
  }
}

####################################################################################################
# Main script execution
Set-ExecutionPolicyForCurrentUser

Install-WingetPackages -Packages $wingetPackages

Install-ScoopPackages -Packages $scoopPackages

Install-CargoPackages -Packages $cargoPackages

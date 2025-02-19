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
  Version: 2.0
  Date: 2024-05-14
#>

$wingetPackages = @{
  "nullStore" = @(
    "7zip.7zip",
    "Bitwarden.Bitwarden",
    "Brave.Brave",
    "Ditto.Ditto",
    "ghisler.totalcommander",
    "git.git",
    "gokcehan.lf",
    "IrfanSkiljan.IrfanView",
    "JAMSoftware.TreeSize.Free",
    "lazygit",
    "Microsoft.PowerShell",
    "Microsoft.RemoteDesktopClient",
    "Microsoft.Teams",
    "Microsoft.VisualStudioCode"
    "mozilla.firefox",
    "Neovim",
    "nmap",
    "Notepad++.Notepad++",
    "starship", 
    "SpatiumPortae.portal",
    "Python.Python.3",
    "Rustlang.Rustup",
    "ScooterSoftware.BeyondCompare.5",
    "SysInternals",
    "Zen-Team.Zen-Browser",
    "zoxide"
  );
  "msstore" = @(
    "Microsoft.WindowsTerminal"
  )
}

$scoopPackages = @{
  "default"    = @(
    "btop",  
    "eza", 
    "fzf", 
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

  "[****] Installing winget packages..."

  $Packages.nullStore | Sort-Object | ForEach-Object {
    winget install $_ --silent
  }

  $Packages.msstore | Sort-Object | ForEach-Object {
    winget install $_ --source msstore --silent
  }
}

function Install-ScoopPackages {
  param (
    [Parameter(Mandatory = $true)]
    [hashtable]$Packages
  )

  "[****] Installing Scoop packages..."

  if (-not (Get-Command "scoop" -ErrorAction SilentlyContinue)) {
    Invoke-Expression "& {$(Invoke-RestMethod get.scoop.sh)} -RunAsAdmin"
  }

  $Packages.Keys | Sort-Object | ForEach-Object {
    $bucket = $_
    if ($bucket -ne "default") {
      scoop bucket add $bucket
    }
    $Packages[$_].ForEach({
        scoop install $_
      })
  }
}

function Install-CargoPackages {
    param (
        [string[]]$Packages
    )

    foreach ($package in $Packages) {
        Write-Host "Installing Cargo package: $package"
        cargo install $package
    }
}

####################################################################################################
# Main script execution
Set-ExecutionPolicyForCurrentUser

Install-WingetPackages -Packages $wingetPackages

Install-ScoopPackages -Packages $scoopPackages

Install-CargoPackages -Packages $cargoPackages

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

function Install-ScoopAndPackages {
  param (
    [Parameter(Mandatory = $true)]
    [hashtable]$BucketAndPackages
  )

  "[****] Installing Scoop and packages..."

  if (-not (Get-Command "scoop" -ErrorAction SilentlyContinue)) {
    iex "& {$(Invoke-RestMethod get.scoop.sh)} -RunAsAdmin"
  }

  $BucketAndPackages.Keys | Sort-Object | ForEach-Object {
    $bucket = $_
    if ($bucket -ne "default") {
      scoop bucket add $bucket
    }
    $BucketAndPackages[$_].ForEach({
        scoop install $_
      })
  }
}

# Main script execution
Set-ExecutionPolicyForCurrentUser

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
    "mozilla.firefox",
    "Neovim",
    "nmap",
    "Notepad++.Notepad++",
    "portal",
    "Python.Python.3",
    "ScooterSoftware.BeyondCompare.5",
    "SysInternals",
    "zoxide",
    "Microsoft.VisualStudioCode"
  );
  "msstore" = @(
    "Microsoft.WindowsTerminal"
  )
}

Install-WingetPackages -Packages $wingetPackages

$bucketAndPackages = @{
  "default"    = @(
    "btop",  
    "eza", 
    "fzf", 
    "starship", 
    "yazi"); 
  "extras"     = @("notepad3");
  "nerd-fonts" = @("Delugia-Nerd-Font-Complete", "Firacode", "Firacode-NF");
  "versions"   = @("lightshot");
}

Install-ScoopAndPackages -BucketAndPackages $bucketAndPackages

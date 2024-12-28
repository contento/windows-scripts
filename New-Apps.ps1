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

  $Packages.Keys | Sort-Object | ForEach-Object {
    if ($null -ne $Packages[$_]) {
      winget install $_ --source $Packages[$_] --silent
    }
    else {
      winget install $_ --silent
    }
  }
}

function Install-ScoopAndPackages {
  param (
    [Parameter(Mandatory = $true)]
    [hashtable]$BucketAndPackages
  )

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
  "7zip.7zip"                       = $null;
  "ScooterSoftware.BeyondCompare.5" = $null;
  "Bitwarden.Bitwarden"             = $null;
  "Brave.Brave"                     = $null;
  "Ditto.Ditto"                     = $null;
  "ghisler.totalcommander"          = $null;
  "gokcehan.lf"                     = $null;
  "git.git"                         = $null;
  "IrfanSkiljan.IrfanView"          = $null;
  "JAMSoftware.TreeSize.Free"       = $null;
  "lazygit"                         = $null;
  "Microsoft.PowerShell"            = $null;
  "Microsoft.RemoteDesktopClient"   = $null;
  "Microsoft.Teams"                 = $null;
  "Microsoft.WindowsTerminal"       = "msstore";
  "Neovim"                          = $null;
  "nmap"                            = $null;
  "Notepad++.Notepad++"             = $null;
  "mozilla.firefox"                 = $null;
  "portal"                          = $null; 
  "zoxide"                          = $null;
  "Python.Python.3"                 = $null;
  "SysInternals"                    = $null;
  "Microsoft.VisualStudioCode"      = $null;
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

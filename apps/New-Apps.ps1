<#
.SYNOPSIS
  Script to install various applications using winget and Scoop.

.DESCRIPTION
  This script sets the execution policy for the current user, installs a predefined
  list of applications using winget, and installs Scoop packages.

  Use -ScoopOnly to skip winget and run in user-scope Scoop-only mode.

.NOTES
  FileName: New-Apps.ps1
  GitHub: https://github.com/contento
#>

param(
    [switch]$ScoopOnly
)

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
        "Microsoft.Coreutils",  # uutils/findutils/grep multicall; no profile aliases by design (PS alias table beats PATH; rg/bat/eza already cover grep/cat/ls)
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
        "fastfetch",
        "fzf",
        "ghostscript",
        "yazi");
    "extras"     = @("notepad3");
    "nerd-fonts" = @("Delugia-Nerd-Font-Complete", "Firacode", "FiraCode-NF");
    "versions"   = @("lightshot");
}

$scoopOnlyPackages = @{
    "main" = @(
        "btop",
        "eza",
        "fastfetch",
        "fzf",
        "ghostscript",
        "yazi",
        "zoxide",
        "git",
        "python"
    );
    "extras"     = @(
        "notepad3",
        "windows-terminal",
        "vscode"
    );
    "versions"   = @("lightshot");
    "nerd-fonts" = @(
        "Delugia-Nerd-Font-Complete",
        "FiraCode",
        "FiraCode-NF"
    );
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

function Set-ExecutionPolicyForCurrentUser {
    param([switch]$ScoopOnly)

    if ($ScoopOnly) {
        Write-Info 'Setting execution policy for Scoop-only mode...'
        Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
        Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
        Write-Success 'Execution policy configured for Scoop-only mode.'
    }
    else {
        Write-Info 'Setting execution policy for the current user...'
        Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser -Force
        Write-Success 'Execution policy set.'
    }
}

function Install-WingetPackages {
    param (
        [Parameter(Mandatory = $true)]
        [hashtable]$Packages
    )

    if (-not (Get-Command "winget" -ErrorAction SilentlyContinue)) {
        Write-ErrorLine 'winget is not available on this machine. Aborting winget package installation.'
        return
    }

    Write-Info '[****] Installing winget packages...'

    $Packages.Keys | Sort-Object | ForEach-Object {
        $source = $_
        $sourceArgs = if ($source -ne "nullStore") { @("--source", $source) } else { @() }
        $Packages[$source] | Sort-Object | ForEach-Object {
            $pkg = $_
            try {
                winget install $pkg @sourceArgs --silent --accept-package-agreements --accept-source-agreements -e
                # winget signals failure via exit code, not a thrown exception.
                # Common non-error codes: 0 = installed, -1978335189 = already installed, -1978335212 = no applicable update.
                if ($LASTEXITCODE -in @(0, -1978335189, -1978335212)) {
                    Write-Success "Installed winget package: $pkg"
                }
                else {
                    Write-WarningLine "Failed to install winget package ${pkg} (exit code $LASTEXITCODE)."
                }
            }
            catch {
                Write-WarningLine "Failed to install winget package ${pkg}: $($_.Exception.Message)"
            }
        }
    }
}

function Install-ScoopIfMissing {
    param([switch]$ScoopOnly)

    if (Get-Command scoop -ErrorAction SilentlyContinue) {
        Write-Success 'Scoop is already installed.'
        return $true
    }

    Write-Info 'Scoop not found; installing Scoop...'
    try {
        if ($ScoopOnly) {
            Invoke-Expression "& {$(Invoke-RestMethod get.scoop.sh)}"
        }
        else {
            Invoke-Expression "& {$(Invoke-RestMethod get.scoop.sh)} -RunAsAdmin"
        }
        Write-Success 'Scoop installed successfully.'
    }
    catch {
        Write-ErrorLine "Failed to install Scoop: $($_.Exception.Message)"
        return $false
    }

    $env:PATH = [System.Environment]::GetEnvironmentVariable('PATH', 'Machine') + ';' +
        [System.Environment]::GetEnvironmentVariable('PATH', 'User')

    return $true
}

function Install-ScoopPackages {
    param (
        [Parameter(Mandatory = $true)]
        [hashtable]$Packages
    )

    if (-not (Install-ScoopIfMissing -ScoopOnly:$ScoopOnly)) {
        return
    }

    Write-Info '[****] Installing Scoop packages...'

    foreach ($bucket in ($Packages.Keys | Sort-Object)) {
        if ($bucket -notin @('default', 'main')) {
            $isAdded = (scoop bucket list | Select-String -Pattern "^$bucket$" -Quiet)
            if (-not $isAdded) {
                Write-Info "Adding Scoop bucket: $bucket"
                try {
                    scoop bucket add $bucket
                }
                catch {
                    Write-WarningLine "Failed to add Scoop bucket ${bucket}: $($_.Exception.Message)"
                }
            }
            else {
                Write-Info "Bucket already added: $bucket"
            }
        }

        Write-Info "──── $bucket ────"
        foreach ($pkg in ($Packages[$bucket] | Sort-Object)) {
            try {
                scoop install $pkg
                Write-Success "Installed Scoop package: $pkg"
            }
            catch {
                Write-WarningLine "Failed to install Scoop package ${pkg}: $($_.Exception.Message)"
            }
        }
    }
}

####################################################################################################
# Main script execution
Set-ExecutionPolicyForCurrentUser -ScoopOnly:$ScoopOnly

if (-not $ScoopOnly) {
    Install-WingetPackages -Packages $wingetPackages
}

$packagesToInstall = if ($ScoopOnly) { $scoopOnlyPackages } else { $scoopPackages }
Install-ScoopPackages -Packages $packagesToInstall

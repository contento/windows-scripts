<#
.SYNOPSIS
  Install applications using Scoop only (no admin access required).

.DESCRIPTION
  - Sets execution policy for the current user (Process/CurrentUser only)
  - Installs Scoop in user scope if missing
  - Adds required buckets
  - Installs predefined Scoop packages and fonts

.NOTES
  FileName: New-Apps-ScoopOnly.ps1
  Author: Gonzalo Contento
  Admin rights: NOT required
#>

# ── Output helpers ─────────────────────────────────────────────────────────────
function Write-Info ([string]$Msg) { Write-Host ' [info] ' -ForegroundColor Cyan     -NoNewline; Write-Host $Msg }
function Write-Ok   ([string]$Msg) { Write-Host ' [ ok ] ' -ForegroundColor Green    -NoNewline; Write-Host $Msg }
function Write-Warn ([string]$Msg) { Write-Host ' [warn] ' -ForegroundColor Yellow   -NoNewline; Write-Host $Msg }
function Write-Err  ([string]$Msg) { Write-Host ' [err!] ' -ForegroundColor Red      -NoNewline; Write-Host $Msg }
function Write-Step ([string]$Msg) { Write-Host ' [ >> ] ' -ForegroundColor DarkCyan -NoNewline; Write-Host $Msg }

# ── Configuration ──────────────────────────────────────────────────────────────
$scoopPackages = @{
  "main"       = @(
    "btop",
    "eza",
    "fastfetch",
    "fzf",
    "ghostscript",
    "yazi",
    "zoxide",
    "git",
    "python"
  )
  "extras"     = @(
    "notepad3",
    "windows-terminal", # confirm if your company already installs it
    "vscode"
  )
  "versions"   = @(
    "lightshot"
  )
  "nerd-fonts" = @(
    "Delugia-Nerd-Font-Complete",
    "FiraCode",
    "FiraCode-NF"
  )
}

# ── Functions ──────────────────────────────────────────────────────────────────
function Set-ExecutionPolicyForCurrentUser {
    Write-Step "Setting execution policy (Process: Bypass / CurrentUser: RemoteSigned)"
    Set-ExecutionPolicy -Scope Process     -ExecutionPolicy Bypass        -Force
    Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned  -Force
    Write-Ok "Execution policy set"
}

function Ensure-ScoopInstalled {
    if (Get-Command scoop -ErrorAction SilentlyContinue) {
        Write-Ok "Scoop already installed"
        $env:PATH = [Environment]::GetEnvironmentVariable('PATH', 'User')
        return
    }
    Write-Step "Installing Scoop (user scope, no admin)"
    Invoke-RestMethod https://get.scoop.sh | Invoke-Expression
    $env:PATH = [Environment]::GetEnvironmentVariable('PATH', 'User')
    Write-Ok "Scoop installed"
}

function Install-ScoopPackages {
    param(
        [Parameter(Mandatory)]
        [hashtable]$Packages
    )

    Write-Step "Installing packages"

    foreach ($bucket in ($Packages.Keys | Sort-Object)) {
        if ($bucket -ne 'main') {
            if (-not (scoop bucket list | Select-String "^$bucket$")) {
                Write-Info "Adding bucket: $bucket"
                scoop bucket add $bucket
            } else {
                Write-Info "Bucket already added: $bucket"
            }
        }

        Write-Info "──── $bucket ────"
        foreach ($pkg in ($Packages[$bucket] | Sort-Object)) {
            scoop install $pkg
        }
    }

    Write-Ok "All packages installed"
}

# ── Main ───────────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "  Workstation Bootstrap" -ForegroundColor Cyan
Write-Host "  Scoop · user scope · no admin" -ForegroundColor DarkGray
Write-Host ""

Set-ExecutionPolicyForCurrentUser
Ensure-ScoopInstalled
Install-ScoopPackages -Packages $scoopPackages

Write-Host ""
Write-Ok "Done. Run 'scoop update *' anytime to upgrade."
Write-Host ""

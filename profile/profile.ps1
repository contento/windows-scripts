<#
.SYNOPSIS
  Portable PowerShell startup profile for locked-down or temporary environments.

.DESCRIPTION
  Keeps PowerShell startup configuration in version control and makes it easy to
  load the same shell setup on any machine without relying on the user profile.
  Useful when $PROFILE is unavailable, disabled, or write-protected — dot-source
  this file directly instead.

  Heavy init (fastfetch, starship, zoxide) is guarded to ConsoleHost only to
  prevent double-execution when loaded inside VS Code's integrated terminal.

.EXAMPLE
  . .\profile.ps1

.EXAMPLE
  # Add to your $PROFILE so it loads automatically:
  . "$env:USERPROFILE\Projects\contento\windows-scripts\profile\profile.ps1"

.NOTES
  FileName: profile.ps1
  GitHub: https://github.com/contento
  Admin: Not required
#>

# ---- Heavy init (skip in VS Code / non-interactive hosts)
if ($Host.Name -eq 'ConsoleHost') {

    # ---- Fastfetch
    # scoop install fastfetch
    if (Get-Command fastfetch -ErrorAction SilentlyContinue) {
        fastfetch --logo none --structure 'OS:Shell:CPU:Memory:Uptime'
    }

    # ---- Starship
    # scoop install starship
    if (Get-Command starship -ErrorAction SilentlyContinue) {
        # Use the config bundled alongside this script if it exists;
        # otherwise fall back to Starship's default (~/.config/starship.toml).
        $bundledConfig = Join-Path $PSScriptRoot '.config\starship\starship.toml'
        if (Test-Path -LiteralPath $bundledConfig) {
            $env:STARSHIP_CONFIG = $bundledConfig
        }
        Invoke-Expression (&starship init powershell)
    }

    # ---- Zoxide
    # scoop install zoxide
    if (Get-Command zoxide -ErrorAction SilentlyContinue) {
        Invoke-Expression (& { (zoxide init powershell | Out-String) })
        Set-Alias -Name cd  -Value z  -Option AllScope -Force
        Set-Alias -Name cdi -Value zi -Option AllScope -Force
    }

}

# ---- PSReadLine
Set-PSReadLineKeyHandler -Key Tab       -Function MenuComplete
Set-PSReadLineKeyHandler -Key UpArrow   -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

Set-PSReadLineOption -EditMode Windows

# PredictionSource requires PSReadLine 2.1+; PredictionViewStyle requires 2.2+.
$_psrl = (Get-Module PSReadLine).Version
if ($_psrl -ge [version]'2.1') { Set-PSReadLineOption -PredictionSource    History  }
if ($_psrl -ge [version]'2.2') { Set-PSReadLineOption -PredictionViewStyle ListView }
Remove-Variable _psrl

# ---- Aliases
New-Alias -Name Edit  -Value notepad     -Force -ErrorAction SilentlyContinue
New-Alias -Name which -Value Get-Command -Force

if (Get-Command nvim -ErrorAction SilentlyContinue) {
    New-Alias -Name vim -Value nvim -Force
    function v { nvim . }
}

if (Get-Command code -ErrorAction SilentlyContinue) {
    function c  { code . }
    function ep { code $PROFILE }
}

if (Get-Command yazi -ErrorAction SilentlyContinue) {
    New-Alias -Name y -Value yazi -Force
}

if (Get-Command git -ErrorAction SilentlyContinue) {
    function gs { git status @args }
    function gl { git log --oneline --graph --decorate @args }
    function gd { git diff @args }
    function gp { git push @args }
}

if (Get-Command rg -ErrorAction SilentlyContinue) {
    New-Alias -Name grep -Value rg -Force
}

if (Get-Command scoop -ErrorAction SilentlyContinue) {
    function sup { scoop update * }
}

function touch {
    foreach ($f in $args) {
        if (Test-Path $f) { (Get-Item $f).LastWriteTime = Get-Date }
        else              { New-Item -ItemType File -Path $f | Out-Null }
    }
}

function reload { . $PROFILE }
function path   { $env:PATH -split ';' }
function ..     { Set-Location .. }
function ...    { Set-Location ..\.. }

New-Alias -Name clip -Value Set-Clipboard -Force -ErrorAction SilentlyContinue

# ---- eza  (ls replacements)
# scoop install eza
if (Get-Command eza -ErrorAction SilentlyContinue) {
    function l   { eza --color=always --git --icons=always @args }
    function ll  { l --long @args }
    function la  { l --all @args }
    function lla { l --long --all @args }
    function lt  { l --tree @args }
}

# ---- bat  (cat replacement)
# scoop install bat
if (Get-Command bat -ErrorAction SilentlyContinue) {
    function cat { bat --color=always --style=plain @args }
}

# ---- Local script wrappers
if (Test-Path -LiteralPath "$HOME\Projects\contento\windows-scripts\compress-this\Compress-This.ps1") {
    function Compress-This {
        & "$HOME\Projects\contento\windows-scripts\compress-this\Compress-This.ps1" @args
    }
}

# ---- Environment variables
# Uses [Environment]::SetEnvironmentVariable instead of setx: no subprocess, no 1024-char limit.
# Skips the registry write when the value is already correct.
# $IsWindows is $null in PS 5.1 (always Windows) and $true/$false in PS 7+.
if ($IsWindows -ne $false) {
    $envVars = @{
        Editor              = 'notepad'
        MSYS2_ARG_CONV_EXCL = '*'
        MSYS_NO_PATHCONV    = '1'
        YAZI_FILE_ONE       = "$env:USERPROFILE\scoop\apps\git\current\usr\bin\file.exe"
    }
    foreach ($kv in $envVars.GetEnumerator()) {
        if ([Environment]::GetEnvironmentVariable($kv.Key, 'User') -ne $kv.Value) {
            [Environment]::SetEnvironmentVariable($kv.Key, $kv.Value, 'User')
        }
    }
    Remove-Variable envVars
}

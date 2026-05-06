<#
Why this script exists
- Keeps my PowerShell startup configuration in version control.
- Lets me load the same shell setup on any machine without relying only on the user profile path.
- Useful in locked-down, temporary, or remote environments where I may not have access to `$PROFILE`
    (for example: profile loading is disabled, the profile path is unavailable, or I do not have write permission).

In short, this file is a portable profile backup I can dot-source when `$PROFILE` is not usable.
#>

# ---- Fastfetch
# scoop install fastfetch
if (Get-Command fastfetch -ErrorAction SilentlyContinue) {
    fastfetch --logo none --structure 'OS:Shell:CPU:Memory:Uptime'
}

# ---- Starship
# scoop install starship
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}

# ---- Zoxide
# scoop install zoxide
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
    Set-Alias -Name cd  -Value z  -Option AllScope -Force
    Set-Alias -Name cdi -Value zi -Option AllScope -Force
}

# ---- PSReadLine
Set-PSReadLineKeyHandler -Key Tab       -Function MenuComplete
Set-PSReadLineKeyHandler -Key UpArrow   -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

Set-PSReadLineOption -EditMode Windows

$_psrl = (Get-Module PSReadLine).Version
if ($_psrl -ge [version]'2.1') { Set-PSReadLineOption -PredictionSource    History  }
if ($_psrl -ge [version]'2.2') { Set-PSReadLineOption -PredictionViewStyle ListView }
Remove-Variable _psrl

# ---- Aliases
New-Alias -Name Edit -Value notepad -Force -ErrorAction SilentlyContinue

if (Get-Command nvim -ErrorAction SilentlyContinue) {
    New-Alias -Name vim -Value nvim -Force
    New-Alias -Name v   -Value nvim -Force
}

if (Get-Command yazi -ErrorAction SilentlyContinue) {
    New-Alias -Name y -Value yazi -Force
}

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

# ---- Environment variables
# Uses [Environment]::SetEnvironmentVariable instead of setx: no subprocess, no 1024-char limit.
# Skips the registry write when the value is already correct.
# $IsWindows is $null in PS5 (always Windows) and $true/$false in PS Core.
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

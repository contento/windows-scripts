<#
Why this script exists
- Keeps my PowerShell startup configuration in version control.
- Lets me load the same shell setup on any machine without relying only on the user profile path.
- Useful in locked-down, temporary, or remote environments where I may not have access to `$PROFILE`
    (for example: profile loading is disabled, the profile path is unavailable, or I do not have write permission).

In short, this file is a portable profile backup I can dot-source when `$PROFILE` is not usable.
#>

# ---- Starship
# https://github.com/starship/starship
# scoop install starship 
Invoke-Expression (&starship init powershell)

Invoke-Expression (& { (zoxide init powershell | Out-String) })

# ---- PSReadline

Set-PSReadlineKeyHandler -Key Tab       -Function MenuComplete
Set-PSReadlineKeyHandler -Key UpArrow   -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

Set-PSReadLineOption -PredictionSource    History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode            Windows

# ---- Aliases:
New-Alias -Name Edit -Value "Notepad" -Force -ErrorAction SilentlyContinue
New-Alias -Name vim  -Value "nvim"    -Force -ErrorAction SilentlyContinue
New-Alias -Name v    -Value "nvim"    -Force -ErrorAction SilentlyContinue
New-Alias -Name y    -Value "yazi"    -Force -ErrorAction SilentlyContinue

# ls
function l   { eza --color=always --git --icons=always @args }
function ll  { l --long @args }
function la  { l --all @args }
function lla { l --long --all @args }
function lt  { l --tree @args }

# cd
Set-Alias -Name cd -Value z -Description "z" -Option AllScope
Set-Alias -Name cdi -Value zi -Description "zi" -Option AllScope

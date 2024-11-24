# ---- Startship
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
New-Alias -Name Edit  -Value  "Notepad"
New-Alias -Name vim   -Value  "nvim"
New-Alias -Name v     -Value  "nvim"
New-Alias -Name y     -Value  "yazi"

# ls
# ===============================================
# PowerShell Custom Directory Listing Functions
# ===============================================
# This script defines custom functions for directory listing
# using the 'eza' command. It first removes any existing
# aliases that might conflict with the function names.
# ===============================================

# Function to remove existing aliases if they exist
Function Remove-ExistingAlias {
    param (
        [Parameter(Mandatory = $true)]
        [string]$AliasName
    )

    # Check if the alias exists
    if (Get-Alias -Name $AliasName -ErrorAction SilentlyContinue) {
        try {
            # Remove the alias
            Remove-Item -Path "Alias:$AliasName" -Force
            Write-Verbose "Removed existing alias: $AliasName"
        }
        catch {
            Write-Warning "Failed to remove alias '$AliasName'. Error: $_"
        }
    }
}

# ===============================================
# Remove Aliases if They Exist
# ===============================================
Remove-ExistingAlias -AliasName 'l'
Remove-ExistingAlias -AliasName 'la'
Remove-ExistingAlias -AliasName 'lla'
Remove-ExistingAlias -AliasName 'lt'

function l 		{ eza --color=always --git --icons=always @args }
function ll 	{ l --long @args }
function la 	{ l --all @args }
function lla 	{ l --long --all @args }
function lt 	{ l --tree @args }

# cd
Set-Alias -Name cd -Value z -Description "z" -Option AllScope
Set-Alias -Name cdi -Value zi -Description "zi" -Option AllScope

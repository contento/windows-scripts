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
Function LsE { 
    param ( 
        [Parameter(Mandatory=$false, Position=0, ValueFromRemainingArguments=$true)] 
        $Args 
    ) 
    eza --color=always --git --icons=always @Args 
}

Function LsL  { param($LsArgs) LsE @LsArgs -l  };    Set-Alias -Name l   -Value LsL  -Description "ls -l";
Function LsA  { param($LsArgs) LsE @LsArgs -la };    Set-Alias -Name la  -Value LsA  -Description "ls -la";
Function LsLA { param($LsArgs) LsE @LsArgs -lla };   Set-Alias -Name lla -Value LsLA -Description "ls -la";
Function LsT  { param($LsArgs) LsE @LsArgs --tree }; Set-Alias -Name lt  -Value LsT  -Description "ls --tree";
# cd
Set-Alias -Name cd -Value z -Description "z" -Option AllScope
Set-Alias -Name cdi -Value zi -Description "zi" -Option AllScope
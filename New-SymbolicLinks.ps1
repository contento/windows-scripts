#requires -RunAsAdministrator

# To Folders
$LinkInfo = @{
  "C:/Projects"              = "$Home/Projects";
  "C:/Logs"                  = "$Home/Logs";
  "C:/Temp"                  = "$Home/Temp";
  "C:/Virtual Machines"      = "$Home/Virtual Machines";
  "C:/Backup"                = "$Env:OneDriveConsumer/Backup";
  "C:/Music"                 = "$Env:OneDriveConsumer/Music";
  "C:/Pictures"              = "$Env:OneDriveConsumer/Pictures";
  "C:/Photos"                = "$Env:OneDriveConsumer/Photos";
  "C:/Staging"               = "$Env:OneDriveConsumer/Staging";
  "C:/Videos"                = "$Env:OneDriveConsumer/Videos";
  "C:/Tools"                 = "$Env:APPDATA/Ghisler/Tools";
  "$Env:LOCALAPPDATA/nvim"   = "$HOME/Projects/contento/dotfiles/nvim/.config/nvim";
  "$Home/Downloads/Material" = "$Env:OneDriveConsumer/Pictures/Material";
}

$LinkInfo.GetEnumerator() | ForEach-Object {
  $path = $_.Key
  $target = $_.Value
  Write-Output "**** [$target - directory] Creating ..."
  New-Item -ItemType Directory -Path $target -ErrorAction Continue
  Write-Output "     [$target - link] Creating from $path to $target"
  New-Item -ItemType SymbolicLink -Path $path -Target $target -ErrorAction Continue
}
# Map drive A: to \\tesoro\assets
Write-Output "**** [A: - link] Creating from A: to \\tesoro\assets"
subst A: "\\tesoro\assets"

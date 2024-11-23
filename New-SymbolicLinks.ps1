#requires -RunAsAdministrator

# To Folders
$LinkInfo = @{
  "C:/Backup"                = "$Env:OneDriveConsumer/Backup";
  "C:/Logs"                  = "$Home/Logs";
  "C:/Music"                 = "$Env:OneDriveConsumer/Music";
  "C:/Photos"                = "$Env:OneDriveConsumer/Photos";
  "C:/Pictures"              = "$Env:OneDriveConsumer/Pictures";
  "C:/Projects"              = "$Home/Projects";
  "C:/Staging"               = "$Env:OneDriveConsumer/Staging";
  "C:/Videos"                = "$Env:OneDriveConsumer/Videos";
  "C:/Virtual Machines"      = "$Home/Virtual Machines";
  "C:/Temp"                  = "$Home/Temp";
  "C:/Tools"                 = "$Env:APPDATA/Ghisler/Tools";
  #
  "$Env:LOCALAPPDATA/nvim"   = "$HOME/Projects/contento/dotfiles/nvim/.config/nvim";
  #
  "$Home/Downloads/Assets"   = "\\tesoro\Assets";
  "$Home/Downloads/Material" = "$Env:OneDriveConsumer/Pictures/Material";
  "$Home/Downloads/Temp"     = "$Home/Temp";
}

$LinkInfo.GetEnumerator() | ForEach-Object {
  $path = $_.Key
  $target = $_.Value
  Write-Output "**** [$target - directory] Creating ..."
  New-Item -ItemType Directory -Path $target -ErrorAction Continue
  Write-Output "     [$target - link] Creating from $path to $target"
  New-Item -ItemType SymbolicLink -Path $path -Target $target -ErrorAction Continue
}

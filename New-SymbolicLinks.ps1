#requires -RunAsAdministrator

# Ensure P: drive exists
if (-not (Test-Path -Path "P:\")) {
  Write-Output "Drive P: does not exist. Creating it..."
  $projectsPath = "$Home/Projects"
  if (-not (Test-Path -Path $projectsPath)) {
    Write-Output "Creating directory $projectsPath..."
    New-Item -ItemType Directory -Path $projectsPath -ErrorAction Stop
  }
  New-PSDrive -Name "P" -PSProvider "FileSystem" -Root $projectsPath -Persist
  Write-Output "Drive P: created and mapped to $projectsPath."
}

# To Folders
$LinkInfo = @{
  "C:/Backup"                = "$Env:OneDriveConsumer/Backup";
  "C:/Logs"                  = "$Home/Logs";
  "C:/Music"                 = "$Env:OneDriveConsumer/Music";
  "C:/Photos"                = "$Env:OneDriveConsumer/Photos";
  "C:/Pictures"              = "$Env:OneDriveConsumer/Pictures";
  "C:/Projects"              = "P:/";
  "C:/Staging"               = "$Env:OneDriveConsumer/Staging";
  "C:/Videos"                = "$Env:OneDriveConsumer/Videos";
  "C:/Temp"                  = "$Home/Temp";
  "C:/Tools"                 = "$Env:APPDATA/Ghisler/Tools";
  "$Home/Downloads/Assets"   = "\\tesoro\Assets";
  "$Home/Downloads/Material" = "$Env:OneDriveConsumer/Pictures/Material";
  "$Home/Downloads/Temp"     = "$Home/Temp";
  "$Home/Downloads/WIP"      = "$Env:OneDriveConsumer/WIP";
}

$LinkInfo.GetEnumerator() | ForEach-Object {
  $path = $_.Key
  $target = $_.Value

  if (-not (Test-Path -Path $target)) {
    Write-Output "**** [$target - directory] Creating ..."
    New-Item -ItemType Directory -Path $target -ErrorAction Continue
  }

  if (Test-Path -Path $path) {
    Write-Output "     [link] Removing existing link at $path"
    Remove-Item -Path $path -Force -Recurse -ErrorAction Continue
  }
  Write-Output "     [$target - link] Creating from $path to $target"
  New-Item -ItemType SymbolicLink -Path $path -Target $target -ErrorAction Continue
}

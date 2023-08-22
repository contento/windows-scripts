#requires -RunAsAdministrator

# To Folders
$LinkInfo = @{
  "C:/Projects"         = "$Home/Projects";
  "C:/Logs"             = "$Home/Logs";
  "C:/Temp"             = "$Home/Temp";
  "C:/Virtual Machines" = "$Home/Virtual Machines";
  # OneDrive Consumer
  "C:/Backup"           = "$Env:OneDriveConsumer/Backup";
  "C:/Music"            = "$Env:OneDriveConsumer/Music";
  "C:/Pictures"         = "$Env:OneDriveConsumer/Pictures";
  "C:/Photos"           = "$Env:OneDriveConsumer/Photos";
  "C:/Staging"          = "$Env:OneDriveConsumer/Staging";
  "C:/Videos"           = "$Env:OneDriveConsumer/Videos";
  # Ghisler - Total Commander
  "C:/Tools"            = "$Env:APPDATA/Ghisler/Tools";
}

$LinkInfo.GetEnumerator() | ForEach-Object {
  $path = $_.Key
  $target = $_.Value
  New-Item -ItemType Directory -Path $target -ErrorAction Continue
  New-Item -ItemType SymbolicLink -Path $path -Target $target -ErrorAction Continue
}

##############################################################
# Windows Apps - Links

$WINDOWS_APPS = "$Env:LOCALAPPDATA\Microsoft\WindowsApps"

# Python
# Get Python version
$pythonVersionFull = & python --version 2>&1
$pythonVersionNumbers = $pythonVersionFull.Split(' ')[1]
$pythonMajorVersion = $pythonVersionNumbers.Split('.')[0]
$pythonMinorVersion = $pythonVersionNumbers.Split('.')[1]
$pythonVersion = "Python$pythonMajorVersion$pythonMinorVersion"

# Build the path
# if you're use LocalCache
# $packageName = "PythonSoftwareFoundation.Python.$pythonMajorVersion.$($pythonMinorVersion)_qbz5n2kfra8p0"
# $PYTHON_SCRIPTS_PATH = "$env:LOCALAPPDATA\Packages\$packageName\LocalCache\local-packages\$pythonVersion\Scripts"
# or if you're using Programs
$PYTHON_SCRIPTS_PATH = "$Env:LOCALAPPDATA/Programs/Python/$pythonVersion/Scripts "

$LinkInfo = @{
  "$($WINDOWS_APPS)/jupyter.exe"         	= "$PYTHON_SCRIPTS_PATH/jupyter.exe";
  "$($WINDOWS_APPS)/git-filter-repo.exe" 	= "$PYTHON_SCRIPTS_PATH/git-filter-repo.exe";
  "$($WINDOWS_APPS)/vim.exe" 				      = "$Env:ProgramFiles/vim/vim90/vim.exe";
}

$LinkInfo.GetEnumerator() | ForEach-Object {
  $path = $_.Key
  $target = $_.Value
  New-Item -ItemType SymbolicLink -Path $path -Target $target -Force -ErrorAction Continue
}

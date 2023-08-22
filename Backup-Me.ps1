$ProductName            = "PowerShell"  # Name of the product you want to backup
$SourcePath             = "$Profile"    # PowerShell profile or your own path 

$BackupTargetScriptPath = "$($PSScriptRoot)/../Backup-Target.ps1"

$whichOneDrive = ($Env:OneDriveConsumer) ? $Env:OneDriveConsumer : ($Env:OneDriveCommercial) ? $Env:OneDriveCommercial : $Env:OneDrive
$DestinationPath = "$whichOneDrive\Settings\$ProductName"

& $BackupTargetScriptPath -Path $SourcePath -DestinationPath $DestinationPath -Uncompressed -DateFormat 'yyyy-MM-dd'

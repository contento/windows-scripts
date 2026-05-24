<#
.SYNOPSIS
  Back up a target file or folder using Backup-Target.ps1.

.DESCRIPTION
  This script configures a PowerShell profile backup path and delegates the
  actual backup operation to Backup-Target.ps1.

.NOTES
  FileName: Backup-Me.ps1
  GitHub: https://github.com/contento
#>

$ProductName            = "PowerShell"  # Name of the product you want to backup
$SourcePath             = "$Profile"    # PowerShell profile or your own path

$BackupTargetScriptPath = "$($PSScriptRoot)/../Backup-Target.ps1"

$whichOneDrive = ($Env:OneDriveConsumer) ? $Env:OneDriveConsumer : ($Env:OneDriveCommercial) ? $Env:OneDriveCommercial : $Env:OneDrive
$DestinationPath = "$whichOneDrive\Settings\$ProductName"

& $BackupTargetScriptPath -Path $SourcePath -DestinationPath $DestinationPath -Uncompressed -DateFormat 'yyyy-MM-dd'

<#
.SYNOPSIS
Backup Target

.DESCRIPTION
Backup Target either by copying or zipping it

.EXAMPLE
.\BackupTarget.ps1 c:/temp c:/backup
.EXAMPLE
.\BackupTarget.ps1 c:/temp/settings.json c:/backup -Uncompressed:$true -DateFormat "yyyy-MM-dd"
.NOTES
:-) GC (-:
#>

#requires -version 6

param (
  [Parameter(Mandatory = $true, HelpMessage = "Path to file/folder")]
  [string] $Path,
  [Parameter(Mandatory = $true, HelpMessage = "Path Destination")]
  [string] $DestinationPath,
  [Parameter(Mandatory = $false, HelpMessage = "Date Format (Default = 'yyyy-MM-dd.HH.mm.ss')")]
  [string]$DateFormat = "yyyy-MM-dd.HH.mm.ss",
  [Parameter(Mandatory = $false, HelpMessage = "Keep old backups")]
  [switch]$KeepOld = $false,
  [Parameter(Mandatory = $false, HelpMessage = "Archive threshold in months")]
  [int] $ArchiveThreshHold = 1,
  [Parameter(Mandatory = $false, HelpMessage = "Compressed (zip) or not")]
  [switch]$Uncompressed = $false
)

#---------------------------------------------------------[Initializations]--------------------------------------------------------

Set-StrictMode -Version 2

$ErrorActionPreference = "Stop"

#----------------------------------------------------------[Declarations]----------------------------------------------------------

$Date = Get-Date -Format $DateFormat

# $Leaf = Split-Path $Path -Leaf
$LeafBase = Split-Path $Path -LeafBase
$Extension = Split-Path $Path -Extension

$DestinationBasePath = "$DestinationPath\$($LeafBase)-$($Env:COMPUTERNAME)-$($Date)"

$ArchivePath = "$DestinationPath/Archive"
New-Item -ItemType Directory -Path $ArchivePath -ErrorAction SilentlyContinue

$ArchiveExclusions = @("Backup-Target.ps1", "Backup-Me.ps1", "*.md")

$beforeDate = (Get-Date).AddMonths( -$ArchiveThreshHold)

if ($Uncompressed ) {
  $Destination = "$($DestinationBasePath)$($Extension)"
  $ArchiveExclusions += $Destination

  "Copying '$($Path)' to '$($Destination)' ..."
  Copy-Item -Path $Path -Destination $Destination -Force

  $ArchiveFilter = "$DestinationPath/*$($Extension)"
  Get-ChildItem -Path $ArchiveFilter -Exclude $ArchiveExclusions | Where-Object {
    $_.LastWriteTime -lt $beforeDate } |
  ForEach-Object {
    Move-Item -Path $_ $ArchivePath -ErrorAction Continue
  }
}
else {
  $DestinationZip = "$($DestinationBasePath).zip"
  $ArchiveExclusions += $DestinationZip

  "Compressing '$($Path)' to '$($DestinationZip)' ..."
  Compress-Archive -Path $Path -DestinationPath $DestinationZip -Force

  $ArchiveFilter = "$DestinationPath/*.zip"
  Get-ChildItem -Path $ArchiveFilter  -Exclude $ArchiveExclusions | Where-Object {
    $_.LastWriteTime -lt $beforeDate } |
  ForEach-Object {
    Move-Item -Path $_ $ArchivePath -ErrorAction Continue
  }
}


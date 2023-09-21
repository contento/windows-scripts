# Set execution policy
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser

# Install necessary software using winget
$wingetPackages = @{
  "7zip.7zip"                      = $null;
  "ScooterSoftware.BeyondCompare4" = $null;
  "Bitwarden.Bitwarden"            = $null;
  "Brave.Brave"                    = $null;
  "Ditto.Ditto"                    = $null;
  "ghisler.totalcommander"         = $null;
  "git.git"                        = $null;
  "IrfanSkiljan.IrfanView"         = $null;
  "JAMSoftware.TreeSize.Free"      = $null;
  "Microsoft.DotNet.SDK.6"         = $null;
  "Microsoft.PowerShell"           = $null;
  "Microsoft.RemoteDesktopClient"  = $null;
  "Microsoft.Teams"                = $null;
  "Microsoft.WindowsTerminal"      = "msstore";
  "nmap"                           = $null;
  "Notepad++.Notepad++"            = $null;
  "mozilla.firefox"                = $null;
  "Python.Python.3"                = $null;
  "RealVNC.VNCViewer"              = $null;
  "SysInternals"                   = $null;
  "Microsoft.VisualStudioCode"     = $null;
  "VivaldiTechnologies.Vivaldi"    = $null
}

$wingetPackages.Keys | Sort-Object | ForEach-Object {
  if ($null -ne $wingetPackages[$_]) {
    winget install $_ --source $wingetPackages[$_] --silent
  }
  else {
    winget install $_ --silent
  }
}

# Scoop Installation and Packages
if (!(Get-Command "scoop" -errorAction SilentlyContinue)) {
  # As a normal user
  # Invoke-RestMethod get.scoop.sh | iex
  # as an Admin
  iex "& {$(Invoke-RestMethod get.scoop.sh)} -RunAsAdmin"
}

# Scoop bucket and installation
$bucketAndPackages = @{
  "default"    = @("lsd"); 
  "extras"     = @("notepad3");
  "nerd-fonts" = @("Delugia-Nerd-Font-Complete", "Firacode");
  "versions"   = @("lightshot");
}

$bucketAndPackages.Keys | Sort-Object | ForEach-Object {
  $bucket = $_
  if ($bucket -ne "default") {
    scoop bucket add $bucket
  }
  $bucketAndPackages[$_].ForEach({
      scoop install $_
    })
}

# Install starship
scoop install starship

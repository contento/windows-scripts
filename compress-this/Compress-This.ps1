<#
.SYNOPSIS
    Compress the current folder into a timestamped archive.

.DESCRIPTION
    Creates a timestamped 7-Zip archive of the current working directory under
    BACKUP_PATH\<foldername>. Uses the 7-Zip CLI.

    - Preserves folder structure (archives from '.').
    - Default output format is .zip.
    - In -Dev mode, excludes generated folders/files for a clean source backup.
    - Excludes .git via an inline -xr! argument (list-file matching is unreliable for .git).

.PARAMETER Dev
    Exclude generated folders, caches, build outputs, and secret files.
    Use for source-code backups where you only want tracked files.

.PARAMETER Pause
    Wait for a keypress before exiting. Useful when the script is launched from
    a shortcut or external tool that would otherwise close the window immediately.

.PARAMETER BACKUP_PATH
    Root folder where archives are written. Defaults to OneDrive\Backup when
    OneDrive is configured, otherwise %USERPROFILE%\OneDrive\Backup.
    Archives land in a subfolder named after the current directory.

.PARAMETER SevenZip
    Name or full path of the 7-Zip executable. Defaults to '7z' (must be on PATH).
    Override with the full path if 7z is not on PATH, e.g. 'C:\Program Files\7-Zip\7z.exe'.

.PARAMETER Format
    Output archive format: 'zip' (default) or '7z'.

.PARAMETER Help
    Display this help message and exit.

.PARAMETER WhatIf
    Show what would be archived and where, without creating the archive.

.EXAMPLE
    .\Compress-This.ps1

.EXAMPLE
    .\Compress-This.ps1 -Dev

.EXAMPLE
    .\Compress-This.ps1 -Format 7z -Dev

.EXAMPLE
    .\Compress-This.ps1 -Dev -WhatIf

.NOTES
    FileName : Compress-This.ps1
    Admin    : Not required
    Requires : 7-Zip on PATH  (scoop install 7zip  or  winget install 7zip.7zip)
#>

[CmdletBinding(SupportsShouldProcess)]
Param(
    [switch]$Help,
    [switch]$Dev,
    [switch]$Pause,

    # Default: OneDrive\Backup if available
    [string]$BACKUP_PATH = $(
        $od = $Env:OneDriveCommercial
        if (-not $od) { $od = $Env:OneDrive }
        if (-not $od) { $od = Join-Path $Env:USERPROFILE 'OneDrive' }
        Join-Path $od 'Backup'
    ),

    # 7-Zip executable name or path
    [string]$SevenZip = '7z',

    # Output archive format (still using 7z). Default is zip.
    [ValidateSet('zip','7z')]
    [string]$Format = 'zip'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ($Help) { Get-Help $PSCommandPath -Detailed; exit }

# ── Output helpers ─────────────────────────────────────────────────────────────
function Write-Info ([string]$Msg) { Write-Host ' [info] ' -ForegroundColor Cyan     -NoNewline; Write-Host $Msg }
function Write-Ok   ([string]$Msg) { Write-Host ' [ ok ] ' -ForegroundColor Green    -NoNewline; Write-Host $Msg }
function Write-Warn ([string]$Msg) { Write-Host ' [warn] ' -ForegroundColor Yellow   -NoNewline; Write-Host $Msg }
function Write-Err  ([string]$Msg) { Write-Host ' [err!] ' -ForegroundColor Red      -NoNewline; Write-Host $Msg }
function Write-Step ([string]$Msg) { Write-Host ' [ >> ] ' -ForegroundColor DarkCyan -NoNewline; Write-Host $Msg }

function Invoke-WithSpinner {
    param([string]$Label, [scriptblock]$Block)
    $frames = '-', '\', '|', '/'
    $job    = Start-Job -ScriptBlock $Block
    $tick   = 0
    while ($job.State -eq 'Running') {
        Write-Host ("`r [ {0} ] {1}" -f $frames[$tick % 4], $Label) -NoNewline -ForegroundColor DarkCyan
        Start-Sleep -Milliseconds 100
        $tick++
    }
    Write-Host ("`r" + (' ' * ($Label.Length + 10)) + "`r") -NoNewline
    $result = @(Receive-Job $job)
    Remove-Job $job -Force
    return $result
}

# ── Utilities ──────────────────────────────────────────────────────────────────
function Initialize-Directory ([string]$Path) {
    if (Test-Path -LiteralPath $Path) {
        $item = Get-Item -LiteralPath $Path
        if (-not $item.PSIsContainer) {
            throw "A file (not a directory) already exists at '$Path'."
        }
        return
    }
    New-Item -ItemType Directory -Path $Path -Force | Out-Null
}

function Resolve-Command ([string]$Name) {
    $cmd = Get-Command $Name -ErrorAction SilentlyContinue
    if (-not $cmd) { return $null }
    return $cmd.Source
}

# ── Dev exclusion set for repo backup ──────────────────────────────────────────
# Keep source; exclude generated / caches / IDE noise.
[string[]]$DevExcludeDirs = @(
    # Git — excluded via inline -xr! argument; entries here are documentation only.
    # All .git variants are stripped from the list file before it is passed to 7-Zip.
    '.git', '.git\\*',

    # Build outputs
    'bin\\*', 'obj\\*', 'build\\*', 'dist\\*', 'out\\*',

    # Dependency restores
    'node_modules\\*', 'packages\\*',

    # IDE/tooling state
    '.vs\\*', '.idea\\*',

    # Python
    '__pycache__\\*', '.pytest_cache\\*', '.mypy_cache\\*', '.ruff_cache\\*', '.tox\\*', '.nox\\*', 'venv\\*', '.venv\\*',
    '__pypackages__\\*', '*.egg-info\\*', '.eggs\\*',

    # uv
    '.uv\\*',

    # JS / tooling
    '.next\\*', '.nuxt\\*', '.output\\*', '.cache\\*', '.parcel-cache\\*', '.yarn\\*', '.turbo\\*',

    # Node.js
    '.node_repl_history',

    # Fabric (Python task runner)
    '.fabric\\*',

    # Obsidian
    '.obsidian\\*', '.trash\\*',

    # PowerShell build outputs
    'output\\*', 'release\\*',

    # Test / coverage
    'coverage\\*', 'htmlcov\\*', 'TestResults\\*',

    # Logs
    'logs\\*'
)

[string[]]$DevExcludePatterns = @(
    # Compiled binaries & symbols
    '*.dll', '*.exe', '*.pdb', '*.obj', '*.ilk', '*.idb', '*.iobj', '*.ipdb', '*.pch', '*.tlog',

    # Python bytecode
    '*.pyc', '*.pyo', '*.pyd',

    # Node.js
    '*.tsbuildinfo',

    # Marp (export artifacts — actual output filenames vary, so only known temp patterns)
    '.marp-cache',

    # PowerShell
    '*.ps1xml.bak',

    # Visual Studio/tooling DBs
    '*.VC.db', '*.VC.VC.opendb', '*.cachefile',

    # NuGet packages
    '*.nupkg', '*.snupkg',

    # OS/editor noise
    '*.tmp', '*.bak', '*.swp', 'Thumbs.db', 'desktop.ini',

    # JS logs
    'npm-debug.log*', 'yarn-debug.log*', 'yarn-error.log*', 'pnpm-debug.log*', 'lerna-debug.log*',

    # Environment secrets
    '.env', '.env.*'
)

# ── Validate paths / tools ─────────────────────────────────────────────────────
Initialize-Directory $BACKUP_PATH

$sevenZipResolved = Resolve-Command $SevenZip
if (-not $sevenZipResolved) {
    Write-Err "7-Zip '$SevenZip' not found on PATH. Install 7-Zip or provide the full path via -SevenZip."
    exit 1
}

# ── Build output path ──────────────────────────────────────────────────────────
$stamp      = (Get-Date).ToString('yyyyMMdd_HHmmss')
$folderName = Split-Path -Path $PWD -Leaf
$outDir     = Join-Path $BACKUP_PATH $folderName
Initialize-Directory $outDir
$outFile    = Join-Path $outDir ("{0}_{1}.{2}" -f $folderName, $stamp, $Format)

Write-Step "Archiving '$folderName'"
Write-Info "Tool   : 7z ($Format)"
if ($Dev) {
    Write-Info "Mode   : dev (generated files excluded)"
}
Write-Info "Source : $PWD"
Write-Info "Output : $outFile"

# ── Build 7z arguments ─────────────────────────────────────────────────────────
# Archive from '.' to preserve structure. Force type explicitly.
$typeSwitch  = if ($Format -eq 'zip') { '-tzip' } else { '-t7z' }
$szArgs      = [System.Collections.Generic.List[string]]::new()
$szArgs.AddRange([string[]]@('a', $typeSwitch, '-mx9', $outFile, '.'))
$excludeList = $null   # declared here so the finally block can always reference it

if ($Dev) {
    $szArgs.Add('-xr!.git\\*')

    $allDevExclusions = @($DevExcludeDirs + $DevExcludePatterns) |
        ForEach-Object { $_.Trim() } |
        Where-Object   { $_ } |
        Sort-Object    -Unique

    $runTag      = '{0}_{1}' -f $folderName, ([Guid]::NewGuid().ToString('N'))
    $excludeList = Join-Path $Env:TEMP ("compress-this.{0}.x.lst" -f $runTag)

    # Strip all .git variants — handled entirely by the inline -xr! rule above.
    $listLines = $allDevExclusions | Where-Object { $_ -notmatch '^\.git' }
    $listLines | Set-Content -LiteralPath $excludeList -Encoding Ascii

    $szArgs.Add("-xr@${excludeList}")
}

# ── Compress ───────────────────────────────────────────────────────────────────
$szExe      = $SevenZip
$szArgArray = $szArgs.ToArray()
$sourceDir  = $PWD.Path   # captured here; Start-Job in PS 5.1 starts in $env:USERPROFILE

if (-not $PSCmdlet.ShouldProcess($outFile, 'Create archive')) {
    exit 0
}

try {
    $items = Invoke-WithSpinner -Label "Compressing '$folderName'" -Block {
        Set-Location $using:sourceDir
        & $using:szExe @using:szArgArray 2>&1
        $LASTEXITCODE
    }

    $exitCode = if ($items.Count -gt 0) { [int]$items[-1] } else { -1 }

    if ($exitCode -ne 0) {
        Write-Err "7-Zip exited with code $exitCode"
        if ($items.Count -gt 1) {
            $items[0..($items.Count - 2)] | ForEach-Object {
                Write-Host ("        " + ($_ -as [string])) -ForegroundColor DarkRed
            }
        }
        exit $exitCode
    }

    $fileSize = (Get-Item -LiteralPath $outFile).Length
    $sizeStr  = if ($fileSize -ge 1GB) { '{0:N1} GB' -f ($fileSize / 1GB) }
                elseif ($fileSize -ge 1MB) { '{0:N1} MB' -f ($fileSize / 1MB) }
                else { '{0:N0} KB' -f ($fileSize / 1KB) }

    Write-Ok "$outFile  ($sizeStr)"
    Write-Output $outFile
} finally {
    # Clean up the temp exclusion list immediately — not deferred to session exit.
    if ($excludeList -and (Test-Path -LiteralPath $excludeList)) {
        Remove-Item -LiteralPath $excludeList -Force -ErrorAction SilentlyContinue
    }
}

if ($Pause) {
    Write-Host "`n Press any key to continue..." -ForegroundColor DarkGray
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
}

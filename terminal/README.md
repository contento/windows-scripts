# Terminal

Version-controlled Windows Terminal `settings.json`, symlinked into place.

## Files

| File | Description |
| ---- | ----------- |
| [`Setup-Terminal.ps1`](Setup-Terminal.ps1) | Creates a symbolic link from Windows Terminal's real settings.json to the bundled copy in this repo |
| [`.config/windows-terminal/settings.json`](.config/windows-terminal/settings.json) | Bundled Windows Terminal settings (profiles, color schemes, keybindings) |

## Usage

```powershell
.\Setup-Terminal.ps1
```

Requires **Administrator** privileges or Developer Mode enabled, since creating a symbolic link otherwise requires elevation.

Targets the packaged/Store install of Windows Terminal:
```
%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
```

Because the file is a symbolic link rather than a copy, edits made through the Windows Terminal UI (color schemes, keybindings, new profiles) are written straight back into the repo copy — commit them like any other change.

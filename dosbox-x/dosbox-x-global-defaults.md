# DOSBox-X Global Defaults

Configuration to apply to **every** DOSBox-X session on macOS. Covers:

- SVGA resolution (S3 Trio64)
- Mouse support (auto-capture, integration)
- MS-DOS 6.22 as the reported version
- Unix-style command aliases via `DOSKEY`

---

## 1. Locate the Global Config File

On macOS, the user-level config lives at:

```
~/Library/Preferences/DOSBox-X Preferences
```

Despite the name, this is a **plain INI text file**, not an Apple plist. Open it with any editor.

If the file does not exist yet, launch DOSBox-X once and run at the `Z:\>` prompt:

```
config -wc
```

This writes the current effective config to the user config path. Quit, edit it, relaunch.

To confirm which config files DOSBox-X is loading in any session:

```
config -ln
```

---

## 2. Sections to Merge

Merge the following into the global config. Do **not** duplicate section headers — if a section already exists, add the keys inside it.

### `[sdl]` — Mouse and Window

```ini
[sdl]
autolock = true
sensitivity = 100
output = opengl
fullscreen = false
```

- `autolock = true` — mouse is captured automatically when you click into the window; press the host key (default Ctrl+F10) to release.
- `output = opengl` — smoother scaling on modern macOS displays.

### `[dosbox]` — Machine and Resolution

```ini
[dosbox]
machine = svga_s3
memsize = 32
vmemsize = 8
```

- `machine = svga_s3` — emulates an S3 Trio64 SVGA card with VESA support. Covers VGA, SVGA, and high-resolution modes.
- `vmemsize = 8` — 8 MB of video memory, enough for any VESA mode you would realistically use.

### `[render]` — Display Scaling

```ini
[render]
aspect = true
scaler = normal2x
```

- `aspect = true` — preserves 4:3 ratio when scaling.
- `scaler = normal2x` — clean integer upscale. Swap for `hq2x` or `advmame2x` for smoothing if preferred.

### `[cpu]` — CPU Behavior

```ini
[cpu]
cputype = pentium_mmx
cycles = max
```

### `[dos]` — DOS Version and Memory

```ini
[dos]
ver = 6.22
ems = true
xms = true
umb = true
```

- `ver = 6.22` — `VER` reports MS-DOS 6.22. Version-gated installers behave accordingly.
- EMS/XMS/UMB enabled so DOS extenders and TSRs can use upper and extended memory.

### `[mouse]` — Mouse Emulation

```ini
[mouse]
int33 = true
biosps2 = true
```

- `int33 = true` — classic DOS mouse driver interface (what most DOS apps and games expect).
- `biosps2 = true` — PS/2 BIOS mouse for software that bypasses INT 33h.

### `[autoexec]` — Global Aliases

Keep this minimal in the global config. Just load the alias macros — no mounts (mounts belong in per-project configs).

```ini
[autoexec]
@echo off
DOSKEY /BUFSIZE=4096 /LISTSIZE=256
doskey ls=dir /w /o:n $*
doskey ll=dir /o:n $*
doskey la=dir /a /o:n $*
doskey l=dir /w /o:n $*
doskey ..=cd ..
doskey ...=cd ..\..
doskey pwd=cd
doskey cat=type $*
doskey rm=del $*
doskey cp=copy $*
doskey mv=move $*
doskey mkdir=md $*
doskey rmdir=rd $*
doskey touch=copy nul $*
doskey clear=cls
doskey grep=find $*
doskey df=mem
doskey free=mem
doskey ps=mem /c /p
doskey uname=ver
doskey history=doskey /history
doskey h=doskey /history
doskey aliases=doskey /macros
```

### Notes on the aliases

- `$*` forwards all arguments to the underlying command.
- `grep` maps to DOS `FIND`. Syntax: `find "pattern" file.txt` (quotes required, no regex).
- `ps` maps to `mem /c /p` — lists loaded modules, the closest DOS equivalent to a process list.
- `touch` creates an empty file via `copy nul`. It does not update timestamps on existing files.
- Aliases live only in the current `COMMAND.COM` session. Sub-shells spawned by other programs will not inherit them.
- Run `aliases` at the prompt at any time to list every active macro.

---

## 3. Verification

Quit DOSBox-X completely, then relaunch from any directory that has no local `dosbox-x.conf`:

```bash
cd ~ && dosbox-x
```

At the `Z:\>` prompt, run:

| Command | Expected Result |
|---|---|
| `VER` | MS-DOS 6.22 |
| `MEM` | Conventional + UMB + XMS visible |
| `DOSKEY /MACROS` | Full alias list |
| `ls` | Behaves like `DIR /W` |
| `config -ln` | Only the user config listed |

For mouse: any DOS app that uses the mouse (e.g. `EDIT`) should respond once you click into the window. Press Ctrl+F10 to release the cursor back to macOS.

---

## 4. Precedence Reminder

DOSBox-X loads configs in this order (later overrides earlier):

1. Built-in defaults
2. System-wide config (rare on macOS)
3. **User config** ← this file
4. Per-directory `dosbox-x.conf` (if present in the launch directory)
5. `-conf <file>` command-line flag
6. Command-line options

Per-project configs (for example, a SmartTar workspace with mounts and project-specific autoexec) should live next to the project files and only contain what differs from these global defaults. Settings not specified locally inherit from the global config automatically.

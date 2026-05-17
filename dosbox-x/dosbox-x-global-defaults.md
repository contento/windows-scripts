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

Keep this minimal in the global config. **No mounts** (mounts belong in per-project configs) and **no `DOSKEY` macros** — see the note below.

```ini
[autoexec]
@echo off
rem No DOSKEY here: DOSKEY is not available on the Z:\ drive, only on
rem a real DOS install mounted via IMGMOUNT. Per-project autoexec
rem blocks that mount a DOS image can add their own DOSKEY macros.
rem DOSBox-X already provides a built-in `ls` on Z:\.
```

### Why no `DOSKEY` here

An earlier revision of this spec loaded a long list of `doskey` aliases
in the global `[autoexec]`. On a fresh DOSBox-X launch the user lands
on the internal `Z:\` drive, which does **not** ship `DOSKEY.COM` (or
expose it as an internal command). Every `doskey ...` line at startup
errors with `Bad command or filename`. The aliases also expand only
inside that one `COMMAND.COM` session, so any program that spawns its
own shell loses them anyway.

Cleaner alternatives if you want Unix-style aliases:

1. **Per-project autoexec that mounts a real DOS install**: add the
   `doskey ...` lines there, after the `IMGMOUNT` of an MS-DOS 6.22 disk
   image that has `DOSKEY.COM`. The macros then live with the project.
2. **4DOS as the command processor**: DOSBox-X bundles `4DOS.COM` on
   `Z:\`. 4DOS has native `alias` support, persistent across sessions
   via `4start.bat`. Switch the shell via the `[config]` section or by
   running `4dos` from `[autoexec]`.
3. **Live with the built-ins**: `ls` is already a native DOSBox-X command
   on `Z:\` and covers the most common case.

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

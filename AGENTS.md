# AGENTS

Guidance for AI coding agents (Claude Code, GitHub Copilot, etc.) working in this repository.

> This is the single source of truth for agent guidance. [CLAUDE.md](CLAUDE.md) and [.github/copilot-instructions.md](.github/copilot-instructions.md) point here. Project tasks live in [TODO.md](TODO.md) — keep it current as work lands or new items surface.

## What this repo is

Portable PowerShell startup configuration for Windows PowerShell 5.1 and PowerShell 7.
This repository contains a version-controlled profile that can be loaded without writing to `$PROFILE`.

Key files and folders:

- [profile/profile.ps1](profile/profile.ps1) — the main profile implementation.
- [profile/Setup-Profile.ps1](profile/Setup-Profile.ps1) — Windows setup script (hard links + Starship config).
- [profile/setup-profile.sh](profile/setup-profile.sh) — macOS/Linux setup script.
- [apps/New-Apps.ps1](apps/New-Apps.ps1) — installs apps via winget and Scoop.
- [backup/](backup/) — `Backup-Target.ps1` (engine) and `Backup-Me.ps1` (profile wrapper).
- [compress-this/Compress-This.ps1](compress-this/Compress-This.ps1) — timestamped 7-Zip archive of the current folder; `-Dev` excludes build artifacts and caches.
- [system/](system/) — `Setup-SSH.ps1` and `New-SymbolicLinks.ps1`.
- [README.md](README.md) — overview and links to each folder's README.

## Working rules

- Keep changes focused on shell startup behavior, prompt initialization, aliases, and cross-shell compatibility.
- Preserve PowerShell syntax and avoid unrelated refactors.
- Maintain compatibility with both Windows PowerShell 5.1 and PowerShell 7.
- Do not add platform-specific dependencies without clear benefit for the repo's core purpose.

## Communication style

- Answer concisely and directly.
- Use markdown links for file references.
- Keep the overall repo minimal and easy to understand.

## Tasks

Track ongoing work in [TODO.md](TODO.md). When you complete an item, remove or check it off; when you discover a new one, add it.

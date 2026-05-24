# CLAUDE

Guidance for Claude Code when working in this repository.

> **Sync note**: this file and `.github/copilot-instructions.md` cover the same project guidance for different assistants. When you change one, update the other so both stay aligned. Project tasks live in `TODO.md` — keep it current as work lands or new items surface.

## What this repo is

Portable PowerShell startup configuration for Windows PowerShell 5.1 and PowerShell 7.
This repository contains a version-controlled profile that can be loaded without writing to `$PROFILE`.

Key files:

- `Pwsh-Profile.ps1` — the main profile implementation.
- `README.md` — usage, setup, and installation guidance.

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

Track ongoing work in `TODO.md`. When you complete an item, remove or check it off; when you discover a new one, add it.

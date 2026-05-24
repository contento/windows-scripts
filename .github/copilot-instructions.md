# Copilot Instructions for windows-scripts

This repository contains a portable PowerShell profile designed to run on Windows PowerShell 5.1 and PowerShell 7 without requiring changes to the user profile.

> **Sync note**: this file and `CLAUDE.md` cover the same project guidance for different assistants. When you change one, update the other so both stay aligned. Project tasks live in `TODO.md` — keep it current as work lands or new items surface.

## Repository purpose

- `Pwsh-Profile.ps1` is the source-of-truth PowerShell startup profile.
- `README.md` documents setup, prerequisites, and usage.
- The repo is intended to be portable, minimal, and compatible with Windows PowerShell 5.1 and PowerShell 7.

## How to help

- Keep changes focused on shell startup configuration, prompt initialization, and cross-shell compatibility.
- Avoid unrelated refactors or large rewrites outside the profile and docs.
- Preserve `Pwsh-Profile.ps1` behavior for both legacy and modern PowerShell.
- Keep the prompt initialization via Starship stable and unobtrusive.

## Focus areas

- `Pwsh-Profile.ps1`
- `README.md`
- prompt integration and package initialization

## Files to reference

- `Pwsh-Profile.ps1`
- `README.md`

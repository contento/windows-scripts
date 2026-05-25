#!/bin/bash
#
# Sets up PowerShell profile symlinks on macOS (and Linux).
# Creates symlinks in the standard $PROFILE location that point to Pwsh-Profile.ps1 in this repo.
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROFILE_SOURCE="$SCRIPT_DIR/profile.ps1"

if [[ ! -f "$PROFILE_SOURCE" ]]; then
    echo "Error: Pwsh-Profile.ps1 not found at: $PROFILE_SOURCE"
    exit 1
fi

# PowerShell profile location on macOS/Linux
PS_PROFILE_DIR="$HOME/.config/powershell"
PS_PROFILE="$PS_PROFILE_DIR/profile.ps1"

setup_ps_profile() {
    echo "Setting up PowerShell profile..."

    if [[ ! -d "$PS_PROFILE_DIR" ]]; then
        echo "Creating directory: $PS_PROFILE_DIR"
        mkdir -p "$PS_PROFILE_DIR"
    fi

    if [[ -e "$PS_PROFILE" ]]; then
        echo "PowerShell profile already exists at: $PS_PROFILE"
        read -p "Overwrite? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Skipped."
            return
        fi
        rm "$PS_PROFILE"
    fi

    ln -s "$PROFILE_SOURCE" "$PS_PROFILE"

    if [[ -L "$PS_PROFILE" ]]; then
        echo "✓ PowerShell profile linked successfully"
    else
        echo "Error: Failed to create symlink for PowerShell profile"
        exit 1
    fi
}

# Optional: Set up bash profile to source pwsh-profile on startup
setup_bash_profile() {
    local bash_profile="$HOME/.bashrc"

    echo ""
    read -p "Also set up bash to load PowerShell profile? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        return
    fi

    if ! grep -q "Pwsh-Profile" "$bash_profile" 2>/dev/null; then
        echo "" >> "$bash_profile"
        echo "# Load PowerShell profile if available" >> "$bash_profile"
        echo "if command -v pwsh &> /dev/null; then" >> "$bash_profile"
        echo "    pwsh -NoProfile -File \"$PROFILE_SOURCE\"" >> "$bash_profile"
        echo "fi" >> "$bash_profile"
        echo "✓ Added PowerShell profile to $bash_profile"
    else
        echo "PowerShell profile already referenced in $bash_profile"
    fi
}

echo "Setting up PowerShell profiles on macOS..."
echo "Source: $PROFILE_SOURCE"
echo ""

setup_ps_profile
setup_bash_profile

echo ""
echo "Done!"

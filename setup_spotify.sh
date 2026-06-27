#!/usr/bin/env bash

set -e

echo "=== Starting Spotify & Spicetify Setup ==="

# Request administrator privileges upfront
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# 1. Install Spotify and Spicetify-cli
echo "--> Installing Spotify and Spicetify via yay..."
yay -S --needed --noconfirm spotify-launcher spicetify-cli

# 2. Configure PATH in both .bashrc and .zshrc
SPICETIFY_PATH='export PATH="$PATH:$HOME/.spicetify"'
for shell_rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
    if [ -f "$shell_rc" ]; then
        if ! grep -q ".spicetify" "$shell_rc"; then
            echo "--> Adding Spicetify to $(basename "$shell_rc") PATH..."
            echo "$SPICETIFY_PATH" >> "$shell_rc"
        fi
    fi
done

# Apply path to the current script execution environment
export PATH="$PATH:$HOME/.spicetify"

# 3. Install Spicetify Marketplace
echo "--> Installing Spicetify Marketplace..."
curl -fsSL https://raw.githubusercontent.com/spicetify/marketplace/main/resources/install.sh | sh

echo "============================================="
echo "=== SPOTIFY & SPICETIFY INSTALLED ==="
echo "============================================="
echo "Note: To apply themes/marketplace configurations:"
echo "1. Open Spotify at least once so it can initialize its directories."
echo "2. Close Spotify."
echo "3. Run: spicetify backup apply"
echo "============================================="

#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "=== Requesting administrator privileges upfront ==="
# Ask for sudo password upfront
sudo -v

# Keep-alive: update existing sudo time stamp if set, otherwise do nothing.
# Runs in the background and refreshes the sudo timestamp every 60 seconds.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo "=== Starting EndeavourOS Dev Setup Automation ==="

# 1. Update system databases
echo "--> Updating package databases..."
sudo pacman -Syu --noconfirm

# 2. Install official packages
echo "--> Installing Git, GitHub CLI, Docker, Zsh, PHP, and Composer..."
sudo pacman -S --needed --noconfirm git github-cli docker zsh php composer

# 3. Install AUR helper (yay) if not installed (EndeavourOS has it, but good for pure Arch)
if ! command -v yay &> /dev/null; then
    echo "--> yay not found. Installing yay..."
    sudo pacman -S --needed --noconfirm base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd -
fi

# 4. Install AUR packages (VS Code, FNM, Bun)
echo "--> Installing AUR packages (VS Code, FNM, Bun)..."
yay -S --needed --noconfirm visual-studio-code-bin fnm-bin bun-bin

# 5. Enable and configure Docker
echo "--> Enabling and starting Docker daemon..."
sudo systemctl enable --now docker
echo "--> Adding user $USER to the docker group..."
sudo usermod -aG docker "$USER"

# 6. Install Oh My Zsh if not already present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "--> Installing Oh My Zsh..."
    # Running non-interactively to prevent stopping the script
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "--> Oh My Zsh is already installed."
fi

# 7. Download Zsh Plugins
ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
echo "--> Downloading Zsh plugins (autosuggestions & syntax highlighting)..."

if [ ! -d "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting"
fi

# 8. Configure .zshrc plugins list if not already configured
ZSHRC="$HOME/.zshrc"
if [ -f "$ZSHRC" ]; then
    echo "--> Configuring plugins in .zshrc..."
    # Replace plugins=(git) with our list if it exists
    sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/g' "$ZSHRC"
fi

# 9. Configure fnm environment in both .bashrc and .zshrc
for shell_rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
    if [ -f "$shell_rc" ]; then
        if ! grep -q "fnm env" "$shell_rc"; then
            echo "--> Adding fnm hook to $(basename "$shell_rc")..."
            echo 'eval "$(fnm env --use-on-cd)"' >> "$shell_rc"
        fi
    fi
done

# 10. Enable pnpm in Node via Corepack (will take effect once Node is installed)
echo "--> Setting default Node.js version and enabling pnpm..."
# Load FNM environment in this script shell to run fnm commands
eval "$(fnm env)"
fnm install --lts
fnm default lts
corepack enable

echo "============================================="
echo "=== SETUP COMPLETE! ==="
echo "============================================="
echo "Please remember to:"
echo "1. Log out and log back in (or run 'newgrp docker') to use Docker without sudo."
echo "2. Open Konsole Settings -> Manage Profiles -> Edit -> Set Command to '/bin/zsh'."
echo "3. Run 'gh auth login' to authenticate with GitHub."
echo "============================================="

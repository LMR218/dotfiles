#!/usr/bin/env bash

set -e

echo "=== Starting Arch Linux Gaming Setup ==="

# Request administrator privileges upfront
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# 1. Check if multilib is enabled (needed for 32-bit Steam app)
if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
    echo "WARNING: [multilib] repository is not enabled in /etc/pacman.conf."
    echo "Steam requires 32-bit libraries. Please edit /etc/pacman.conf, uncomment the [multilib] section, and run this script again."
    exit 1
fi

# 2. Auto-detect GPU and select correct 32-bit Vulkan driver
VULKAN_DRIVER=""
if lspci | grep -i "nvidia" &> /dev/null; then
    echo "--> NVIDIA GPU detected. Selecting lib32-nvidia-utils..."
    VULKAN_DRIVER="lib32-nvidia-utils"
elif lspci | grep -i "amd" &> /dev/null; then
    echo "--> AMD GPU detected. Selecting lib32-vulkan-radeon..."
    VULKAN_DRIVER="lib32-vulkan-radeon"
elif lspci | grep -i "intel" &> /dev/null; then
    echo "--> Intel GPU detected. Selecting lib32-vulkan-intel..."
    VULKAN_DRIVER="lib32-vulkan-intel"
else
    echo "--> No dedicated GPU detected. Falling back to software rasterizer..."
    VULKAN_DRIVER="lib32-vulkan-swrast"
fi

# 3. Update databases and install Steam + Vulkan driver + Controller support
echo "--> Syncing databases and installing Steam, $VULKAN_DRIVER, and Steam Devices..."
sudo pacman -Syu --needed --noconfirm steam steam-devices "$VULKAN_DRIVER"

echo "============================================="
echo "=== GAMING SETUP COMPLETE ==="
echo "============================================="
echo "Note: If Steam fails to launch and says 'Steam is already running':"
echo "Run: killall -9 steam steamwebhelper"
echo "============================================="

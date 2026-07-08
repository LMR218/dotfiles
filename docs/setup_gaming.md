# Steam & Gaming Setup Script

This script automates the installation of Steam, its appropriate graphics drivers, and controller drivers on Arch Linux / EndeavourOS.

## What It Installs
* **`steam`**: The core Steam client launcher.
* **`steam-devices`**: System rules (udev rules) that allow Steam to detect and configure gaming controllers (Xbox, PlayStation, Nintendo Switch, Steam Controller, etc.).
* **32-Bit Vulkan Driver**: Automatically detected based on your GPU hardware.

---

## Technical Features

### GPU Vulkan Auto-Detection
Steam requires 32-bit Vulkan drivers to run. Instead of asking you to choose, the script scans your system hardware using `lspci` and automatically selects the correct driver:
* **NVIDIA**: Installs `lib32-nvidia-utils`.
* **AMD**: Installs `lib32-vulkan-radeon`.
* **Intel**: Installs `lib32-vulkan-intel`.
* **Fallback**: Installs `lib32-vulkan-swrast` (software rasterizer).

This makes the script 100% automated and hardware-agnostic.

---

## Troubleshooting Guide

### 1. Mirror 404 / Retrieve File Errors
If you see errors like `failed retrieving file ... from mirror: 404`, it means your local database is out of date, and Pacman is trying to download older package versions that no longer exist on the server.
* **Fix**: The script handles this by running `sudo pacman -Syu` to sync databases and perform a system update before installing Steam.

### 2. Steam is Already Running / Window Doesn't Open
If Steam fails to open and prints `Steam is already running, exiting` in the terminal, it means a background Steam process is frozen.
* **Fix**: Force-kill all Steam processes by running:
  ```bash
  killall -9 steam steamwebhelper
  ```

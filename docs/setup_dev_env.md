# EndeavourOS Development Environment Setup Script

This script automates the installation and configuration of a modern development environment on EndeavourOS (Arch-based Linux).

## What It Installs

### Official System Packages (via `pacman`)
* **Git**: The standard version control system.
* **GitHub CLI (`gh`)**: Command-line tool to manage pull requests, issues, and authentication with GitHub.
* **Docker**: A containerization platform to run isolated application environments.
* **Zsh**: A highly customizable shell designed for interactive use.
* **PHP**: The PHP hypertext preprocessor runtime language.
* **Composer**: The official package and dependency manager for PHP.

### AUR Packages (via `yay`)
* **VS Code (`visual-studio-code-bin`)**: The official Microsoft binary version of VS Code (enables full extension marketplace support).
* **FNM (`fnm-bin`)**: Fast Node Manager, a Rust-based Node.js version manager.
* **Bun (`bun-bin`)**: An all-in-one JavaScript/TypeScript runtime and toolkit.

### Configurations
* **Node.js**: Automatically installs the latest LTS version and sets it as the system default. Both Bash and Zsh are automatically configured to load the FNM environment.
* **pnpm**: Enabled via Node.js's built-in **Corepack** utility.
* **Oh My Zsh**: Installed and configured as the Zsh framework.
* **Zsh Plugins**:
  * `zsh-autosuggestions`: Shows terminal suggestions based on your command history.
  * `zsh-syntax-highlighting`: Colors valid commands green and invalid commands red in real-time.

---

## Technical Features

### Sudo Keep-Alive
Since some AUR packages can take a while to download or install, standard Linux caches might expire and ask for your password again, which prevents you from going AFK (Away From Keyboard).
This script runs a background loop that refreshes the `sudo` ticket every 60 seconds:
```bash
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
```
This loop monitors the main script's PID (`$$`) and terminates automatically when the main script finishes.

### Safe Package Checks (`--needed`)
The package installation commands use the `--needed` flag. If any of the requested packages are already installed on your system, the script will skip them, preventing unnecessary downloads and configurations.

---

## Post-Installation Steps

After running the script, you must manually complete these three quick steps:
1. **Apply Docker Permissions**: Log out and log back in, or run `newgrp docker` to run Docker commands without needing `sudo`.
2. **Set Default Terminal Shell**: Open Konsole (or your preferred terminal emulator) -> Settings -> Manage Profiles -> Edit -> set "Command" to `/bin/zsh`.
3. **GitHub Authentication**: Run `gh auth login` in your terminal to link your GitHub account.

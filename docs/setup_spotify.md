# Spotify & Spicetify Setup Script

This script automates the installation and customization of Spotify using **Spicetify** on EndeavourOS.

## What It Installs

* **`spotify-launcher`**: The recommended Spotify package for Arch Linux, which downloads official binaries directly from Spotify.
* **`spicetify-cli`**: Command-line tool to customize Spotify UI styles, inject CSS/JS, and configure extensions.
* **Spicetify Marketplace**: Adds a visual store tab directly inside the Spotify app to easily browse and install community-made themes, extensions, and snippets.

---

## Technical Details

### Path Customization
The script adds Spicetify's local path to both `.bashrc` and `.zshrc` to make the `spicetify` command globally accessible in all shell instances:
```bash
export PATH="$PATH:$HOME/.spicetify"
```

---

## How to Initialize Spicetify (Post-Installation)

Because Spicetify patches Spotify's client files, Spotify must be run at least once before configuring it.

1. **Launch Spotify** from your application menu. Log in to your account.
2. **Close Spotify** completely.
3. Open your terminal and run:
   ```bash
   spicetify backup apply
   ```
4. Spotify will open automatically with the default Spicetify theme and the **Marketplace** tab active on the left sidebar.

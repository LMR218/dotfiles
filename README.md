# LMR218's Dotfiles & Setup Scripts

Welcome to my personal system configurations and automation scripts repository! This repository is designed to help automate the setup and customization of my Arch-based (EndeavourOS) Linux development environments.

## Directory Structure

* `.zshrc` (Future addition): Zsh configuration files.
* `/docs`: Detailed documentation for individual setup scripts.
* `/setup_dev_env.sh`: Main script to automate the full developer stack.

---

## Available Scripts

### 1. Developer Environment Setup (`setup_dev_env.sh`)
Automates the installation of basic developer tools (Git, GitHub CLI, Docker, VS Code, Node.js, pnpm, Bun, and Zsh with autocompletions).

* **Full Documentation**: See [docs/setup_dev_env.md](docs/setup_dev_env.md) for details.
* **How to run**:
  ```bash
  curl -fsSL -O https://raw.githubusercontent.com/LMR218/dotfiles/main/setup_dev_env.sh && chmod +x setup_dev_env.sh && ./setup_dev_env.sh
  ```

---

## How to add future scripts to this repo

To add a new script to this environment:
1. Save your script in the root directory (e.g., `setup_another_tool.sh`).
2. Make it executable: `chmod +x setup_another_tool.sh`.
3. Create a detailed documentation file under `/docs` (e.g., `docs/setup_another_tool.md`).
4. Update this `README.md` file to list the new script and how to run it.
5. Push your changes to GitHub:
   ```bash
   git add .
   git commit -m "feat: add setup_another_tool script"
   git push origin main
   ```

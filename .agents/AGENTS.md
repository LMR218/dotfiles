# Repository Agent Guidelines: LMR218/dotfiles

Welcome, Agent! These guidelines define the standards and behavioral rules for contributing to the `LMR218/dotfiles` repository.

## Repository Purpose
This repository maintains personal system configuration automation scripts (`setup_<feature>.sh`) and documentation (`docs/setup_<feature>.md`) for Arch-based (EndeavourOS) and Debian-based (Ubuntu) Linux environments.

## Core Rules & Conventions

### 1. Script Architecture (Standalone & Idempotent)
- **Standalone:** Every script MUST be a self-contained executable file placed in the root directory (e.g., `setup_<feature>.sh`). Do NOT combine unrelated setup tasks into existing scripts unless explicitly instructed.
- **Idempotency:** Scripts must be safe to execute multiple times. Always check if configurations (e.g., `/etc/hosts` entries, directory structures, environment variables) exist before adding them to prevent duplicate entries.
- **Permissions:** Always ensure scripts have executable permissions (`chmod +x setup_<feature>.sh`).

### 2. Strict Pre-flight Dependency Checks (No Auto-Install)
- **Check Before Execution:** Every script MUST perform pre-flight checks for required software (e.g., `docker`, `docker compose`, `curl`, `sudo`).
- **Informative Failure:** If a required dependency is missing, log a clean error message detailing what is missing and how the user can install it, then exit with code `1`.
- **NO Unrequested Installations:** Never attempt to automatically install missing core software packages or system packages without explicit user approval.

### 3. Documentation Requirements
Whenever a new setup script is created or modified:
1. Create a dedicated Markdown file in `docs/setup_<feature>.md` detailing prerequisites, created directories, services, and execution one-liner.
2. Update the main `README.md` to include:
   - File listing under `## Directory Structure`
   - Detailed section with description, doc link, and standalone `curl` execution one-liner.

### 4. Code & Configuration Formatting
- Use `#!/usr/bin/env bash` and `set -euo pipefail` for all Bash scripts.
- Use modern Docker Compose (v2) syntax—do **NOT** include obsolete top-level `version:` keys in `docker-compose.yml`.
- Ensure clean output formatting using `echo "[INFO] ..."` and `echo "[ERROR] ..."`.

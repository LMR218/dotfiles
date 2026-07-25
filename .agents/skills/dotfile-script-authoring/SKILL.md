---
name: dotfile-script-authoring
description: Guidelines and template for authoring new standalone setup scripts and documentation in the LMR218/dotfiles repository. Use whenever creating or modifying setup scripts.
---

# Authoring Setup Scripts in LMR218/dotfiles

## Overview
This skill provides the mandatory structure and workflow for creating new system automation scripts in the `LMR218/dotfiles` repository.

## Workflow Requirements

When creating a new setup script `setup_<name>.sh`:

1. **Pre-flight Dependency Check Pattern:**
   Implement strict pre-flight dependency checking. Collect missing tools into an array and fail early with actionable user instructions:

   ```bash
   MISSING_DEPS=()
   if ! command -v tool_name >/dev/null 2>&1; then
       MISSING_DEPS+=("tool_name (Installation hint)")
   fi

   if [ ${#MISSING_DEPS[@]} -ne 0 ]; then
       echo "[ERROR] Missing required dependencies:"
       for dep in "${MISSING_DEPS[@]}"; do
           echo "  - $dep"
       done
       exit 1
   fi
   ```

2. **Idempotent Directory & File Creation:**
   Use `mkdir -p` and check if entries exist before appending to system files like `/etc/hosts`.

3. **Documentation Pair (`docs/setup_<name>.md`):**
   Create a matching documentation file in `docs/` containing:
   - Overview & Included Features
   - Prerequisites
   - One-liner execution command:
     `curl -fsSL -O https://raw.githubusercontent.com/LMR218/dotfiles/main/setup_<name>.sh && chmod +x setup_<name>.sh && ./setup_<name>.sh`
   - Created Directory Structure

4. **README Update:**
   Update `README.md` to add the script to the directory list and `## Available Scripts` section.

5. **Permissions:**
   Run `chmod +x setup_<name>.sh` before committing.

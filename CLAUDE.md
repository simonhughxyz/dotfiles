# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Ansible-driven personal dotfiles, applied locally against `localhost` (inventory: `inventory/hosts`) to configure a running machine.

Roles dispatch on `ansible_os_family` by including `vars/{{ ansible_os_family }}.yml` (existing files: `Void.yml`, `RedHat.yml`). To add a new distro, drop a `vars/<Family>.yml` per role with the right package names — there is no central `supported_distros` list.

## Setup

Use a plain Python venv with the pinned ansible from `requirements.txt`:

```bash
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

## Common commands

Vault password comes from `vault.sh` (which runs `pass pass`); this is wired into `ansible.cfg` as `vault_password_file`, so no `--ask-vault-pass` needed.

```bash
# Full apply (GUI + CLI), local machine
ansible-playbook dotfiles.yml

# CLI-only apply (skips niri/waybar/dunst/zathura/mpv/autofs)
ansible-playbook cli.yml

# Disable GUI roles even with dotfiles.yml
ansible-playbook dotfiles.yml -e "is_gui=false"

# Edit encrypted vault
ansible-vault edit group_vars/all/vault.yml
```

### Iterate on one role (tags)

Every role include is tagged with the role name. Categories: `bootstrap`, `system`, `gui`, `user`, plus each role name and each user name.

```bash
# Just re-deploy starship for all users (skip user-create + system roles)
ansible-playbook cli.yml --tags starship --skip-tags bootstrap

# Re-deploy all GUI roles only
ansible-playbook dotfiles.yml --tags gui

# Re-run autofs only
ansible-playbook dotfiles.yml --tags autofs --skip-tags bootstrap
```

The bootstrap play is tagged `bootstrap` so `--skip-tags bootstrap` is the default for iterative tweaks.

## Architecture

### Playbook layering

`dotfiles.yml` runs three plays in order:

1. **Bootstrap** (tag `bootstrap`) — runs the `user` role as root: installs base packages, creates the user from `user:` in `group_vars/all/vars.yml`, configures passwordless sudo, and (if `user_secret` is provided from vault) drops the SSH keypair.
2. **User roles** — iterates `user.roles` and runs each role with `become_user: {{ user.name }}` and `home: /home/{{ user.name }}`. Each role's tasks are tagged with the role name at runtime via `apply.tags`, so `--tags <role>` filters to just that role.
3. **System roles** (tag `system`, plus `gui` for GUI ones) — niri, waybar, dunst, zathura, mpv (gated on `is_gui`), and autofs. Run as root with `home: /home/{{ user.name }}`.

`cli.yml` is plays 1 and 2 only — no system-scoped GUI work.

### Role conventions

Every role follows the same skeleton (see `roles/shell/tasks/main.yml`, `roles/git/tasks/main.yml` for canonical examples):

1. `include_vars: "{{ ansible_os_family }}.yml"` from the role's `vars/`. The included file defines `<role>_packages` (always defined, possibly an empty list).
2. Install `<role>_packages` as root.
3. Deploy config under `{{ home }}/.config/<role>/` (or to `/etc` for system roles). Notify a handler on change where applicable.

When adding a new role:
- Create `roles/<name>/tasks/main.yml`, `roles/<name>/vars/Void.yml`, and `roles/<name>/vars/RedHat.yml` (plus any other distros you target). Each must define `<name>_packages` even if empty.
- For service/daemon-reload behaviour, add `roles/<name>/handlers/main.yml` and `notify:` from the config-deploy task.
- For tunable knobs, use `roles/<name>/defaults/main.yml`; reserve `vars/` for distro-specific facts only.
- For a per-user role, add its name to `user.roles` in `group_vars/all/vars.yml` rather than wiring it into `dotfiles.yml`.
- For a system/GUI role, add it to `dotfiles.yml` with `tags: [system, gui, <name>]` (drop `gui` if not GUI) and the appropriate `when:` guard.

### Variables and secrets

- `group_vars/all/vars.yml` — public config: `user` (single dict with `name`, `uid`, `shell`, `sudo`, `roles`), `is_gui`, `packages`, `git` identity. `user.roles` is the list of per-user roles to apply.
- `group_vars/all/vault.yml` — encrypted; expected to contain `user_secret` (with `ssh.private_key` / `ssh.public_key`) and any role-specific secrets like `etc.credentials` (consumed by `roles/autofs`).

### External-config roles

A few roles pull config from elsewhere rather than carrying it in this repo:
- `roles/nvim` clones `simonhughxyz/NeovimConfig` into `~/.config/nvim`, then runs `nvim --headless` to tangle a Neorg literate config and install Lazy/Treesitter packages. It stashes local changes first.
- `roles/shell` clones zsh plugins listed in `roles/shell/defaults/main.yml` into `~/.local/share/zsh/plugins/` and renders a loader from `plugin-list.zsh.j2`.
- `roles/password-store` clones a private git repo over SSH.

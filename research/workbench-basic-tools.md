# Workbench: basic-tools

Local web utility service from:
- https://github.com/PrincipleLabs67/workbench/tree/main/basic-tools

## Install (Debian)

- Prereqs: `sudo apt-get update && sudo apt-get install -y golang-go`
- Clone:
  - `mkdir -p ~/src`
  - `GIT_CONFIG_GLOBAL=/dev/null git clone https://github.com/PrincipleLabs67/workbench.git ~/src/workbench`
- Build:
  - `mkdir -p ~/.local/bin`
  - `cd ~/src/workbench/basic-tools && go build -o ~/.local/bin/basic-tools ./`

## systemd (auto-run)

We use a **user** service unit:
- `dotfiles/reference/systemd/user/basic-tools.service`

Install + enable:
- `mkdir -p ~/.config/systemd/user`
- `cp ~/dotfiles/reference/systemd/user/basic-tools.service ~/.config/systemd/user/basic-tools.service`
- `systemctl --user daemon-reload`
- `systemctl --user enable --now basic-tools.service`

To start at boot (even without an interactive login), enable lingering:
- `sudo loginctl enable-linger $USER`

## Bootstrap script

This repo includes:
- `dotfiles/scripts/install-workbench-basic-tools.sh`

It clones/updates the repo, builds `~/.local/bin/basic-tools`, installs the user unit, and enables it if `systemctl --user` is available.


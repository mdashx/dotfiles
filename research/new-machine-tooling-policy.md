# New Machine Tooling Policy

Working doc for “what we install by default on a new machine” and the minimum safe configuration for each tool.

## Principles

- Prefer distro packages (`apt`) unless there’s a clear reason not to.
- Prefer tools with reproducible, scriptable setup.
- Treat all cloud sync config as credential-bearing (don’t commit it; lock down permissions).

## Tools

### Workbench: basic-tools (local web utility service)

**Repo**
- `~/src/workbench` from https://github.com/PrincipleLabs67/workbench

**Bootstrap**
- `~/dotfiles/scripts/install-workbench-basic-tools.sh`

**systemd**
- User unit template: `~/dotfiles/reference/systemd/user/basic-tools.service`

### rclone (Google Drive)

**Use case**
- Cloud sync to Google Drive; for bidirectional sync use `rclone bisync`.

**Install**
- `sudo apt-get update && sudo apt-get install -y rclone`

**Credentials / what’s needed**
- No Google password needed.
- You (on a machine with a browser) run an OAuth flow and paste the resulting token JSON into `rclone config`.

**Config**
- Create a remote named `gdrive`: `rclone config`
- Headless auth: when prompted, choose “no auto config”, then run on your laptop:
  - `rclone authorize "drive" "eyJzY29wZSI6ImRyaXZlIn0"`
  - Paste the JSON output into the waiting `config_token>` prompt on the server.

**Local path convention**
- Local sync root: `~/gdrive`
- Drive sync root: `gdrive:raddev` (adjust as needed)

**Two-way sync (preferred: bisync)**
- First run (establish baseline):  
  - `rclone bisync ~/gdrive gdrive:raddev --resync --dry-run -P`
- Normal run:  
  - `rclone bisync ~/gdrive gdrive:raddev --dry-run -P`
- After verifying the output, re-run without `--dry-run`.
- Optional safety: add `--check-access` once both sides contain the expected sentinel file.

**Security**
- Treat `~/.config/rclone/rclone.conf` as a secret (contains refresh tokens).
- Lock down permissions: `chmod 600 ~/.config/rclone/rclone.conf`
- Consider setting an rclone config password via `rclone config` → “Set configuration password”.

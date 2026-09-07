#!/usr/bin/env bash
set -euo pipefail

repo_dir="${HOME}/src/workbench"
service_src="${HOME}/dotfiles/reference/systemd/user/basic-tools.service"
service_dst_dir="${HOME}/.config/systemd/user"
service_dst="${service_dst_dir}/basic-tools.service"

mkdir -p "${HOME}/src" "${HOME}/.local/bin"

if [ -d "${repo_dir}/.git" ]; then
  echo "Updating ${repo_dir}..."
  (
    cd "${repo_dir}"
    git remote set-url origin https://github.com/PrincipleLabs67/workbench.git
    # Avoid any global git URL rewrite rules.
    if ! GIT_CONFIG_GLOBAL=/dev/null git pull --ff-only; then
      echo "Warning: could not update repo (network or auth issue). Continuing with existing checkout." >&2
    fi
  )
else
  echo "Cloning workbench into ${repo_dir}..."
  # Avoid any global git URL rewrite rules.
  GIT_CONFIG_GLOBAL=/dev/null git clone https://github.com/PrincipleLabs67/workbench.git "${repo_dir}"
fi

if ! command -v go >/dev/null 2>&1; then
  echo "Missing 'go'. Install it first (Debian): sudo apt-get update && sudo apt-get install -y golang-go" >&2
  exit 1
fi

echo "Building basic-tools..."
(cd "${repo_dir}/basic-tools" && go build -o "${HOME}/.local/bin/basic-tools" ./)

echo "Installing systemd user unit..."
mkdir -p "${service_dst_dir}"
cp "${service_src}" "${service_dst}"

if command -v systemctl >/dev/null 2>&1; then
  if systemctl --user daemon-reload >/dev/null 2>&1; then
    systemctl --user daemon-reload
    systemctl --user enable --now basic-tools.service
    systemctl --user status basic-tools.service --no-pager || true
  else
    echo "systemctl is present but user bus is not available in this environment." >&2
    echo "To enable on a normal machine:" >&2
    echo "  systemctl --user daemon-reload" >&2
    echo "  systemctl --user enable --now basic-tools.service" >&2
  fi
fi

echo "Done."

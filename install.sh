#!/usr/bin/env bash
set -euo pipefail
repo_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
config_dir="$HOME/.config/waybar"
if ! command -v waybar >/dev/null 2>&1; then
  printf 'Waybar is required. Install it with: omarchy pkg add waybar\n' >&2
  exit 1
fi
if [[ -e "$config_dir" && ! "$config_dir" -ef "$repo_dir" ]]; then
  mv "$config_dir" "$config_dir.bak.$(date +%Y%m%d%H%M%S)"
fi
ln -sfn "$repo_dir" "$config_dir"
chmod +x "$repo_dir/scripts/updates.sh"
printf 'Spectra config linked at %s\n' "$config_dir"
printf 'Omarchy v4 starts its own shell bar. See README.md for the optional switch to Waybar.\n'

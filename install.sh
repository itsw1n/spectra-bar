#!/usr/bin/env bash
set -euo pipefail
repo_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
plugin_dir="$HOME/.config/omarchy/plugins/itsw1n.spectra-bar"
shell_config="$HOME/.config/omarchy/shell.json"
[[ -f "$shell_config" ]] || { echo "Omarchy v4 shell.json is missing" >&2; exit 1; }
python -m json.tool "$repo_dir/manifest.json" >/dev/null
python -m json.tool "$repo_dir/layout.json" >/dev/null
mkdir -p "$(dirname "$plugin_dir")"
if [[ -e "$plugin_dir" || -L "$plugin_dir" ]]; then
  backup_dir="$HOME/.local/state/spectra-bar/backups"
  mkdir -p "$backup_dir"
  mv "$plugin_dir" "$backup_dir/itsw1n.spectra-bar.$(date +%Y%m%d%H%M%S)"
fi
mkdir -p "$plugin_dir"
cp "$repo_dir/Bar.qml" "$repo_dir/BarModel.js" "$repo_dir/manifest.json" "$plugin_dir/"
mkdir -p "$plugin_dir/scripts"
cp "$repo_dir/scripts/stats.sh" "$plugin_dir/scripts/"
cp "$shell_config" "$shell_config.bak.$(date +%Y%m%d%H%M%S)"
python - "$shell_config" "$repo_dir/layout.json" <<'PY'
import json, sys
from pathlib import Path
config_path, layout_path = map(Path, sys.argv[1:])
config = json.loads(config_path.read_text())
config['bar'] = json.loads(layout_path.read_text())
config_path.write_text(json.dumps(config, indent=2) + '\n')
PY
omarchy toggle bar off
omarchy-shell shell rescanPlugins
omarchy bar use itsw1n.spectra-bar
printf 'Spectra Bar installed. Previous shell config saved beside %s\n' "$shell_config"

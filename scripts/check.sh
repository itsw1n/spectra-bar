#!/usr/bin/env bash
# Read-only checks; QML imports and behavior also need validation in the shell.
set -euo pipefail
repo_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
cd "$repo_dir"

qml_formatter=${QMLFORMAT:-/usr/lib/qt6/bin/qmlformat}
[[ -x "$qml_formatter" ]] || {
  echo "Qt 6 qmlformat is required. Set QMLFORMAT to its executable path." >&2
  exit 1
}

python3 -m json.tool manifest.json >/dev/null
python3 -m json.tool layout.json >/dev/null
bash -n install.sh scripts/*.sh
for file in Bar.qml components/*.qml components/bar/*.qml components/hub/*.qml; do
  "$qml_formatter" -n "$file" >/dev/null
done
git diff --check
printf 'JSON, shell syntax, QML parsing, and whitespace checks passed.\n'

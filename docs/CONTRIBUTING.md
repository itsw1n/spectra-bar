# Contributing

## Before changing code

Spectra Bar is a custom Omarchy bar plugin, not a replacement for Omarchy's native widgets. [`Bar.qml`](../Bar.qml) and [`BarModel.js`](../BarModel.js) are derived from the Omarchy 4.0.6 bar engine. Compare them with the installed Omarchy version before making engine-level changes.

Prefer changes in this repository's own layers:

- `components/` for prism surfaces, the Arch badge, workspaces, and the control hub
- `Theme.qml` for shared dimensions and colors
- `layout.json` for module order and actions
- `scripts/` for small command modules

Keep native widget behavior and shell IPC intact unless a change explicitly requires otherwise.

## Validate changes

Run the lightweight checks before opening a pull request:

```bash
python -m json.tool manifest.json >/dev/null
python -m json.tool layout.json >/dev/null
bash -n install.sh scripts/stats.sh
git diff --check
```

When changing QML, install the plugin locally and verify the bar on at least one display size. Check the centered badge, inactive modules, native popups, scroll actions, and the bar's hidden state.

## Pull requests

- Keep commits focused and describe the user-visible behavior.
- Do not commit shell backups, generated runtime state, or temporary screenshots.
- Include screenshots only when they document a final behavior or visual change.
- Explain any dependency on a specific Omarchy or Quickshell version.

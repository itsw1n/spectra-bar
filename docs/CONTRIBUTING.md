# Contributing

## Before changing code

Spectra Bar is a custom Omarchy bar plugin, not a replacement for Omarchy's native widgets. [`Bar.qml`](../Bar.qml) and [`BarModel.js`](../BarModel.js) are derived from the Omarchy 4.0.6 bar engine. Compare them with the installed Omarchy version before making engine-level changes.

Prefer changes in this repository's own layers:

- `components/bar/` for module loading, sections, tooltips, and drag input
- `components/hub/` for the control hub and its native Omarchy adapter
- `components/*.qml` for prism surfaces, the Arch badge, and workspaces
- `Theme.qml` for shared dimensions and colors
- `layout.json` for module order and actions
- `scripts/` for small command modules

Keep native widget behavior and shell IPC intact unless a change explicitly requires otherwise.

## Validate changes

Run the lightweight checks before opening a pull request:

```bash
bash scripts/check.sh
```

See [architecture.md](architecture.md) for component responsibilities and the
shared state that remains in the bar entry point.

The checker uses Qt 6's `qmlformat` to parse QML without modifying it. Override
`QMLFORMAT` if Qt 6 is installed elsewhere. Parsing does not validate the host's
`qs.*` imports or runtime behavior; those require the live checks below.

When changing QML, install the plugin locally and verify the bar on at least one display size. Check the centered badge, inactive modules, native popups, scroll actions, and the bar's hidden state.

## Pull requests

- Keep commits focused and describe the user-visible behavior.
- Do not commit shell backups, generated runtime state, or temporary screenshots.
- Include screenshots only when they document a final behavior or visual change.
- Explain any dependency on a specific Omarchy or Quickshell version.

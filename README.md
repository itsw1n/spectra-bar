# Spectra Bar

<img width="1920" height="700" alt="image" src="https://github.com/user-attachments/assets/589a363b-be15-4e7d-8a82-adf971bfe0fd" />

A sharp, native [Omarchy](https://omarchy.org/) v4 bar for [Quickshell](https://quickshell.org/), inspired by the Spectra reference design. It keeps Omarchy's native widgets and panels while adding a compact prism-style frame, centered Arch badge, sliding workspaces, per-entry actions, and an Arch control hub.

## Highlights

- Native Omarchy menu, workspaces, window title, clock, media, audio, network, Bluetooth, monitor, power, and update widgets
- Centered Arch badge with a click-to-open control hub
- Per-module click, right-click, middle-click, and scroll actions in `layout.json`
- Responsive prism panels with inactive-state placeholders
- CPU, memory, temperature, and disk usage stats
- Installer backups and a one-command rollback to the stock bar

## Install

Requirements: Omarchy v4 and a working Quickshell bar environment.

```bash
git clone https://github.com/itsw1n/spectra-bar.git
cd spectra-bar
./install.sh
```

The installer validates the manifest and plugin files, backs up the current Omarchy shell configuration, installs the plugin under `~/.config/omarchy/plugins/`, and selects Spectra. Restart or reload the shell if the bar does not appear immediately.

To return to the stock bar:

```bash
omarchy bar use omarchy.bar
```

The installer keeps timestamped shell backups and previous plugin copies so the previous configuration can be restored if needed.

## Customize

Edit [`layout.json`](layout.json) to change module order, spacing-related settings, or actions. The layout supports entries such as:

```json
{
  "id": "omarchy.monitor",
  "onScrollUp": "omarchy-brightness-display +2%",
  "onScrollDown": "omarchy-brightness-display 2%-"
}
```

Visual constants live in [`Theme.qml`](Theme.qml). Reusable surfaces and widgets are in [`components/`](components/). The bar engine and layout model are [`Bar.qml`](Bar.qml) and [`BarModel.js`](BarModel.js).

## Development

```bash
python -m json.tool manifest.json >/dev/null
python -m json.tool layout.json >/dev/null
bash -n install.sh scripts/stats.sh
```

See [`docs/CONTRIBUTING.md`](docs/CONTRIBUTING.md) for the development workflow and Omarchy compatibility notes. [`docs/geometry-goal.md`](docs/geometry-goal.md) records the visual constraints for future bar refinements.

## License

MIT. See [`LICENSE`](LICENSE).

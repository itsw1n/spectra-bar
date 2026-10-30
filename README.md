# Spectra Bar

An Omarchy v4 shell bar based on the supplied Spectra reference. Its chamfered sections use QtQuick Shapes, while the widgets remain native. This is a custom native bar: it uses Omarchy's existing menu, workspaces, active-window, clock, updates, media, audio, Wi-Fi, Bluetooth, and power widgets and their working panels.

## Install

```bash
git clone https://github.com/itsw1n/spectra-bar.git
cd spectra-bar
./install.sh
```

The installer backs up `~/.config/omarchy/shell.json`, copies the plugin into `~/.config/omarchy/plugins/`, applies the layout, and selects Spectra. Run `omarchy bar use omarchy.bar` to return to the stock bar. Restore the saved `shell.json.bak.*` to restore the previous widget layout.

`Bar.qml` and `BarModel.js` are derived from the Omarchy 4.0.6 built-in bar. The shell and native widget implementations are owned by Omarchy; this repo changes the shell frame and adds a small telemetry command. When Omarchy updates its bar engine, compare these two files with the new built-in versions before updating Spectra.

## Structure and validation

- `components/PrismPanel.qml`: reusable inset graphite surfaces, diagonal joins, and restrained edge accents.
- `components/ArchBadge.qml` and `PrismConnector.qml`: layered central badge and triangular shoulder facets.
- `Theme.qml`: shared dimensions and colors.
- `layout.json`: native widget placement, with the Arch badge anchored to the physical screen center.
- `Bar.qml`: Omarchy 4.0.6 bar engine with small SPECTRA-specific layout changes.
- [Visual validation](docs/visual-validation.md): real Quickshell screenshots at 1366, 1920, and 2560 pixels, plus known differences from the reference.
- [Saved geometry goal](docs/geometry-goal.md): approved reference and the constraints for future refinements.

The installer saves prior shell and plugin state before activation. To roll back, select `omarchy.bar` and restore the latest `shell.json.bak.*` if you also want the old widget layout.

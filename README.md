# Spectra Bar

An Omarchy v4 shell bar based on the supplied Spectra reference. This is a custom native bar: it uses Omarchy's existing menu, workspaces, active-window, clock, updates, media, audio, Wi-Fi, Bluetooth, and power widgets and their working panels.

## Install

```bash
git clone https://github.com/itsw1n/spectra-bar.git
cd spectra-bar
./install.sh
```

The installer backs up `~/.config/omarchy/shell.json`, copies the plugin into `~/.config/omarchy/plugins/`, applies the layout, and selects Spectra. Run `omarchy bar use omarchy.bar` to return to the stock bar. Restore the saved `shell.json.bak.*` to restore the previous widget layout.

`Bar.qml` and `BarModel.js` are derived from the Omarchy 4.0.6 built-in bar. The shell and native widget implementations are owned by Omarchy; this repo changes the shell frame and adds a small telemetry command. When Omarchy updates its bar engine, compare these two files with the new built-in versions before updating Spectra.

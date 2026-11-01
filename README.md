# Spectra Bar

<img width="1920" height="52" alt="image" src="https://github.com/user-attachments/assets/4594f280-a9b2-459e-aae8-bf85b4777375" />

A native [Omarchy](https://omarchy.org/) v4 bar for [Quickshell](https://quickshell.org/), inspired by the Spectra reference design and [MechaBar](https://github.com/sejjy/mechabar).

Install Spectra directly on an existing Omarchy v4 desktop. This repository
contains the bar's code, configuration, and installer.

<img width="1920" height="660" alt="image" src="https://github.com/user-attachments/assets/e9523d0d-5571-4bb5-8646-b2ce1f1c3516" />

## Important highlights

- Native Omarchy widgets and panels
- Centered Arch badge with a control hub
- Sliding workspaces and responsive prism panels
- Per-module click, middle-click, right-click, and scroll actions
- CPU, memory, and temperature statistics
- Installer backups and rollback support

## Installation

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

## Arch Control Hub

Click the Arch badge to open the hub. Use **↑/↓** (or **j/k**) to select a row,
**Tab/Shift+Tab** to move forward/back, **Enter/Space** to activate, and **Esc**
to close. Unavailable controls are skipped.

**AI Usage** opens Omarchy's native agent dashboard for usage, limits, and token
history. In that panel, **←/→** switches providers and **Esc** closes it.
Accounts and usage records come from the AI tools configured on the machine;
Spectra does not include account credentials.

The hub can also be opened with `omarchy-shell spectra.hub open`.

## Configuration

[`layout.json`](layout.json) defines the module order and actions applied by the
installer. For example, this entry changes brightness when scrolling:

```json
{
  "id": "omarchy.monitor",
  "onScrollUp": "omarchy-brightness-display +2%",
  "onScrollDown": "omarchy-brightness-display 2%-"
}
```

For an installed bar, the active settings are in `~/.config/omarchy/shell.json`
under `bar`. Changes to this repository's `layout.json` take effect when running
`./install.sh` again; the installer applies the whole layout from that file.
Shared colors and dimensions are in [`Theme.qml`](Theme.qml).

For a file map and component responsibilities, see [`docs/architecture.md`](docs/architecture.md). Development checks and Omarchy compatibility notes are in [`docs/CONTRIBUTING.md`](docs/CONTRIBUTING.md); visual constraints are in [`docs/geometry-goal.md`](docs/geometry-goal.md).

## License

MIT. See [`LICENSE`](LICENSE).

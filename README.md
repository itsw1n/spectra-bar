# Spectra Bar

A dark, blue angular-inspired Waybar for Omarchy v4. Based on a visual reference with a workspace strip, active window, system telemetry, centered emblem, date, media, and status controls.

## Install

Requires Waybar, a Nerd Font, and optional `pacman-contrib` for update counts. On Omarchy:

```bash
omarchy pkg add waybar pacman-contrib
systemctl --user import-environment WAYLAND_DISPLAY HYPRLAND_INSTANCE_SIGNATURE
./install.sh
```

The installer links this repository to `~/.config/waybar` and backs up an existing config. Run `waybar -c ~/.config/waybar/config.jsonc -s ~/.config/waybar/style.css` to preview it.

Omarchy v4 starts its Quickshell bar by default. Hide only that bar with `omarchy toggle bar off`; the shell still serves menus, notifications, and panels. To start Waybar when Hyprland starts, add this to `~/.config/hypr/autostart.lua`:

```lua
hl.on("hyprland.start", function()
  hl.exec_cmd(o.launch("waybar"))
end)
```

Restore the Omarchy bar with `omarchy toggle bar on`. The Waybar config uses v4 `omarchy-shell shell toggle` actions for audio, network, Bluetooth, and power panels.

## Layout

- Left: Spectra label, workspaces, active window
- Center: temperature, CPU, memory, emblem, clock, available updates
- Right: MPRIS media and device controls

Colors and spacing live in `style.css`. The original Waybar setup was used as a feature reference; this configuration is written from scratch.

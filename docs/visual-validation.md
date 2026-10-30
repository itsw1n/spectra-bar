# Visual validation

These are captures from the running Omarchy 4.0.6 Quickshell bar. Temporary Hyprland headless outputs supplied the 1366 and 2560 logical pixel widths at 1× scale; the laptop display is 1920 physical pixels at 1.25× scale. The headless output was removed after capture.

| Width | Rendered capture | Checked result |
| --- | --- | --- |
| 1366 | [Long window and media titles](screenshots/1366-long-titles.png) | Both titles truncate inside their plates; the Arch badge center is x=683. |
| 1920 physical | [Compact geometry, inactive media](screenshots/1920-prism.png) | 1536 logical pixels wide at 1.25× scale; badge center is x=960 physical. |
| 2560 | [Long window and media titles](screenshots/2560-long-media.png) | Angular groups expand symmetrically; badge center is x=1280. |
| 1366 | [Inactive media](screenshots/1366-inactive-media.png) | The small `No media` placeholder retains the right side's shape. |
| 1366 | [Workspace 2](screenshots/1366-workspace-2.png) | The native workspace state changes without shifting the bar. |

`hyprctl layers -j` reports an `omarchy-bar` surface of **32 logical pixels** high. This is **40 physical pixels** on the 1.25× laptop panel. Main segments are 26 logical pixels high; the center badge is 32. Segment joins are visually around 2–3 logical pixels. Long text stays within the inner plates at 1366 and 2560. The original Waybar used automatic height, a 12px stylesheet font, and 4px outer spacing; its compact density informed these dimensions.

The approved reference has extra inset bevel details and precise glyph placements that are not exposed by Omarchy's native widget renderers. SPECTRA matches the main flat chamfered silhouette, central badge, compact density, and left/right balance. Native widget text and icons can differ with theme and state. The layout deliberately keeps native media, audio, network, Bluetooth, power, update, and mode widgets. Network, audio, and Bluetooth panels opened from the running shell through their native IPC targets. Pointer click automation was unavailable, so those exact hit targets were not separately exercised.

`Bar.qml` remains derived from Omarchy's bar engine because v4.0.6 has no public hook for the section geometry. SPECTRA's frame changes are localized to sizing and placement of `SpectraSegment`; colors and sizes are in `SpectraTokens.js`. Compare the derived engine with the installed Omarchy version before a major shell upgrade.

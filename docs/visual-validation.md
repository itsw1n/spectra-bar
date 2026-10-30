# Visual validation

The approved source is preserved as [goal.png](goal.png). All implementation captures below are from the running Omarchy 4.0.6 Quickshell bar. The laptop runs at 1920 physical pixels and 1.25× scale. Temporary headless outputs supplied 1366 and 2560 logical pixels at 1× scale and were removed after capture.

| Width | Capture | Checked result |
| --- | --- | --- |
| 1366 | [Long window and media titles](screenshots/1366-long-titles.png) | Titles remain within their diagonal sections; badge center x=683. |
| 1920 physical | [Full bar with active media](screenshots/1920-prism.png) | 1536 logical pixels, 40 physical pixels high; badge center x=960 physical. |
| 2560 | [Long titles](screenshots/2560-long-media.png) | Shared slopes remain aligned; badge center x=1280. |
| 1366 | [Inactive media](screenshots/1366-inactive-media.png) | Placeholder retains the media face and utility divider. |

The surface measured by `hyprctl layers -j` is 1536×32 logical pixels on the laptop. Main panels remain 26 logical pixels high; the badge remains 32. Module widths, order, and native widget behavior were not changed in this geometry pass.

## Incremental native-resolution captures

1. [Bar before refinement](iterations/00-before.png)
2. [Layered badge and facets](iterations/01-center-badge.png)
3. [Clock panel](iterations/02-clock-panel.png)
4. [Media panel](iterations/03-media-panel.png)
5. [Utility frame](iterations/04-utility-panel.png)
6. [Geometry applied throughout](iterations/05-full-prism.png)

The badge body now has a height-based aspect ratio inside the existing centered slot, two subtle outlines, a recessed dark face, and an SVG Arch mark. Small mirrored triangles bridge into the adjoining shoulders. Panels use full-height slants instead of pointed hexagonal ends. A single outer frame surrounds each section; embedded media and window faces omit a second horizontal outline. Graphite backing and a short upper bevel provide depth without gradients or glow.

Compared with the source, the silhouette, side facets, and diagonal surface relationships are much closer. Exact lighting and soft reflections remain simplified into flat QML surfaces. The compact height and native widget typography produce different proportions and internal spacing from the 65px-high reference. These captures establish the actual result; they do not imply a pixel-identical reproduction.

Native audio, Wi-Fi, and Bluetooth panels were opened and visually inspected through their shell IPC targets after installation. Long titles and inactive media were checked at 1366px; active media was also checked at 1920 and 2560px. Pointer click automation was unavailable, so exact pointer hit targets were not separately exercised. The layout JSON and native widget implementations remain unchanged. Plugin validation, QML parsing, shell responsiveness, and installer syntax checks passed.

`Bar.qml` and `BarModel.js` remain derived from Omarchy 4.0.6. Geometry is isolated in `components/`; shared styling is in `Theme.qml`. The installer copies these files and checks they exist before moving the installed plugin into its backup directory. Compare the derived engine with upstream before a major Omarchy shell upgrade.

Rollback to the stock bar with `omarchy bar use omarchy.bar`. Previous plugin copies are retained under `~/.local/state/spectra-bar/backups/`; timestamped shell configuration backups remain beside `~/.config/omarchy/shell.json`.

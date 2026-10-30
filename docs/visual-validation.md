# Visual validation

Captures are from the running Omarchy 4.0.6 Quickshell on Hyprland. The 1366 and 2560 captures used temporary headless outputs, removed after capture. The 1920 capture used the laptop output at 1.25 scale. Screenshots show only the bar.

| Width | Capture | Result |
| --- | --- | --- |
| 1366 | [Long window and media titles](screenshots/1366-long-titles.png) | Both titles stay inside their angled plates; the badge is centered at x=683. |
| 1920 | [Prism geometry](screenshots/1920-prism.png) | Left and right groups balance around the center badge. Physical screenshot is 2400px because display scale is 1.25. |
| 2560 | [Long media title](screenshots/2560-long-media.png) | Groups expand proportionally; the badge is centered at x=1280. |

Also checked inactive media at 1366 and 2560: the media plate remains with a `No media` label, preserving visual balance. Native media scrolling handles longer titles.

The supplied reference uses extra fine bevels and specific glyph placement inside each section. SPECTRA currently reproduces the main chamfered silhouette and central badge. Native Omarchy widgets retain their own text, icons, and popups, so exact internal typography and state-specific spacing will differ from the static reference. Replacing those internals would require cloning widgets and would increase maintenance risk.

`Bar.qml` remains a copy of Omarchy's bar engine because v4.0.6 does not expose a public hook for changing section geometry inside its built-in bar. The SPECTRA changes to that file are limited to layout sizing and insertion of `SpectraSegment`; all colors and dimensions are in `SpectraTokens.js`. Compare `Bar.qml` against the installed Omarchy version before upgrading the plugin across major shell changes.

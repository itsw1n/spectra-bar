# File guide

Spectra is an Omarchy v4 bar plugin. It provides the bar's appearance and layout
while using Omarchy's native widgets, panels, and AI usage collection.

## Where to make a change

| Change | File or folder |
| --- | --- |
| Module order, options, click and scroll commands | `layout.json` |
| Shared colors, dimensions, responsive widths | `Theme.qml` |
| Bar windows, shell API, shared state and layout persistence | `Bar.qml` |
| Layout normalization and configuration helpers | `BarModel.js` |
| Module loading, placement, tooltips and pointer handling | `components/bar/` |
| Hub layout, selection and keyboard navigation | `components/hub/ArchControlHub.qml` |
| Hub row presentation and mouse input | `components/hub/HubControlRow.qml` |
| Hub integration with native Omarchy controls and AI panel | `components/hub/OmarchyControls.qml` |
| Prism surfaces, badge and workspace visuals | `components/*.qml` |
| System statistics command | `scripts/stats.sh` |

## Bar components

`Bar.qml` creates a window per display and passes itself explicitly as `barRoot`
to the extracted components. It owns shared state and the API used by native
widgets; components must not rely on IDs from its private QML scope.

- `BarSection.qml` presents a horizontal or vertical list of modules.
- `CenterSection.qml` arranges modules around the centered anchor.
- `ModuleSlot.qml` loads a native widget, custom QML module, command module,
  or the hub, and applies its presentation and action overrides.
- `CommandModule.qml` collects command output and refreshes it on a timer.
- `BarTooltip.qml` anchors a tooltip to its owning display's bar window.
- `BarDragController.qml` handles module pointer actions and reordering gestures.
- `BarMoveGesture.qml` handles dragging the bar to another screen edge.
- `DragGhostPanel.qml` and `BarMoveGhostPanel.qml` show noninteractive previews.

Drag state, drop calculations, tooltip timing, widget registration, and shell
configuration writes remain in `Bar.qml` because they coordinate multiple
windows and modules. This is a component extraction, not a replacement engine.

## Native Omarchy boundary

`OmarchyControls.qml` owns native control paths, loading, property injection,
button discovery, status interpretation, and optional-tool detection. Hub rows
use its status and activation methods. The persistent AI adapter stays on the
bar surface so its native popup retains a valid anchor after the hub closes.

AI accounts and usage collection belong to Omarchy and the installed AI tools.
Spectra does not store credentials or calculate subscription limits.

The engine was derived from Omarchy 4.0.6. After an Omarchy upgrade, check both
the host bar API and this adapter against the installed native components.

## Checking changes

Use the checks in [CONTRIBUTING.md](CONTRIBUTING.md), then inspect the running
bar: module actions, tooltips, hub keyboard navigation, AI popup, module
reordering, bar positioning, hiding, and each available display.

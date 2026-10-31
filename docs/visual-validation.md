# Visual validation

Compare the [reference](../assets/spectra-bar.png) with the [current 1920×40 capture](screenshots/1920-center-current.png). The running bar measured 1536×32 logical pixels with `hyprctl layers -j` on the 1.25× laptop display.

The [empty workspace capture](screenshots/desktop-tab-state.png) shows that the workspace tabs stay on the left and the active-window panel displays “Desktop”. Returning to a workspace with a window restores its title. The current idle media state displays “No media”; the native media widget replaces that label when Omarchy reports an active track.

A QML name collision had previously left native modules empty after a shell restart: `controlHubModule` was both a boolean property and a `Component` ID. The component was renamed, and the boolean is explicitly qualified where used. The active-window slot now keeps its height when the native widget hides, so the Desktop panel does not collapse.

The shared bar height and neighboring panel slopes remain at their earlier compact values. The Arch badge and mark were narrowed to match the reference more closely. The reference's soft reflections remain approximated with flat QML surfaces.

import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Commons
import qs.Ui

PanelWindow {
    id: moveGhostWindow

    required property var barRoot
    required property var ghostScreen
    readonly property bool screenMatches: barRoot.barMoveScreen === ghostScreen || (barRoot.barMoveScreen && ghostScreen && barRoot.barMoveScreen.name && ghostScreen.name && barRoot.barMoveScreen.name === ghostScreen.name)

    visible: barRoot.barMoveActive && screenMatches
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.namespace: "omarchy-bar-move-ghost"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    // One fixed-geometry slab per edge, crossfaded on candidate changes.
    // Resizing a single slab between edges repaints mid-transition and
    // flickers; fading between static ones does not.
    Repeater {
        model: ["top", "bottom", "left", "right"]

        BorderSurface {
            id: edgeSlab

            required property string modelData
            readonly property bool edgeVertical: modelData === "left" || modelData === "right"
            readonly property int edgeSize: edgeVertical ? Style.bar.sizeVertical : Style.bar.sizeHorizontal

            x: modelData === "right" ? parent.width - edgeSize : 0
            y: modelData === "bottom" ? parent.height - edgeSize : 0
            width: edgeVertical ? edgeSize : parent.width
            height: edgeVertical ? parent.height : edgeSize
            color: barRoot.transparent ? "transparent" : barRoot.background
            borderSpec: Border.flat(barRoot.barForeground, 1)
            visible: opacity > 0
            opacity: barRoot.barMoveCandidate === modelData ? (barRoot.transparent ? 0.45 : 0.7) : 0

            Behavior on opacity {
                NumberAnimation {
                    duration: 140
                    easing.type: Easing.OutCubic
                }

            }

        }

    }

    // Visual-only preview of the candidate edge. Keep the input region empty
    // so the overlay never steals the gesture area's active pointer grab.
    mask: Region {
    }

}

import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Commons
import qs.Commons as Commons
import qs.Ui

PanelWindow {
    id: ghostWindow

    required property var barRoot
    required property var ghostScreen
    readonly property bool screenMatches: barRoot.barDragScreen === ghostScreen || (barRoot.barDragScreen && ghostScreen && barRoot.barDragScreen.name && ghostScreen.name && barRoot.barDragScreen.name === ghostScreen.name)
    readonly property bool active: barRoot.barDragSource && barRoot.barDragScreen && screenMatches
    readonly property var sourceItem: barRoot.barDragSource ? barRoot.barDragSource.activeItem : null
    readonly property int ghostPadding: Style.space(1)
    readonly property int ghostWidth: sourceItem ? Math.max(1, Math.ceil(sourceItem.width)) : 1
    readonly property int ghostHeight: sourceItem ? Math.max(1, Math.ceil(sourceItem.height)) : 1

    visible: active && sourceItem !== null
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.namespace: "omarchy-bar-drag-ghost"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    Item {
        visible: ghostWindow.visible
        x: Math.round(barRoot.barDragScreenX - barRoot.barDragOffsetX - ghostWindow.ghostPadding)
        y: Math.round(barRoot.barDragScreenY - barRoot.barDragOffsetY - ghostWindow.ghostPadding)
        width: ghostWindow.ghostWidth + ghostWindow.ghostPadding * 2
        height: ghostWindow.ghostHeight + ghostWindow.ghostPadding * 2

        BorderSurface {
            anchors.fill: parent
            color: barRoot.transparent ? "transparent" : barRoot.background
            borderSpec: Border.flat(barRoot.barForeground, 1)
            radius: Math.min(Style.cornerRadius, height / 2)
            opacity: barRoot.transparent ? 0.45 : 0.94
        }

        Image {
            anchors.fill: parent
            anchors.margins: ghostWindow.ghostPadding
            source: barRoot.barDragImageUrl
            fillMode: Image.Stretch
            smooth: true
            opacity: 0.84
        }

    }

    Rectangle {
        readonly property var targetRect: barRoot.barDragTargetGeometry

        visible: ghostWindow.active && targetRect !== null
        x: targetRect ? Math.round(targetRect.x) : 0
        y: targetRect ? Math.round(targetRect.y) : 0
        width: targetRect ? targetRect.width : 0
        height: targetRect ? targetRect.height : 0
        color: Commons.Color.accent
        radius: Math.min(width, height) / 2
    }

    // Visual-only drag feedback. Keep the input region empty so the ghost can
    // sit under the cursor without stealing the MouseArea's active pointer grab.
    mask: Region {
    }

}

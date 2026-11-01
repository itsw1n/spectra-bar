import QtQuick
import qs.Commons

MouseArea {
    // Do not assign drag.target here: ModuleSlot is owned by Row/Column
    // positioners, and mutating slot.x/slot.y can leave stale offsets that
    // make neighboring modules overlap after a small aborted drag.

    id: modulePointer

    required property var barRoot
    required property var slot
    required property var hoverSource
    property bool dragging: false
    property bool suppressClick: false
    property real pressedX: 0
    property real pressedY: 0
    readonly property bool canReorder: barRoot.shell && typeof barRoot.shell.mutateShellConfig === "function"
    readonly property real dragThreshold: Style.space(4)

    anchors.fill: parent
    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
    enabled: slot.visible && slot.width > 0 && slot.height > 0
    propagateComposedEvents: true
    // Only the hovered slot needs the hit test; without the guard every
    // slot on every monitor re-ran it on each click target change.
    cursorShape: hoverSource.hovered && barRoot.moduleClickTargetAt(slot, mouseX, mouseY) ? Qt.PointingHandCursor : Qt.ArrowCursor
    onPressed: function(mouse) {
        dragging = false;
        suppressClick = false;
        pressedX = mouse.x;
        pressedY = mouse.y;
        barRoot.clearBarDrag();
    }
    onPositionChanged: function(mouse) {
        if (!canReorder || !(mouse.buttons & Qt.LeftButton))
            return ;

        var distance = Math.abs(mouse.x - pressedX) + Math.abs(mouse.y - pressedY);
        if (distance >= dragThreshold) {
            if (!dragging) {
                barRoot.barDragWindow = barRoot.targetWindow(slot.activeItem) || barRoot.targetWindow(slot);
                barRoot.barDragScreen = barRoot.barDragWindow ? barRoot.barDragWindow.screen : null;
                barRoot.barDragOffsetX = pressedX;
                barRoot.barDragOffsetY = pressedY;
                barRoot.captureBarDragGhost(slot);
                barRoot.barDragSource = slot;
            }
            dragging = true;
            barRoot.hideTooltip(slot.activeItem);
        }
        if (dragging) {
            var scenePoint = slot.mapToItem(null, mouse.x, mouse.y);
            var screenPoint = barRoot.barDragScreenPoint(scenePoint);
            barRoot.barDragSceneX = scenePoint.x;
            barRoot.barDragSceneY = scenePoint.y;
            barRoot.barDragScreenX = screenPoint.x;
            barRoot.barDragScreenY = screenPoint.y;
            var drop = barRoot.moduleDropAtScene(scenePoint, slot);
            barRoot.barDragTarget = drop ? drop.slot : null;
            barRoot.barDragAfter = drop ? drop.after : false;
            barRoot.barDragTargetGeometry = drop ? barRoot.dropMarkerRect(drop.slot, drop.after) : null;
        }
    }
    onReleased: function(mouse) {
        var wasDragging = dragging;
        var targetSlot = barRoot.barDragTarget;
        var afterTarget = barRoot.barDragAfter;
        if (wasDragging)
            suppressClick = true;

        dragging = false;
        barRoot.clearBarDrag();
        if (wasDragging && targetSlot) {
            barRoot.dropBarModuleAtTarget(slot, targetSlot, afterTarget);
            mouse.accepted = true;
        } else if (!wasDragging) {
            mouse.accepted = false;
        }
    }
    onCanceled: {
        dragging = false;
        suppressClick = false;
        barRoot.clearBarDrag();
    }
    onClicked: function(mouse) {
        if (suppressClick) {
            suppressClick = false;
            mouse.accepted = true;
            return ;
        }
        var action = slot.entryAction(mouse.button);
        if (action) {
            barRoot.run(action);
            mouse.accepted = true;
            return ;
        }
        if (!barRoot.pressModuleClickTarget(slot, mouse.button, mouse.x, mouse.y))
            mouse.accepted = false;

    }
    onWheel: function(wheel) {
        var action = slot.scrollAction(wheel.angleDelta.y > 0);
        if (action) {
            barRoot.run(action);
            wheel.accepted = true;
        } else {
            wheel.accepted = false;
        }
    }
}

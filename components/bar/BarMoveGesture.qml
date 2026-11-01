import QtQuick
import qs.Commons

MouseArea {
    id: gestureArea

    required property var barRoot
    property bool dragging: false
    property bool suppressClick: false
    property real pressedX: 0
    property real pressedY: 0
    readonly property real dragThreshold: Style.space(4)

    function startDrag(x, y) {
        if (dragging)
            return ;

        dragging = true;
        barRoot.beginBarMove(barRoot.targetWindow(gestureArea));
        var scenePoint = gestureArea.mapToItem(null, x, y);
        barRoot.updateBarMove(barRoot.windowScreenPoint(scenePoint, barRoot.barMoveWindow));
    }

    acceptedButtons: Qt.LeftButton
    cursorShape: dragging ? Qt.ClosedHandCursor : Qt.ArrowCursor
    pressAndHoldInterval: 200
    onPressed: function(mouse) {
        dragging = false;
        suppressClick = false;
        pressedX = mouse.x;
        pressedY = mouse.y;
    }
    onPressAndHold: function(mouse) {
        // A widget above us propagates its composed press-and-hold down here without
        // ever handing over the grab, so we'd get no release or cancel to end the move.
        if (!gestureArea.pressed)
            return ;

        startDrag(mouse.x, mouse.y);
    }
    onPositionChanged: function(mouse) {
        if (!(mouse.buttons & Qt.LeftButton))
            return ;

        if (!dragging) {
            var distance = Math.abs(mouse.x - pressedX) + Math.abs(mouse.y - pressedY);
            if (distance < dragThreshold)
                return ;

            startDrag(mouse.x, mouse.y);
            return ;
        }
        var scenePoint = gestureArea.mapToItem(null, mouse.x, mouse.y);
        barRoot.updateBarMove(barRoot.windowScreenPoint(scenePoint, barRoot.barMoveWindow));
    }
    onReleased: function(mouse) {
        if (!dragging)
            return ;

        dragging = false;
        suppressClick = true;
        barRoot.finishBarMove();
        mouse.accepted = true;
    }
    onCanceled: {
        dragging = false;
        suppressClick = false;
        barRoot.clearBarMove();
    }
    onClicked: function(mouse) {
        if (suppressClick) {
            suppressClick = false;
            mouse.accepted = true;
        }
    }
    onDoubleClicked: function(mouse) {
        if (suppressClick) {
            suppressClick = false;
            return ;
        }
        if (mouse.button === Qt.LeftButton) {
            barRoot.toggleTransparency();
            mouse.accepted = true;
        }
    }
}

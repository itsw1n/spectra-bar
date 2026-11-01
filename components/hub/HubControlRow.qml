import QtQuick
import QtQuick.Controls as Controls
import "../.."

Item {
    id: row

    required property var hub
    required property string modeId
    required property string caption
    property bool available: true
    property string unavailableReason: "Unavailable"
    property bool closeOnActivate: false
    property var externalControl: null
    property string iconText: ""
    readonly property bool selected: hub.opened && hub.navigationRows[hub.selectedIndex] === row
    readonly property var control: nativeAdapter.control
    readonly property bool ready: available && nativeAdapter.ready
    readonly property bool active: nativeAdapter.active
    readonly property string hint: !ready ? unavailableReason : nativeAdapter.hint
    readonly property string stateText: ready ? nativeAdapter.stateText : "Unavailable"

    function activate(button) {
        if (!ready)
            return ;

        if (closeOnActivate)
            hub.close();

        nativeAdapter.press(button);
    }

    implicitHeight: 36

    Rectangle {
        anchors.fill: parent
        color: (pointer.containsMouse || row.selected) && row.ready ? Theme.badge : "transparent"
        border.width: row.selected ? 1 : 0
        border.color: Theme.border
        radius: 3
    }

    OmarchyControls {
        id: nativeAdapter

        bar: row.hub.bar
        indicatorHost: row.hub
        modeId: row.modeId
        loadNative: row.modeId !== "Agents"
        externalControl: row.externalControl
        x: 5
        width: 27
        height: 26
        anchors.verticalCenter: parent.verticalCenter
        visible: row.externalControl === null
        opacity: row.modeId === "Microphone" && !row.active ? 0.45 : 1
    }

    Text {
        x: 5
        width: 27
        anchors.verticalCenter: parent.verticalCenter
        visible: row.iconText !== ""
        text: row.iconText
        horizontalAlignment: Text.AlignHCenter
        color: row.ready ? Theme.accent : Theme.muted
        font.family: row.hub.bar ? row.hub.bar.fontFamily : "monospace"
        font.pixelSize: 16
    }

    Text {
        x: 42
        anchors.verticalCenter: parent.verticalCenter
        text: row.caption
        color: row.ready ? Theme.accent : Theme.muted
        opacity: row.ready ? 1 : 0.55
        font.family: row.hub.bar ? row.hub.bar.fontFamily : "monospace"
        font.pixelSize: 12
    }

    Text {
        anchors.right: parent.right
        anchors.rightMargin: 9
        anchors.verticalCenter: parent.verticalCenter
        text: row.stateText
        color: row.active ? Theme.accent : Theme.muted
        opacity: row.active ? 1 : 0.7
        font.family: row.hub.bar ? row.hub.bar.fontFamily : "monospace"
        font.pixelSize: 10
    }

    MouseArea {
        id: pointer

        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
        cursorShape: row.ready ? Qt.PointingHandCursor : Qt.ArrowCursor
        onPositionChanged: {
            if (row.ready) {
                row.hub.selectRow(row);
            }
        }
        onClicked: function(mouse) {
            row.hub.selectRow(row);
            row.activate(mouse.button);
        }
        onWheel: function(wheel) {
            if (row.ready)
                nativeAdapter.scroll(wheel.angleDelta.y);

        }
    }

    Controls.ToolTip {
        parent: row
        visible: pointer.containsMouse && row.hint !== ""
        delay: 450
        text: row.hint

        contentItem: Text {
            text: row.hint
            color: Theme.accent
            font.family: row.hub.bar ? row.hub.bar.fontFamily : "monospace"
            font.pixelSize: 10
        }

        background: Rectangle {
            color: Theme.background
            border.color: Theme.border
            radius: 2
        }

    }

}

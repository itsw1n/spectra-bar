import QtQuick
import Quickshell
import qs.Commons
import qs.Commons as Commons
import qs.Ui

PopupWindow {
    id: tooltipWindow

    required property var barRoot
    required property var hostWindow

    visible: barRoot.tooltipShown && barRoot.tooltipTarget !== null && barRoot.tooltipText !== "" && barRoot.targetBelongsToWindow(barRoot.tooltipTarget, hostWindow)
    color: "transparent"
    implicitWidth: Math.ceil(tooltipBubble.implicitWidth)
    implicitHeight: Math.ceil(tooltipBubble.implicitHeight)

    anchor {
        id: tooltipAnchor

        window: hostWindow
        adjustment: PopupAdjustment.Slide
        edges: Edges.Top | Edges.Left
        gravity: Edges.Bottom | Edges.Right
        rect.width: 1
        rect.height: 1
        onAnchoring: {
            var target = barRoot.tooltipTarget;
            if (!barRoot.targetBelongsToWindow(target, hostWindow))
                return ;

            var popupWidth = tooltipWindow.implicitWidth;
            var popupHeight = tooltipWindow.implicitHeight;
            var localX = target.width / 2 - popupWidth / 2;
            var localY = target.height + 6;
            if (barRoot.position === "bottom") {
                localY = -popupHeight - 6;
            } else if (barRoot.position === "left") {
                localX = target.width + 6;
                localY = target.height / 2 - popupHeight / 2;
            } else if (barRoot.position === "right") {
                localX = -popupWidth - 6;
                localY = target.height / 2 - popupHeight / 2;
            }
            var point = hostWindow.contentItem.mapFromItem(target, localX, localY);
            tooltipAnchor.rect.x = Math.round(point.x);
            tooltipAnchor.rect.y = Math.round(point.y);
        }
    }

    BorderSurface {
        id: tooltipBubble

        implicitWidth: tooltipLabel.implicitWidth + 20
        implicitHeight: tooltipLabel.implicitHeight + 14
        color: Commons.Color.tooltip.background
        borderSpec: Border.surfaceSpec("tooltip", "border", Commons.Color.tooltip.border, 1)
        radius: Style.cornerRadius

        Text {
            id: tooltipLabel

            textFormat: Text.PlainText
            anchors.centerIn: parent
            text: barRoot.tooltipText
            color: Commons.Color.tooltip.text
            font.family: barRoot.fontFamily
            font.pixelSize: Style.font.body
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

    }

}

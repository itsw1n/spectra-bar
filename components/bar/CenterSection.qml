import QtQuick

Item {
    id: centerRoot

    required property var barRoot
    property var entries: barRoot.layoutEntries("center")
    readonly property bool hasAnchor: barRoot.entryIndex(entries, barRoot.centerAnchor) !== -1
    readonly property var anchorEntry: barRoot.findCenterAnchorEntry()

    Loader {
        anchors.fill: parent
        sourceComponent: barRoot.vertical ? verticalCenterModules : horizontalCenterModules
    }

    Component {
        id: horizontalCenterModules

        Item {
            anchors.fill: parent

            BarMoveGesture {
                barRoot: centerRoot.barRoot
                anchors.fill: parent
            }

            HoverHandler {
                onHoveredChanged: barRoot.setCenterSectionHovered(hovered)
            }

            BarSection {
                barRoot: centerRoot.barRoot
                visible: !centerRoot.hasAnchor
                entries: centerRoot.entries
                region: "center"
                segmentRole: "center"
                screenWidth: parent.width
                anchors.centerIn: parent
            }

            BarSection {
                barRoot: centerRoot.barRoot
                visible: centerRoot.hasAnchor
                entries: barRoot.entriesBefore(centerRoot.entries, barRoot.centerAnchor)
                region: "center"
                segmentRole: "center-left"
                screenWidth: parent.width
                anchors.right: centerAnchorModule.left
                anchors.verticalCenter: centerAnchorModule.verticalCenter
            }

            ModuleSlot {
                id: centerAnchorModule

                barRoot: centerRoot.barRoot
                visible: centerRoot.hasAnchor
                entry: centerRoot.anchorEntry
                region: "center"
                screenWidth: parent.width
                anchors.centerIn: parent
            }

            BarSection {
                barRoot: centerRoot.barRoot
                visible: centerRoot.hasAnchor
                entries: barRoot.entriesAfter(centerRoot.entries, barRoot.centerAnchor)
                region: "center"
                segmentRole: "center-right"
                screenWidth: parent.width
                anchors.left: centerAnchorModule.right
                anchors.verticalCenter: centerAnchorModule.verticalCenter
            }

        }

    }

    Component {
        id: verticalCenterModules

        Item {
            anchors.fill: parent

            BarMoveGesture {
                barRoot: centerRoot.barRoot
                anchors.fill: parent
            }

            HoverHandler {
                onHoveredChanged: barRoot.setCenterSectionHovered(hovered)
            }

            BarSection {
                barRoot: centerRoot.barRoot
                visible: !centerRoot.hasAnchor
                entries: centerRoot.entries
                region: "center"
                anchors.centerIn: parent
            }

            BarSection {
                barRoot: centerRoot.barRoot
                visible: centerRoot.hasAnchor
                entries: barRoot.entriesBefore(centerRoot.entries, barRoot.centerAnchor)
                region: "center"
                anchors.bottom: centerAnchorModule.top
                anchors.horizontalCenter: centerAnchorModule.horizontalCenter
            }

            ModuleSlot {
                id: centerAnchorModule

                barRoot: centerRoot.barRoot
                visible: centerRoot.hasAnchor
                entry: centerRoot.anchorEntry
                region: "center"
                anchors.centerIn: parent
            }

            BarSection {
                barRoot: centerRoot.barRoot
                visible: centerRoot.hasAnchor
                entries: barRoot.entriesAfter(centerRoot.entries, barRoot.centerAnchor)
                region: "center"
                anchors.top: centerAnchorModule.bottom
                anchors.horizontalCenter: centerAnchorModule.horizontalCenter
            }

        }

    }

}

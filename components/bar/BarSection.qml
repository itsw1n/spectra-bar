import QtQuick
import "../.."
import ".."

Loader {
    id: moduleListRoot

    required property var barRoot
    property var entries: []
    property string region: ""
    property string segmentRole: region
    property real screenWidth: 1920

    visible: entries.length > 0
    // A hidden list must not build its modules. The center section declares
    // both an anchored and an unanchored arrangement and shows whichever
    // fits, so leaving the other one loaded mounts every center module
    // twice — two IPC handlers registered for the same target, two clocks
    // ticking, two of every timer and fetch behind them.
    active: visible && entries.length > 0
    sourceComponent: barRoot.vertical ? verticalModuleList : horizontalModuleList
    width: item ? item.implicitWidth : 0
    height: item ? item.implicitHeight : 0

    Component {
        id: horizontalModuleList

        Item {
            implicitWidth: Math.max(row.implicitWidth + 12, Theme.sectionWidth(moduleListRoot.screenWidth, moduleListRoot.segmentRole))
            implicitHeight: Theme.segmentHeight

            PrismPanel {
                anchors.fill: parent
                leftSkew: moduleListRoot.segmentRole === "center-right" || moduleListRoot.segmentRole === "center-left" ? -height : (moduleListRoot.segmentRole === "right" ? height : 0)
                rightSkew: moduleListRoot.segmentRole === "center-right" ? height : (moduleListRoot.segmentRole === "left" ? -height : 0)
                hideRightEdge: moduleListRoot.segmentRole === "center-left"
                capLeft: moduleListRoot.segmentRole === "left"
                capRight: moduleListRoot.segmentRole === "right"
            }

            Row {
                id: row

                anchors.centerIn: parent
                spacing: 0

                Repeater {
                    model: moduleListRoot.entries

                    ModuleSlot {
                        required property var modelData

                        barRoot: moduleListRoot.barRoot
                        entry: modelData
                        region: moduleListRoot.region
                        screenWidth: moduleListRoot.screenWidth
                    }

                }

            }

        }

    }

    Component {
        id: verticalModuleList

        Column {
            spacing: 0

            Repeater {
                model: moduleListRoot.entries

                ModuleSlot {
                    required property var modelData

                    barRoot: moduleListRoot.barRoot
                    entry: modelData
                    region: moduleListRoot.region
                }

            }

        }

    }

}

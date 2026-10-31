import QtQuick
import QtQuick.Shapes
import ".."

Item {
  id: badge

  Item {
    id: body
    width: Math.min(badge.width, badge.height * 2.15)
    height: badge.height
    anchors.centerIn: parent
    readonly property real cut: height * 0.48
    readonly property real shoulder: height * 0.18

    PrismConnector { anchors.fill: parent; side: "left" }
    PrismConnector { anchors.fill: parent; side: "right" }

    Shape {
      anchors.fill: parent
      preferredRendererType: Shape.CurveRenderer
      ShapePath {
        strokeColor: Theme.border
        strokeWidth: 0.9
        fillColor: Theme.backing
        joinStyle: ShapePath.MiterJoin
        startX: body.cut; startY: 0.5
        PathLine { x: body.width - body.cut; y: 0.5 }
        PathLine { x: body.width - 0.5; y: body.shoulder }
        PathLine { x: body.width - 0.5; y: body.height - body.shoulder }
        PathLine { x: body.width - body.cut; y: body.height - 0.5 }
        PathLine { x: body.cut; y: body.height - 0.5 }
        PathLine { x: 0.5; y: body.height - body.shoulder }
        PathLine { x: 0.5; y: body.shoulder }
        PathLine { x: body.cut; y: 0.5 }
      }
      ShapePath {
        strokeColor: "transparent"
        strokeWidth: 0
        fillColor: Theme.badge
        joinStyle: ShapePath.MiterJoin
        startX: body.cut + 2; startY: 2
        PathLine { x: body.width - body.cut - 2; y: 2 }
        PathLine { x: body.width - 2; y: body.shoulder + 1 }
        PathLine { x: body.width - 2; y: body.height - body.shoulder - 1 }
        PathLine { x: body.width - body.cut - 2; y: body.height - 2 }
        PathLine { x: body.cut + 2; y: body.height - 2 }
        PathLine { x: 2; y: body.height - body.shoulder - 1 }
        PathLine { x: 2; y: body.shoulder + 1 }
        PathLine { x: body.cut + 2; y: 2 }
      }
      ShapePath {
        strokeColor: Theme.badgeRidge
        strokeWidth: 0.7
        fillColor: Theme.badgeInner
        joinStyle: ShapePath.MiterJoin
        startX: body.cut + 5; startY: 4
        PathLine { x: body.width - body.cut - 5; y: 4 }
        PathLine { x: body.width - 5; y: body.shoulder + 3 }
        PathLine { x: body.width - 5; y: body.height - body.shoulder - 3 }
        PathLine { x: body.width - body.cut - 5; y: body.height - 4 }
        PathLine { x: body.cut + 5; y: body.height - 4 }
        PathLine { x: 5; y: body.height - body.shoulder - 3 }
        PathLine { x: 5; y: body.shoulder + 3 }
        PathLine { x: body.cut + 5; y: 4 }
      }
      ShapePath {
        strokeColor: "transparent"
        fillColor: Theme.bevel
        startX: body.cut + 3; startY: 2.5
        PathLine { x: body.width - body.cut - 3; y: 2.5 }
        PathLine { x: body.width - body.cut - 7; y: 4 }
        PathLine { x: body.cut + 7; y: 4 }
        PathLine { x: body.cut + 3; y: 2.5 }
      }
    }
    Image {
      width: Math.min(24, body.height * 0.72)
      height: Math.min(24, body.height * 0.72)
      anchors.centerIn: parent
      source: "../assets/arch.svg"
      sourceSize.width: 64
      sourceSize.height: 64
      fillMode: Image.PreserveAspectFit
      smooth: true
    }
  }
}

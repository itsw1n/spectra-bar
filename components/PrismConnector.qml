import QtQuick
import QtQuick.Shapes
import ".."

Item {
  id: connector
  property string side: "left"
  transform: Scale {
    xScale: connector.side === "right" ? -1 : 1
    origin.x: connector.width / 2
  }
  Shape {
    x: -Theme.badgeWing
    width: connector.width + Theme.badgeWing * 2
    height: connector.height
    preferredRendererType: Shape.CurveRenderer
    ShapePath {
      strokeColor: Theme.badgeRidge
      strokeWidth: 0.7
      fillColor: Theme.wingShadow
      startX: 0.5; startY: 3.5
      PathLine { x: Theme.badgeWing + 10; y: 3.5 }
      PathLine { x: Theme.badgeWing; y: connector.height / 2 }
      PathLine { x: 10; y: connector.height / 2 }
      PathLine { x: 0.5; y: 3.5 }
    }
    ShapePath {
      strokeColor: "transparent"
      fillColor: Theme.wing
      startX: 1; startY: 4
      PathLine { x: 11; y: 4 }
      PathLine { x: 9; y: 10 }
      PathLine { x: 1; y: 4 }
    }
    ShapePath {
      strokeColor: Theme.badgeRidge
      strokeWidth: 0.7
      fillColor: Theme.wingShadow
      startX: 0.5; startY: connector.height - 3.5
      PathLine { x: Theme.badgeWing + 10; y: connector.height - 3.5 }
      PathLine { x: Theme.badgeWing; y: connector.height / 2 }
      PathLine { x: 10; y: connector.height / 2 }
      PathLine { x: 0.5; y: connector.height - 3.5 }
    }
    ShapePath {
      strokeColor: "transparent"
      fillColor: Theme.edgeAccent
      startX: 1; startY: connector.height - 4
      PathLine { x: 8; y: connector.height - 4 }
      PathLine { x: 9; y: connector.height - 8 }
      PathLine { x: 1; y: connector.height - 4 }
    }
  }
}

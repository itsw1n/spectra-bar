import QtQuick
import QtQuick.Shapes
import "SpectraTokens.js" as Tokens

Item {
  id: segment
  property color fillColor: Tokens.segment
  property color lineColor: Tokens.border
  property real leftChamfer: Tokens.chamfer
  property real rightChamfer: Tokens.chamfer
  property real lineWidth: 1

  Shape {
    anchors.fill: parent
    preferredRendererType: Shape.CurveRenderer
    ShapePath {
      strokeColor: segment.lineColor
      strokeWidth: segment.lineWidth
      fillColor: segment.fillColor
      joinStyle: ShapePath.MiterJoin
      startX: segment.leftChamfer
      startY: 0.5
      PathLine { x: segment.width - segment.rightChamfer; y: 0.5 }
      PathLine { x: segment.width - 0.5; y: segment.height / 2 }
      PathLine { x: segment.width - segment.rightChamfer; y: segment.height - 0.5 }
      PathLine { x: segment.leftChamfer; y: segment.height - 0.5 }
      PathLine { x: 0.5; y: segment.height / 2 }
      PathLine { x: segment.leftChamfer; y: 0.5 }
    }
  }
}

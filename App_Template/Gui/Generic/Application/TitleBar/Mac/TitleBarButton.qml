import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.impl 2.13
import QtQuick.Shapes 1.13

Button {
  property bool showIcon: false
  property int buttonSize: 13
  property int borderWidth: 1
  property string borderColor: "grey"
  property string fillColor: "lightgrey"
  property string iconColor: "grey"
  property alias iconElements: shapePath.pathElements

  width: buttonSize
  height: buttonSize

  background: Rectangle {
    radius: buttonSize
    border.width: borderWidth
    border.color: borderColor
    color: fillColor
  }

  Shape {
    anchors.fill: parent
    visible: showIcon

    ShapePath {
      id: shapePath
      strokeWidth: 1
      strokeColor: iconColor
      fillColor: "transparent"
      startX: 0
      startY: 0
    }
  }
}

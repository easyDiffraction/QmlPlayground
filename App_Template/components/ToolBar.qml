import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.impl 2.13

import "." as CustomComponents

ToolBar {
  property ApplicationWindow window: null
  property alias buttons: buttonsContainer.children

  background: Rectangle {
    color: "#c4c4c4"
  }

  // Drag and Maximize
  MouseArea {
    property var clickPos: "1,1"

    anchors.fill: parent

    onPressed: {
      if (window.visibility !== 4 && window.visibility !== 5) {
        clickPos = Qt.point(mouse.x, mouse.y)
      }
    }

    onPositionChanged: {
      if (window.visibility !== 4 && window.visibility !== 5) {
        var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
        window.x += delta.x
        window.y += delta.y
      }
    }

    onDoubleClicked: {
      if (window.visibility !== 4 && window.visibility !== 5) {
        window.showMaximized()
      } else {
        window.showNormal()
      }
    }
  }

  // System Buttons
  Item {
    width: 13 * 3 + 8 * 2
    height: 13
    anchors.verticalCenter: parent.verticalCenter
    anchors.left: parent.left
    anchors.leftMargin: 10

    Row {
      spacing: 8

      CustomComponents.MacCloseTitleBarButton {
        showIcon: systemButtonsArea.containsMouse
      }

      CustomComponents.MacMinimizeTitleBarButton {
        showIcon: systemButtonsArea.containsMouse
      }

      CustomComponents.MacMaximizeTitleBarButton {
        showIcon: systemButtonsArea.containsMouse
      }
    }

    // Show system buttons icons if this buttons area is hovered
    MouseArea {
      id: systemButtonsArea
      anchors.fill: parent
      hoverEnabled: true
      acceptedButtons: Qt.NoButton
    }
  }

  // Tab Buttons
  Row {
    id: buttonsContainer

    anchors.centerIn: parent
    spacing: 10
  }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/


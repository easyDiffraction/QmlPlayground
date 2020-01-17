import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.impl 2.13

import Gui.Generic.Style 1.0 as GuiGenericStyle
import Gui.Generic.Application.TitleBar.Mac 1.0 as GuiGenericApplicationTitleBarMac

ToolBar {
  property ApplicationWindow appWindow: null
  property alias buttons: buttonsContainer.children

  background: Rectangle {
    color: GuiGenericStyle.Color.tabBarBackgroundColor
  }

  // Implement toolbar drag and maximize behaviour
  MouseArea {
    property var clickPos: Qt.point(0, 0)

    anchors.fill: parent

    onPressed: {
      if (appWindow.visibility !== Window.Maximized
          && appWindow.visibility !== Window.FullScreen) {
        clickPos = Qt.point(mouse.x, mouse.y)
      }
    }

    onPositionChanged: {
      if (appWindow.visibility !== Window.Maximized
          && appWindow.visibility !== Window.FullScreen) {
        const delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
        appWindow.x += delta.x
        appWindow.y += delta.y
      }
    }

    onDoubleClicked: {
      if (appWindow.visibility === Window.FullScreen)
        return
      if (appWindow.visibility !== Window.Maximized) {
        appWindow.showMaximized()
      } else {
        appWindow.showNormal()
      }
    }
  }

  // Title Bar Buttons
  Item {
    anchors.verticalCenter: parent.verticalCenter
    anchors.left: parent.left
    anchors.leftMargin: 10
    width: childrenRect.width
    height: childrenRect.height

    Row {
      spacing: 8

      GuiGenericApplicationTitleBarMac.CloseTitleBarButton {
        anchors.verticalCenter: parent.verticalCenter
        showIcon: systemButtonsArea.containsMouse
      }

      GuiGenericApplicationTitleBarMac.MinimizeTitleBarButton {
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -0.5
        showIcon: systemButtonsArea.containsMouse
      }

      GuiGenericApplicationTitleBarMac.MaximizeTitleBarButton {
        anchors.verticalCenter: parent.verticalCenter
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

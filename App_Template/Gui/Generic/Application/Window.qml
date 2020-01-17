import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.13
import QtGraphicalEffects 1.13

import Gui.Generic.Style 1.0 as GuiGenericStyle
import Gui.Generic.Application 1.0 as GuiGenericApplication

ApplicationWindow {
  property alias toolBarButtons: toolBar.buttons

  id: appWindow
  visible: true
  minimumWidth: GuiGenericStyle.Size.appWindowMinimumWidth
  minimumHeight: GuiGenericStyle.Size.appWindowMinimumHeight
  color: GuiGenericStyle.Color.contentBackgroundColor

  //flags: Qt.CustomizeWindowHint | Qt.Window | Qt.WindowCloseButtonHint | Qt.WindowMinMaxButtonsHint
  //flags: Qt.CustomizeWindowHint | Qt.WindowCloseButtonHint | Qt.WindowMinMaxButtonsHint
  //flags: Qt.FramelessWindowHint | Qt.Window
  flags: Qt.CustomizeWindowHint | Qt.WindowCloseButtonHint | Qt.WindowMinMaxButtonsHint

  Rectangle {
    id: windowContent
    anchors.fill: parent

    GuiGenericApplication.ToolBar {
      id: toolBar
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.top: parent.top
      height: GuiGenericStyle.Size.tabBarHeight
      appWindow: appWindow
    }

    DropShadow {
      anchors.fill: windowContent
      horizontalOffset: 0
      verticalOffset: 0
      radius: 0
      samples: 10
      source: toolBar
      color: GuiGenericStyle.Color.tabBarBorderColor
    }

    Rectangle {
      id: separator
      anchors.top: toolBar.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      height: GuiGenericStyle.Size.borderThickness
      color: GuiGenericStyle.Color.tabBarBorderColor
    }

    SwipeView {
      id: contentArea
      anchors.top: separator.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
    }
  }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/

import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.13

import Gui.Generic.Style 1.0 as GuiGenericStyle
import Gui.Generic.Application 1.0 as GuiGenericApplication

ApplicationWindow {
  id: appWindow

  property alias toolBarButtons: toolBar.buttons

  visible: true

  minimumWidth: GuiGenericStyle.Size.appWindowMinimumWidth
  minimumHeight: GuiGenericStyle.Size.appWindowMinimumHeight

  //flags: Qt.CustomizeWindowHint | Qt.Window | Qt.WindowCloseButtonHint | Qt.WindowMinMaxButtonsHint
  //flags: Qt.FramelessWindowHint | Qt.DropShadowWindowHint
  flags: Qt.CustomizeWindowHint | Qt.WindowCloseButtonHint | Qt.WindowMinMaxButtonsHint

  background: Rectangle {
    color: GuiGenericStyle.Color.contentBackgroundColor
  }

  Column {
    width: parent.width
    height: parent.height

    GuiGenericApplication.ToolBar {
      id: toolBar
      width: parent.width
      height: GuiGenericStyle.Size.tabBarHeight
      appWindow: appWindow
    }

    Rectangle {
      id: separator
      width: parent.width
      height: GuiGenericStyle.Size.borderThickness
      color: GuiGenericStyle.Color.tabBarBorderColor
    }

    SwipeView {
      id: contentArea
      width: parent.width
      height: parent.height - toolBar.height - separator.height
    }
  }
}

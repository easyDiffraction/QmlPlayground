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

  flags: Qt.CustomizeWindowHint | Qt.Window | Qt.WindowCloseButtonHint | Qt.WindowMinMaxButtonsHint

  background: Rectangle {
    color: GuiGenericStyle.Color.contentBackgroundColor
  }

  Column {
    width: appWindow.width
    height: appWindow.height

    GuiGenericApplication.ToolBar {
      id: toolBar
      appWindow: appWindow
      width: appWindow.width
      height: GuiGenericStyle.Size.tabBarHeight
    }

    Rectangle {
      width: appWindow.width
      height: GuiGenericStyle.Size.borderThickness
      color: GuiGenericStyle.Color.tabBarBorderColor
    }

    Text {
      text: "afwef"
    }

    SwipeView {
      width: appWindow.width
      height: appWindow.height - GuiGenericStyle.Size.tabBarHeight
              - GuiGenericStyle.Size.borderThickness
    }
  }
}

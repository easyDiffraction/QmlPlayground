import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.impl 2.13
import QtQuick.Shapes 1.13

import Gui.Generic.Application.TitleBar.Mac 1.0 as GuiGenericApplicationTitleBarMac

GuiGenericApplicationTitleBarMac.TitleBarButton {
  iconElements: [
    PathMove {
      x: 3.5
      y: 7
    },
    PathLine {
      x: 10.5
      y: 7
    }
  ]

  buttonSize: 14 // slightly increase, as yellow button looks a bit smaller than others

  borderColor: "#eab043" //"#d6a145"
  fillColor: "#f6be4f"
  iconColor: "#90591d"

  onClicked: appWindow.showMinimized()
}

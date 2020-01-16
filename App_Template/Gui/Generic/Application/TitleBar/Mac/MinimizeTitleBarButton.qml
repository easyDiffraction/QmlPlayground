import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.impl 2.13
import QtQuick.Shapes 1.13

import Gui.Generic.Application.TitleBar.Mac 1.0 as GuiGenericApplicationTitleBarMac

GuiGenericApplicationTitleBarMac.TitleBarButton {
  iconElements: [
    PathMove {
      x: 3
      y: 7
    },
    PathLine {
      x: 10
      y: 7
    }
  ]

  borderColor: "#d9a13f"
  fillColor: "#f6c050"
  iconColor: "#915a1d"

  onClicked: appWindow.showMinimized()
}

import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.impl 2.13
import QtQuick.Shapes 1.13

import Gui.Generic.Application.TitleBar.Mac 1.0 as GuiGenericApplicationTitleBarMac

GuiGenericApplicationTitleBarMac.TitleBarButton {
  iconElements: [
    PathMove {
      x: 4
      y: 4
    },
    PathLine {
      x: 9
      y: 9
    },
    PathMove {
      x: 9
      y: 4
    },
    PathLine {
      x: 4
      y: 9
    }
  ]

  borderColor: "#e45a4d"//"#d14d41"
  fillColor: "#ed6b5f"
  iconColor: "#460804"

  onClicked: Qt.quit()
}

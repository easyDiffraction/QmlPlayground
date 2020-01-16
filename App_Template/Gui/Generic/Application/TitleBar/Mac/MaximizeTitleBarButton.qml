import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.impl 2.13
import QtQuick.Shapes 1.13

import Gui.Generic.Application.TitleBar.Mac 1.0 as GuiGenericApplicationTitleBarMac

GuiGenericApplicationTitleBarMac.TitleBarButton {
  iconElements: [
    PathMove {
      x: 6.5
      y: 3
    },
    PathLine {
      x: 6.5
      y: 10
    },
    PathMove {
      x: 3
      y: 6.5
    },
    PathLine {
      x: 10
      y: 6.5
    }
  ]

  borderColor: "#53a73f"
  fillColor: "#65ca57"
  iconColor: "#2a6118"

  onClicked: {
    if (appWindow.visibility !== 4 && appWindow.visibility !== 5) {
      appWindow.showFullScreen() //appWindow.showMaximized()
    } else {
      appWindow.showNormal()
    }
  }
}

import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.impl 2.13
import QtQuick.Shapes 1.13

import "." as CustomComponents

CustomComponents.MacTitleBarButton {
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

  borderColor: "#d65145"
  fillColor: "#ed6b5f"
  iconColor: "#4d0000"

  onClicked: Qt.quit()
}

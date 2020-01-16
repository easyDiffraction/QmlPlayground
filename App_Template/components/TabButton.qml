import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.impl 2.13

ToolButton {
  id: button

  width: 100
  anchors.verticalCenter: parent.verticalCenter

  contentItem: IconLabel {
    text: button.text
    color: "#333" //"white"
  }

  background: Rectangle {
    color: "#f6f6f6" //"grey"
  }
}

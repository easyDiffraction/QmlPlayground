import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.impl 2.13

import Gui.Generic.Style 1.0 as GuiGenericStyle

ToolButton {
  id: button

  width: GuiGenericStyle.Size.tabBarButtonWidth
  anchors.verticalCenter: parent.verticalCenter

  contentItem: IconLabel {
    text: button.text
    color: GuiGenericStyle.Color.tabBarButtonForegroundColor
  }

  background: Rectangle {
    color: GuiGenericStyle.Color.tabBarButtonBackgroundColor
  }
}

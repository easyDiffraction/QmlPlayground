import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.13
import QtGraphicalEffects 1.13

import Gui.Generic.Style 1.0 as GuiGenericStyle
import Gui.Generic.Application 1.0 as GuiGenericApplication

ApplicationWindow {
  property alias toolBarButtons: toolBar.buttons
  property int rrr: 20
  property int sss: 40

  // https://stackoverflow.com/questions/18754057/shadow-for-qml-frameless-windows/18754306#18754306
  // https://evileg.com/en/post/280/
  id: appWindow
  visible: true
  minimumWidth: GuiGenericStyle.Size.appWindowMinimumWidth
  minimumHeight: GuiGenericStyle.Size.appWindowMinimumHeight
  color: "transparent"

  //flags: Qt.CustomizeWindowHint | Qt.Window | Qt.WindowCloseButtonHint | Qt.WindowMinMaxButtonsHint | Qt.WindowFullscreenButtonHint
  //flags: Qt.CustomizeWindowHint | Qt.WindowCloseButtonHint | Qt.WindowMinMaxButtonsHint
  //flags: Qt.FramelessWindowHint | Qt.Window
  flags: Qt.FramelessWindowHint | Qt.Window | Qt.NoDropShadowWindowHint | Qt.WindowMinMaxButtonsHint

  Rectangle {
    id: windowContent
    anchors.fill: parent
    anchors.margins: rrr //GuiGenericStyle.Size.appWindowShadowRadius
    radius: GuiGenericStyle.Size.appWindowRadius
    clip: true

    GuiGenericApplication.ToolBar {
      id: toolBar
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.top: parent.top
      height: GuiGenericStyle.Size.tabBarHeight
      appWindow: appWindow
    }


    /*
    DropShadow {
      anchors.fill: windowContent
      horizontalOffset: 0
      verticalOffset: 1
      radius: 5
      samples: 10
      source: toolBar
      color: GuiGenericStyle.Color.tabBarBorderColor
    }
    */
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

  DropShadow {
    anchors.fill: windowContent
    source: windowContent
    horizontalOffset: 0
    verticalOffset: 0
    radius: rrr //GuiGenericStyle.Size.appWindowShadowRadius
    samples: sss //30
    //spread: 0
    color: "black"
  }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/


import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Universal 2.13

import Gui.Generic.Style 1.0 as GuiGenericStyle
import Gui.Generic.Application 1.0 as GuiGenericApplication

GuiGenericApplication.Window {

  toolBarButtons: [
    GuiGenericApplication.TabButton {
      text: "Sample"
      onClicked: content.setCurrentIndex(0)
    },
    GuiGenericApplication.TabButton {
      text: "Experiment"
      onClicked: content.setCurrentIndex(1)
    },
    GuiGenericApplication.TabButton {
      text: "Analysis"
      onClicked: content.setCurrentIndex(2)
    }
  ]


  /*
  Column {
    width: parent.width
    height: parent.height

    CustomComponents.ToolBar {
      window: appWindow
      width: appWindow.width
      height: tabBarHeight
      buttons: [
        CustomComponents.TabButton {
          text: "Sample"
          onClicked: content.setCurrentIndex(0)
        },
        CustomComponents.TabButton {
          text: "Experiment"
          onClicked: content.setCurrentIndex(1)
        },
        CustomComponents.TabButton {
          text: "Analysis"
          onClicked: content.setCurrentIndex(2)
        }
      ]
    }

    Rectangle {
      width: appWindow.width
      height: borderThickness
      color: GuiGeneric.Style.tabBarBorderColor
    }

    SwipeView {
      id: content

      width: appWindow.width
      height: appWindow.height - tabBarHeight - borderThickness

      Row {

        Column {
          width: parent.width - borderThickness - sideBarWidth
          height: parent.height

          Rectangle {
            width: parent.width
            height: parent.height - borderThickness - statusBarHeight
            color: GuiGeneric.Style.contentBackgroundColor
            Text {
              anchors.fill: parent
              anchors.margins: 10
              text: "MainView"
            }
          }

          Rectangle {
            width: parent.width
            height: borderThickness
            color: GuiGeneric.Style.contentBorderColor
          }

          Rectangle {
            width: parent.width
            height: statusBarHeight
            color: GuiGeneric.Style.contentBackgroundColor
            Text {
              anchors.fill: parent
              anchors.leftMargin: 10
              verticalAlignment: Text.AlignVCenter
              text: "StatusBar"
            }
          }
        }

        Rectangle {
          width: borderThickness
          height: parent.height
          color: GuiGeneric.Style.contentBorderColor
        }

        Rectangle {
          width: sideBarWidth
          height: parent.height
          color: GuiGeneric.Style.contentBackgroundColor
          Text {
            anchors.fill: parent
            anchors.margins: 10
            text: "SideBar"
          }
        }
      }

      Rectangle {
        color: "lightblue"
        Text {
          text: "lightblue"
        }
      }
      Rectangle {
        color: "coral"
        Text {
          text: "coral"
        }
      }
    }
  }
  */
}

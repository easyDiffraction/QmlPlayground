import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.13

import "components" as Components

Window {
  visible: true
  width: 300
  height: 400

  TabBar {
    id: tabBar

    width: parent.width

    TabButton {
      text: "darkseagreen"
      background: Rectangle {
        color: "darkseagreen"
      }
    }
    TabButton {
      text: "lightblue"
      background: Rectangle {
        color: "lightblue"
      }
    }
    TabButton {
      text: "coral"
      background: Rectangle {
        color: "coral"
      }
    }
  }

  SwipeView {
    width: parent.width
    anchors.top: tabBar.bottom
    anchors.bottom: parent.bottom

    currentIndex: tabBar.currentIndex

    Components.TabContent1 {}
    Components.TabContent2 {}
    Components.TabContent3 {}
  }
}

import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.13

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

    Rectangle {
      id: rect
      color: "darkseagreen"
      Text {
        text: "darkseagreen"
      }
      states: [
        State {
          PropertyChanges {
            target: rect
            color: "darkseagreen"
          }
        },
        State {
          PropertyChanges {
            target: rect
            color: "lightblue"
          }
        },
        State {
          PropertyChanges {
            target: rect
            color: "coral"
          }
        }
      ]
    }
  }
}

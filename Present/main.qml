import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.13
import QtCharts 2.13

ApplicationWindow {
  id: appWindow

  visible: true
  width: 400
  height: 300

  flags: Qt.Window | Qt.WindowFullScreenButtonHint


  /*
  header: Label {
    text: view.currentItem.title
    horizontalAlignment: Text.AlignHCenter
  }
  */
  SwipeView {
    id: view

    anchors.fill: parent
    focus: true
    currentIndex: 0

    Page {
      header: Rectangle {
        height: appWindow.height / 6
        color: "steelblue"
        Text {
          anchors.fill: parent
          anchors.leftMargin: 15
          verticalAlignment: Text.AlignVCenter
          color: "white"
          text: "Introduction"
        }
      }

      Column {
        id: column
        anchors.centerIn: parent
        spacing: 10

        Text {
          id: item1
          text: "• Lorem ipsum dolor sit amet"

          NumberAnimation on y {
            running: false
            from: column.y + column.height
            to: item1.y
            duration: 1000
            loops: Animation.Infinite
            easing.type: Easing.InOutExpo
          }
        }
        Text {
          id: item2
          text: "• Consectetur adipiscing elit"

          NumberAnimation on y {
            running: false
            from: column.y + column.height
            to: item2.y
            duration: 1000
            loops: Animation.Infinite
            easing.type: Easing.InOutExpo
          }
        }
        Text {
          id: item3
          text: "• Sed do eiusmod tempor incididunt"

          NumberAnimation on y {
            running: false
            from: column.y + column.height
            to: item3.y
            duration: 1000
            loops: Animation.Infinite
            easing.type: Easing.InOutExpo
          }
        }
      }
    }

    Page {
      header: Rectangle {
        height: appWindow.height / 6
        color: "steelblue"
        Text {
          anchors.fill: parent
          anchors.leftMargin: 15
          verticalAlignment: Text.AlignVCenter
          color: "white"
          text: "Slide Title"
        }
      }
    }

    Page {
      header: Rectangle {
        height: appWindow.height / 6
        color: "steelblue"
        Text {
          anchors.fill: parent
          anchors.leftMargin: 15
          verticalAlignment: Text.AlignVCenter
          color: "white"
          text: "Summary"
        }
      }
    }
  }

  PageIndicator {
    id: indicator

    anchors.bottom: view.bottom
    anchors.horizontalCenter: parent.horizontalCenter

    count: view.count
    currentIndex: view.currentIndex
  }
}

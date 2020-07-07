import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import easyInterface.Globals 1.0 as InterfaceGlobals
import easyInterface.Animations 1.0 as InterfaceAnimations

Rectangle {
    id: statusBar

    property alias text: label.text

    //Component.onCompleted: y = visible ? 0 : height
    visible: InterfaceGlobals.Variable.showAppStatusBar

    width: parent.width
    height: parent.height

    color: InterfaceGlobals.Color.statusBarBackground
    Behavior on color {
        InterfaceAnimations.ThemeChange {}
    }

    // Status bar text
    Label {
        id: label

        //anchors.verticalCenter: parent.verticalCenter
        //height: parent.height
        //verticalAlignment: Text.AlignVCenter
        topPadding: (statusBar.height - font.pixelSize - 5) * 0.5
        leftPadding: 10

        color: InterfaceGlobals.Color.statusBarForeground
    }

    // Status bar top border
    Rectangle {
        anchors.top: statusBar.top
        anchors.left: statusBar.left
        anchors.right: statusBar.right

        height: InterfaceGlobals.Size.borderThickness

        color: InterfaceGlobals.Color.appBarBorder
        Behavior on color {
            InterfaceAnimations.ThemeChange {}
        }
    }

    // Show-hide status bar animation
    Behavior on visible {
        InterfaceAnimations.BarShow {
            parentTarget: statusBar
        }
    }
}

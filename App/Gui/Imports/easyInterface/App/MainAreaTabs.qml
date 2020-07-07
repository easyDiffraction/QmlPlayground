import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import easyInterface.App 1.0 as InterfaceApp
import easyInterface.Globals 1.0 as InterfaceGlobals
import easyInterface.Animations 1.0 as InterfaceAnimations

InterfaceApp.TabBar {
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right

    background: Rectangle {
        color: "transparent"

        // tabs bottom border
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: InterfaceGlobals.Size.borderThickness
            color: InterfaceGlobals.Color.appBorder
            Behavior on color {
                InterfaceAnimations.ThemeChange {}
            }
        }
    }
}

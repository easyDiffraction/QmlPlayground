import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import easyInterface.Globals 1.0 as InterfaceGlobals
import easyInterface.Animations 1.0 as InterfaceAnimations

SwipeView {
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right

    clip: true
    interactive: false

    background: Rectangle {
        color: InterfaceGlobals.Color.mainAreaBackground
        Behavior on color {
            InterfaceAnimations.ThemeChange {}
        }
    }
}

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import easyInterface.Globals 1.0 as InterfaceGlobals
import easyInterface.Animations 1.0 as InterfaceAnimations

Item {
    id: page

    property alias mainContent: mainContentContainer.data
    property alias sideBar: sideBarContainer.data

    // Main content
    Item {
        id: mainContentContainer

        anchors.top: page.top
        anchors.bottom: page.bottom
        anchors.left: page.left
        anchors.right: sideBarContainer.left
    }

    // Sidebar container
    Item {
        id: sideBarContainer

        anchors.top: page.top
        anchors.bottom: page.bottom
        anchors.right: page.right
        width: childrenRect.width === border.width ? 0 : InterfaceGlobals.Size.sideBarWidth
        //width: InterfaceGlobals.Size.sideBarWidth

        // Vertical border on the left side
        Rectangle {
            id: border

            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: InterfaceGlobals.Size.borderThickness

            color: InterfaceGlobals.Color.appBorder
            Behavior on color {
                InterfaceAnimations.ThemeChange {}
            }
        }
    }
}

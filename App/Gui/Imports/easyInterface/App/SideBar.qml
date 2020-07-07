import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import easyInterface.App 1.0 as InterfaceApp
import easyInterface.Globals 1.0 as InterfaceGlobals
import easyInterface.Animations 1.0 as InterfaceAnimations

Item {
    id: sideBarContainer

    property alias basicControls: basicControlsContainer.data
    property alias advancedControls: advancedControlsContainer.data

    width: parent.width
    height: parent.height

    // Sidebar tabs
    InterfaceApp.TabBar {
        id: sideBarTabs

        anchors.top: sideBarContainer.top
        anchors.left: sideBarContainer.left
        anchors.right: sideBarContainer.right

        // Basic controls tab button
        InterfaceApp.TabButton {
            text: qsTr("Basic controls")
        }

        // Advanced controls tab button
        InterfaceApp.TabButton {
            text: qsTr("Advanced controls")
        }

        // Empty background with border
        background: Item {

            // Sidebar tabs bottom border
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

    // Sidebar content
    SwipeView {
        id: sideBarContent

        anchors.top: sideBarTabs.bottom
        anchors.bottom: sideBarContainer.bottom
        anchors.left: sideBarContainer.left
        anchors.right: sideBarContainer.right

        clip: true
        interactive: false

        currentIndex: sideBarTabs.currentIndex

        // Basic controls area
        Flickable {
            contentHeight: basicControlsContainer.height
            contentWidth: basicControlsContainer.width

            clip: true
            flickableDirection: Flickable.VerticalFlick

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
                interactive: false
            }

            Column {
                id: basicControlsContainer

                width: sideBarContainer.width
            }
        }

        // Advanced controls area
        Flickable {
            contentHeight: advancedControlsContainer.height
            contentWidth: advancedControlsContainer.width

            clip: true
            flickableDirection: Flickable.VerticalFlick

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
                interactive: false
            }

            Column {
                id: advancedControlsContainer

                width: sideBarContainer.width
            }
        }
    }
}

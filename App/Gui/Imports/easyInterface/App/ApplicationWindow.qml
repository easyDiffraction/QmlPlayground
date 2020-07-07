import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import easyInterface.QtQuick 1.0 as InterfaceQtQuick
import easyInterface.App 1.0 as InterfaceApp
import easyInterface.Dialogs 1.0 as InterfaceDialogs
import easyInterface.Globals 1.0 as InterfaceGlobals
import easyInterface.Animations 1.0 as InterfaceAnimations

InterfaceQtQuick.ApplicationWindow {

    id: appWindow

    property alias appBarTabs: appBar.data
    property alias contentArea: contentAreaContainer.data
    property alias statusBar: statusBarContainer.data

    visible: true
    flags: InterfaceGlobals.Variable.appWindowFlags

    minimumWidth: InterfaceGlobals.Size.appWindowMinimumWidth
    minimumHeight: InterfaceGlobals.Size.appWindowMinimumHeight

    width: minimumWidth
    height: minimumHeight

    font.family: InterfaceGlobals.Font.regular
    font.pointSize: InterfaceGlobals.Font.pointSize

    Material.theme: InterfaceGlobals.Color.theme
    Material.accent: InterfaceGlobals.Color.themeAccent
    Material.primary: InterfaceGlobals.Color.themePrimary
    Material.background: InterfaceGlobals.Color.themeBackground

    // Application bar
    Item {
        id: appBarContainer

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: InterfaceGlobals.Size.appBarHeight

        InterfaceApp.ApplicationBar {
            id: appBar
        }
    }

    // Content area container
    Item {
        id: contentAreaContainer

        anchors.top: appBarContainer.bottom
        anchors.bottom: statusBarContainer.top
        anchors.left: parent.left
        anchors.right: parent.right
    }

    // Status bar container
    Item {
        id: statusBarContainer

        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: InterfaceGlobals.Size.statusBarHeight
    }

    // Application dialogs (invisible at the beginning)
    InterfaceDialogs.Preferences {}
}

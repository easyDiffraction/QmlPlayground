import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import easyInterface.QtQuick 1.0 as InterfaceQtQuick
import easyInterface.App 1.0 as InterfaceApp
import easyInterface.Globals 1.0 as InterfaceGlobals
import easyInterface.Animations 1.0 as InterfaceAnimations

InterfaceQtQuick.ToolBar {
    id: appBar

    visible: InterfaceGlobals.Variable.showAppBar

    width: parent.width
    height: parent.height

    Material.foreground: InterfaceGlobals.Color.appBarForeground
    Material.elevation: 0

    // Left group of application bar buttons
    Row {
        id: leftButtons

        anchors.left: parent.left
        anchors.leftMargin: 5
        height: parent.height

        InterfaceApp.ToolButton {
            icon.source: InterfaceGlobals.Icon.save
            ToolTip.text: qsTr("Save current state of the project")
        }

        InterfaceApp.ToolButton {
            icon.source: InterfaceGlobals.Icon.undo
            ToolTip.text: qsTr("Undo")
        }
        InterfaceApp.ToolButton {
            icon.source: InterfaceGlobals.Icon.redo
            ToolTip.text: qsTr("Redo")
        }
    }

    // Right group of application bar buttons
    Row {
        id: rightButtons

        anchors.right: parent.right
        anchors.rightMargin: 5
        height: parent.height

        InterfaceApp.ToolButton {
            icon.source: InterfaceGlobals.Icon.preferences
            ToolTip.text: qsTr("Application preferences")
            onClicked: InterfaceGlobals.Variable.showAppPreferencesDialog = true
        }

        InterfaceApp.ToolButton {
            icon.source: InterfaceGlobals.Icon.help
            ToolTip.text: qsTr("Get online help")
        }

        InterfaceApp.ToolButton {
            icon.source: InterfaceGlobals.Icon.bug
            ToolTip.text: qsTr("Report a bug or issue")
        }
    }

    // Application bar bottom border
    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        height: InterfaceGlobals.Size.borderThickness

        color: InterfaceGlobals.Color.appBarBorder
        Behavior on color {
            InterfaceAnimations.ThemeChange {}
        }
    }

    // Show-hide application bar animation
    Behavior on visible {
        InterfaceAnimations.BarShow {
            parentTarget: appBar
            positionOnTop: true
        }
    }
}

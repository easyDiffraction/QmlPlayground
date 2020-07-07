import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Material.impl 2.12

import easyInterface.App 1.0 as InterfaceApp
import easyInterface.Globals 1.0 as InterfaceGlobals
import easyInterface.Animations 1.0 as InterfaceAnimations

import easyDiffraction.Globals 1.0 as DiffractionGlobals
import easyDiffraction.App.Experiment.MainArea 1.0 as DiffractionMainArea

InterfaceApp.MainAreaContainer {
    id: window

    clip: true

    Component.onCompleted: animo.restart()

    // Content
    Column {
        anchors.centerIn: parent
        spacing: 20

        // Application icon, name and version
        Column {
            anchors.horizontalCenter: parent.horizontalCenter

            // Application icon
            Image {
                id: appIcon
                opacity: 0
                source: DiffractionGlobals.Icon.app
                anchors.horizontalCenter: parent.horizontalCenter
                width: 110
                fillMode: Image.PreserveAspectFit
                antialiasing: true
            }

            // Application name
            Row {
                id: appName
                opacity: 0
                anchors.horizontalCenter: parent.horizontalCenter
                Label {
                    text: "easy"
                    font.family: InterfaceGlobals.Font.condensedLight
                    font.pointSize: InterfaceGlobals.Font.pointSize * 4
                }
                Label {
                    text: "Diffraction"
                    font.family: InterfaceGlobals.Font.condensedRegular
                    font.pointSize: InterfaceGlobals.Font.pointSize * 4
                }
            }

            // Application version
            Label {
                id: appVersion
                opacity: 0
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Version %1 (%2)".arg(
                          DiffractionGlobals.Constants.appVersion).arg(
                          DiffractionGlobals.Constants.appDate)
            }
        }

        // Start button
        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            topPadding: 5

            Button {
                id: startButton
                anchors.horizontalCenter: parent.horizontalCenter
                opacity: 0
                topInset: 0
                bottomInset: 0
                horizontalPadding: 14
                font.bold: true
                font.capitalization: Font.MixedCase
                Material.elevation: 0
                Material.foreground: Material.theme == Material.Light ? "white" : "black"
                Material.background: Material.accent
                ToolTip.visible: hovered && ToolTip.text
                text: "Start Simulation/Refinement"
                ToolTip.text: "Simulation of the diffraction pattern or structure model refinement"
            }
        }

        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 0

            Component {
                id: linkButton

                TabButton {
                    height: 26
                    checkable: false
                    checked: true
                    font.capitalization: Font.MixedCase
                    text: parent.text
                }
            }

            Loader {
                id: aboutButton
                anchors.horizontalCenter: parent.horizontalCenter
                sourceComponent: linkButton
                opacity: 0
                property string text: "About easyDiffraction"
            }

            Loader {
                id: tutorialButton
                anchors.horizontalCenter: parent.horizontalCenter
                sourceComponent: linkButton
                opacity: 0
                property string text: "Get Started Video Tutorial"
            }

            Loader {
                id: documentationButton
                anchors.horizontalCenter: parent.horizontalCenter
                sourceComponent: linkButton
                opacity: 0
                property string text: "Online Documentation"
            }

            Loader {
                id: contactButton
                anchors.horizontalCenter: parent.horizontalCenter
                sourceComponent: linkButton
                opacity: 0
                property string text: "Get in Touch Online"
            }
        }
    }

    // Invisible popup on top of the application window to block
    // all the tooltips, etc. until intro animation is finished
    Popup {
        id: blockingPopup
        width: 0
        height: 0
        Material.elevation: 0
        closePolicy: Popup.NoAutoClose
        modal: true
        Overlay.modal: Rectangle {
            color: "transparent"
        }
    }

    ////////////
    // Animation
    ////////////
    SequentialAnimation {
        id: animo

        // Block all tooltips, etc.
        PropertyAction {
            target: blockingPopup
            property: "visible"
            value: true
        }

        // Show app name: opacity
        NumberAnimation {
            easing.type: Easing.Linear
            target: appName
            property: "opacity"
            to: 1
            duration: InterfaceGlobals.Variable.introAnimationDuration
        }

        // Show app version: opacity
        PropertyAnimation {
            easing.type: Easing.OutExpo
            target: appVersion
            property: "opacity"
            to: 1
            duration: InterfaceGlobals.Variable.introAnimationDuration
        }

        ParallelAnimation {

            // Show app icon, links: opacity
            PropertyAnimation {
                easing.type: Easing.OutExpo
                target: appIcon
                property: "opacity"
                to: 1
                duration: InterfaceGlobals.Variable.introAnimationDuration
            }
            PropertyAnimation {
                easing.type: Easing.OutExpo
                target: startButton
                property: "opacity"
                to: 1
                duration: InterfaceGlobals.Variable.introAnimationDuration
            }
            PropertyAnimation {
                easing.type: Easing.OutExpo
                target: aboutButton
                property: "opacity"
                to: 1
                duration: InterfaceGlobals.Variable.introAnimationDuration
            }
            PropertyAnimation {
                easing.type: Easing.OutExpo
                target: tutorialButton
                property: "opacity"
                to: 1
                duration: InterfaceGlobals.Variable.introAnimationDuration
            }
            PropertyAnimation {
                easing.type: Easing.OutExpo
                target: documentationButton
                property: "opacity"
                to: 1
                duration: InterfaceGlobals.Variable.introAnimationDuration
            }
            PropertyAnimation {
                easing.type: Easing.OutExpo
                target: contactButton
                property: "opacity"
                to: 1
                duration: InterfaceGlobals.Variable.introAnimationDuration
            }

            // Show app icon, links: moving
            PropertyAnimation {
                easing.type: Easing.OutExpo
                target: appIcon
                property: "y"
                from: -appIcon.height
                to: appIcon.y
                duration: InterfaceGlobals.Variable.introAnimationDuration
            }
            PropertyAnimation {
                easing.type: Easing.OutExpo
                target: startButton
                property: "y"
                from: window.height
                to: startButton.y
                duration: InterfaceGlobals.Variable.introAnimationDuration
            }
            PropertyAnimation {
                easing.type: Easing.OutExpo
                target: aboutButton
                property: "y"
                from: window.height
                to: aboutButton.y
                duration: InterfaceGlobals.Variable.introAnimationDuration
            }
            PropertyAnimation {
                easing.type: Easing.OutExpo
                target: tutorialButton
                property: "y"
                from: window.height
                to: tutorialButton.y
                duration: InterfaceGlobals.Variable.introAnimationDuration
            }
            PropertyAnimation {
                easing.type: Easing.OutExpo
                target: documentationButton
                property: "y"
                from: window.height
                to: documentationButton.y
                duration: InterfaceGlobals.Variable.introAnimationDuration
            }
            PropertyAnimation {
                easing.type: Easing.OutExpo
                target: contactButton
                property: "y"
                from: window.height
                to: contactButton.y
                duration: InterfaceGlobals.Variable.introAnimationDuration
            }

            // Show application bar
            PropertyAction {
                target: InterfaceGlobals.Variable
                property: "showAppBar"
                value: true
            }

            // Show status bar
            PropertyAction {
                target: InterfaceGlobals.Variable
                property: "showAppStatusBar"
                value: true
            }

            // Change window flags
            PropertyAction {
                target: InterfaceGlobals.Variable
                property: "appWindowFlags"
                value: Qt.Window
            }
        }

        // Unblock all tooltips, etc.
        PropertyAction {
            target: blockingPopup
            property: "visible"
            value: false
        }
    }
}

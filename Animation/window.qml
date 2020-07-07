import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14

Window {
    id: root

    property int commonSpacing: 20
    property int animationMeetPoint: width / 2 - 120
    property int animationDuration: 1000
    property var animationEasingType: Easing.OutExpo

    visible: true
    width: 1000
    height: 500

    // CONTENT
    Column {
        anchors.fill: parent
        anchors.margins: commonSpacing
        spacing: commonSpacing

        // Buttons
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: commonSpacing

            Button {
                id: animo_button
                text: "Restart animo"
                onClicked: {
                    animo.restart()
                    easydiffraction.opacity = 1
                }
            }

            Button {
                id: hide_button
                text: "Hide"
                onClicked: easydiffraction.opacity = 0
            }
        }

        // Logo + text
        Row {
            id: easydiffraction

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: commonSpacing
            opacity: 0

            Image {
                id: ed_logo
                sourceSize.width: 100
                fillMode: Image.PreserveAspectFit
                source: "logo.svg"
            }

            Label {
                id: ed_text
                height: ed_logo.height
                verticalAlignment: Qt.AlignVCenter
                font.pointSize: 50
                text: "easyDiffraction"
            }
        }
    }

    // ANIMATION
    ParallelAnimation {
        id: animo

        // Logo
        RotationAnimation {
            target: ed_logo
            easing.type: animationEasingType
            from: 0
            to: 360
            duration: animationDuration
        }
        PropertyAnimation {
            target: ed_logo
            easing.type: animationEasingType
            property: "x"
            from: -ed_logo.width
            to: animationMeetPoint - ed_logo.width - commonSpacing
            duration: animationDuration
        }
        NumberAnimation {
            target: ed_logo
            easing.type: animationEasingType
            property: "opacity"
            from: 0
            to: 1
            duration: animationDuration
        }

        // Text
        PropertyAnimation {
            target: ed_text
            easing.type: animationEasingType
            property: "x"
            from: root.width
            to: animationMeetPoint
            duration: animationDuration
        }
        NumberAnimation {
            target: ed_text
            easing.type: Easing.OutCubic
            property: "opacity"
            from: 0
            to: 1
            duration: animationDuration
        }
    }
}

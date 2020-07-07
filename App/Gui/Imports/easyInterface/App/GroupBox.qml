import QtQuick 2.12
import QtGraphicalEffects 1.12
import QtQuick.Templates 2.12 as T
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Material.impl 2.12

import easyInterface.Globals 1.0 as InterfaceGlobals

T.GroupBox {
    id: control

    default property alias contentItemData: contentItem.data
    property bool collapsible: true
    property bool collapsed: collapsible ? true : false

    implicitWidth: Math.max(
                       titleItem.implicitWidth + leftPadding + rightPadding,
                       contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: titleItem.implicitHeight + contentItem.height + spacing
                    + topPadding + bottomPadding

    spacing: 0 // between title and content
    padding: 0
    topPadding: 0
    bottomPadding: 0
    leftPadding: 0
    rightPadding: 0

    title: "Untitled group"
    width: parent.width

    // Title area
    label: Button {
        id: titleItem

        implicitHeight: InterfaceGlobals.Size.tabBarHeight
        width: control.width

        topInset: 0
        bottomInset: 0

        checkable: false
        enabled: collapsible
        flat: true
        display: AbstractButton.TextOnly // icon reimplemented below to support rotation animation

        font.bold: true
        font.capitalization: Font.MixedCase

        text: control.title

        // Custom icon
        Image {
            id: icon

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10

            width: 10
            fillMode: Image.PreserveAspectFit

            source: collapsible ? InterfaceGlobals.Icon.play : InterfaceGlobals.Icon.circle

            transform: Rotation {
                id: iconRotation

                origin.x: icon.width * 0.5
                origin.y: icon.height * 0.5

                Component.onCompleted: collapsed ? angle = 0 : angle = 90
            }

            ColorOverlay {
                anchors.fill: icon
                source: icon
                color: label.color
            }
        }

        // Custom text label
        contentItem: null // reimplemented as label to support above icon rotation animation
        Label {
            id: label

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: icon.right
            anchors.leftMargin: 8

            text: titleItem.text
            font: titleItem.font
            color: titleItem.Material.accent
        }

        // On clicked animation
        onClicked: {
            contentItem.height === 0 ? collapsed = true : collapsed = false
            animo.restart()
        }
    }

    // Content area
    background: Column {
        id: contentItem

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        anchors.leftMargin: icon.anchors.leftMargin
        anchors.rightMargin: anchors.leftMargin

        topPadding: 0
        bottomPadding: anchors.leftMargin
        leftPadding: icon.width * 0.5
        rightPadding: 0

        //width: control.width
        height: 0

        clip: true

        Component.onCompleted: collapsed ? height = 0 : height = implicitHeight
    }

    // Horisontal border at the bottom
    Rectangle {
        id: bottomBorder

        y: control.height - height

        width: control.width
        height: InterfaceGlobals.Size.borderThickness

        color: InterfaceGlobals.Color.appBorder
    }

    // Collapsion animation
    ParallelAnimation {
        id: animo

        NumberAnimation {
            target: contentItem
            property: "height"
            to: collapsed ? contentItem.implicitHeight : 0
            duration: 150
        }

        NumberAnimation {
            target: iconRotation
            property: "angle"
            to: collapsed ? 90 : 0
            duration: 150
        }
    }
}

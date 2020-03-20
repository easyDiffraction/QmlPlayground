import QtQuick 2.13
import QtQuick.Templates 2.13 as T
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13

import AsQuick.Globals 1.0 as Globals

T.ToolTip {
    id: control

    x: parent ? (parent.width - implicitWidth) / 2 : 0
    y: -implicitHeight - 24

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    margins: 12
    padding: 8
    horizontalPadding: padding + 8

    closePolicy: T.Popup.CloseOnEscape |
                 T.Popup.CloseOnPressOutsideParent |
                 T.Popup.CloseOnReleaseOutsideParent

    font.family: Globals.Font.sans

    Material.theme: Material.Dark

    contentItem: Label {
        text: control.text
        font: control.font
        color: control.Material.foreground
    }

    background: Rectangle {
        implicitHeight: control.Material.tooltipHeight
        color: control.Material.tooltipColor
        opacity: 0.9
        radius: 2
    }

    enter: Transition {
        NumberAnimation {
            property: "opacity"
            from: 0.0
            to: 1.0
            easing.type: Easing.OutQuad
            duration: 500
        }
    }

    exit: Transition {
        NumberAnimation {
            property: "opacity"
            from: 1.0
            to: 0.0
            easing.type: Easing.InQuad
            duration: 500
        }
    }
}


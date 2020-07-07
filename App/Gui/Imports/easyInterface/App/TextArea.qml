import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import easyInterface.Globals 1.0 as InterfaceGlobals
import easyInterface.QtQuick 1.0 as InterfaceQtQuick

Rectangle {
    id: container

    property alias text: textArea.text
    property alias textFormat: textArea.textFormat
    property alias wrapMode: textArea.wrapMode

    color: InterfaceGlobals.Color.mainAreaBackground

    Flickable {
        anchors.fill: parent

        contentHeight: textArea.implicitHeight
        contentWidth: textArea.width
        clip: true

        flickableDirection: Flickable.VerticalFlick

        ScrollBar.horizontal: InterfaceQtQuick.ScrollBar {
            policy: ScrollBar.AsNeeded
            //Component.onCompleted: position = 0
        }

        ScrollBar.vertical: InterfaceQtQuick.ScrollBar {
            policy: ScrollBar.AsNeeded
            //Component.onCompleted: position = 0
        }

        // TextArea
        TextEdit {
            id: textArea

            width: wrapMode === TextEdit.NoWrap ? implicitWidth : container.width

            leftPadding: 4
            rightPadding: 4
            topPadding: 0
            bottomPadding: 0
            textMargin: 8

            readOnly: true

            selectByKeyboard: true
            selectByMouse: true

            color: enabled ? Material.foreground : Material.hintTextColor
            selectionColor: Material.accentColor
            selectedTextColor: Material.primaryHighlightedTextColor
        }
    }
}

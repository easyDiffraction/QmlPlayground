import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import easyInterface.Globals 1.0 as InterfaceGlobals

Flickable {
    property alias text: textArea.text
    property alias wrapMode: textArea.wrapMode

    contentHeight: contentItem.childrenRect.height
    contentWidth: contentItem.childrenRect.width

    clip: true
    flickableDirection: Flickable.VerticalFlick

    ScrollBar.vertical: ScrollBar {
        policy: ScrollBar.AsNeeded
        interactive: false
        Component.onCompleted: position = 0
    }

    TextArea.flickable: TextArea {
        id: textArea

        leftPadding: 4
        rightPadding: 4
        topPadding: 0
        bottomPadding: 0
        textMargin: 8

        wrapMode: TextArea.WordWrap

        background: Rectangle {
            color: InterfaceGlobals.Color.mainAreaBackground
        }
    }
}

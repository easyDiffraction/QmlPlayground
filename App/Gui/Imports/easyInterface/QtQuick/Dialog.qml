import QtQuick 2.12
import QtQuick.Templates 2.12 as T
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Material.impl 2.12

import easyInterface.Globals 1.0 as InterfaceGlobals

Dialog {
    id: control

    parent: Overlay.overlay
    anchors.centerIn: parent
    modal: true

    T.Overlay.modal: Rectangle {
        color: InterfaceGlobals.Color.dialogBackground

        Behavior on opacity {
            NumberAnimation {
                duration: InterfaceGlobals.Color.dialogOpacityTime
            }
        }
    }
}

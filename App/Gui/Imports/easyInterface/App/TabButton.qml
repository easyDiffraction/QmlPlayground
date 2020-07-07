import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import easyInterface.Globals 1.0 as InterfaceGlobals
import easyInterface.Animations 1.0 as InterfaceAnimations

TabButton {
    id: button

    implicitHeight: parent.height
    width: implicitWidth
    icon.height: 18
    icon.width: 18

    font.bold: true
    font.capitalization: Font.MixedCase

    ToolTip.visible: hovered && ToolTip.text

    Behavior on text {
        InterfaceAnimations.TranslationChange {}
    }
}

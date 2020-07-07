import QtQuick 2.12

import easyInterface.Globals 1.0 as InterfaceGlobals

SequentialAnimation {

    // Animation with old text
    ParallelAnimation {
        NumberAnimation {
            target: parent
            property: "opacity"
            to: 0
            duration: InterfaceGlobals.Color.translationChangeTime
            easing.type: Easing.InCirc
        }
    }

    // Text changed
    PropertyAction {}

    // Animation with new text
    ParallelAnimation {
        NumberAnimation {
            target: parent
            property: "opacity"
            to: 1
            duration: InterfaceGlobals.Color.translationChangeTime
            easing.type: Easing.OutCirc
        }
    }
}

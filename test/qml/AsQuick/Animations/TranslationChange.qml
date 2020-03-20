import QtQuick 2.13

import AsQuick.Globals 1.0 as Globals

SequentialAnimation {

    // Animation with old text
    ParallelAnimation {
        NumberAnimation {
            target: parent
            property: "opacity"
            to: 0
            duration: Globals.Variable.translationChangeTime
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
            duration: Globals.Variable.translationChangeTime
            easing.type: Easing.OutCirc
        }
    }
}

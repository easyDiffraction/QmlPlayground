import QtQuick 2.12

import easyInterface.Globals 1.0 as InterfaceGlobals

SequentialAnimation {
    property var parentTarget
    property bool positionOnTop: false

    alwaysRunToEnd: true

    PropertyAnimation {
        target: parentTarget
        property: "y"
        to: positionOnTop ? -parentTarget.height : parentTarget.height
        duration: parentTarget.visible ? InterfaceGlobals.Variable.introAnimationDuration : 0
        easing.type: Easing.OutExpo
    }

    PropertyAction {}

    PropertyAnimation {
        target: parentTarget
        property: "y"
        to: 0
        duration: parentTarget.visible ? 0 : InterfaceGlobals.Variable.introAnimationDuration
        easing.type: Easing.OutExpo
    }
}

import QtQuick 2.12

import easyInterface.Globals 1.0 as InterfaceGlobals

PropertyAnimation {
    duration: InterfaceGlobals.Color.themeChangeTime
    alwaysRunToEnd: true
    easing.type: Easing.OutQuint
}

import QtQuick 2.13

import AsQuick.Globals 1.0 as Globals

PropertyAnimation {
    duration: Globals.Variable.themeChangeTime
    alwaysRunToEnd: true
    easing.type: Easing.OutQuint
}

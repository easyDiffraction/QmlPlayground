pragma Singleton

import QtQuick 2.12

QtObject {

    // Application
    readonly property string app: iconPath("App.svg")

    // Logic
    function iconPath(iconFileName) {
        const iconsDirPath = Qt.resolvedUrl("../Resources/Icons/")
        return iconsDirPath + iconFileName
    }
}

pragma Singleton

import QtQuick 2.13

QtObject {

    // Initial application parameters
    property int appWindowFlags: Qt.Window // Qt.FramelessWindowHint | Qt.Dialog

    // Animation time
    property int themeChangeTime: 450
    property int translationChangeTime: 300

}

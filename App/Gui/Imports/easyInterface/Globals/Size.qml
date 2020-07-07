pragma Singleton

import QtQuick 2.12

QtObject {

    // Application window
    readonly property int appWindowMinimumWidth: 1280
    readonly property int appWindowMinimumHeight: 760

    // Application bar
    readonly property int appBarHeight: 48
    readonly property int appBarHPadding: 8
    readonly property int appBarElevation: 2

    // Sidebar
    readonly property int sideBarWidth: 605
    readonly property int groupBoxSpacing: 12

    // Status bar
    readonly property int statusBarHeight: 32

    // Common
    readonly property int tabBarHeight: 48
    readonly property int borderThickness: 1
}

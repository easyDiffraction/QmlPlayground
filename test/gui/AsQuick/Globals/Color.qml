pragma Singleton

import QtQuick 2.13
import QtQuick.Controls.Material 2.13

QtObject {

    // Theme
    property int theme: Material.Dark
    property bool lightTheme: theme === Material.Light
    property color themeAccent: lightTheme ? "#00a3e3" : "#4ec1ef"
    property color themePrimary: lightTheme ? "#ddd" : "#222"
    property color themeBackground: lightTheme ? "#eee" : "#333"
    property color themeForeground: lightTheme ? "#333" : "#eee"

    // Application window
    property color appBorder: lightTheme ? "#ddd" : "#262626"

    // Application bar (on top of the application window)
    property color appBarBackground: themeBackground
    property color appBarForeground: lightTheme ? "#222" : "#eee"
    property color appBarBorder: lightTheme ? "#ccc" : "#111"

    // Main area
    property color mainAreaBackground: lightTheme ? "#f4f4f4" : "#3a3a3a"

    // Chart areas
    property color chartForeground: themeForeground
    readonly property color chartBackground: "transparent"
    readonly property color chartPlotAreaBackground: "transparent"
    readonly property color deaths: Qt.rgba(255/255, 105/255, 94/255, 0.75)
    readonly property color active: Qt.rgba(42/255, 153/255, 217/255, 0.75)
    readonly property color recovered: Qt.rgba(99/255, 191/255, 102/255, 0.75)

}

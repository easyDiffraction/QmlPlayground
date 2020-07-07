pragma Singleton

import QtQuick 2.12
import QtQuick.Controls.Material 2.12
import QtCharts 2.12

import easyInterface.Globals 1.0 as InterfaceGlobals

QtObject {

    // Colors
    readonly property string blue: "#2a99d9" // ESS #3e93c5 or #0094ca ?
    readonly property string red: "#ed6a5e"
    readonly property string green: "#7ab03c"

    // Theme
    property int theme: Material.Dark
    property bool _light: theme === Material.Light
    property color themeAccent: _light ? blue : Qt.lighter(blue, 1.6)
    property color themePrimary: _light ? "#ddd" : "#222"
    property color themeBackground: _light ? "#eee" : "#333"
    property color themeForeground: _light ? "#333" : "#eee"
    property int themeChangeTime: 450

    // Application window
    property color appBorder: _light ? "#ddd" : "#262626"
    property int translationChangeTime: 300

    // Application bar (on top of the application window)
    property color appBarBackground: themeBackground
    property color appBarForeground: _light ? "#444" : "#ccc"
    property color appBarBorder: _light ? "#ccc" : "#111"

    // Main area
    property color mainAreaBackground: _light ? "#f4f4f4" : "#3a3a3a"

    // Status bar
    readonly property color statusBarBackground: themePrimary
    readonly property color statusBarForeground: _light ? "#666" : "#aaa"

    // Dialogs
    property color dialogBackground: _light ? "#80ffffff" : "#80000000"
    property int dialogOpacityTime: 150

    // Chart areas
    property int chartTheme: _light ? ChartView.ChartThemeLight : ChartView.ChartThemeDark
    property color chartBackground: _light ? "#00ffffff" : "#00000000"
    property color chartForeground: Material.foreground

    // Text areas
    property color textAreaBackground: "transparent"
}

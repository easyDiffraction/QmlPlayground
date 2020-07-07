import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtCharts 2.12

import easyInterface.Globals 1.0 as InterfaceGlobals
import easyInterface.Animations 1.0 as InterfaceAnimations

ValueAxis {
    lineVisible: false // Hide axes lines (only grid is visible)
    color: InterfaceGlobals.Color.appBorder
    Behavior on color {
        InterfaceAnimations.ThemeChange {}
    }

    gridLineColor: InterfaceGlobals.Color.appBorder
    Behavior on gridLineColor {
        InterfaceAnimations.ThemeChange {}
    }

    labelsColor: InterfaceGlobals.Color.chartForeground
    Behavior on labelsColor {
        InterfaceAnimations.ThemeChange {}
    }

    labelsFont.family: InterfaceGlobals.Font.regular
    titleFont.family: InterfaceGlobals.Font.regular
    titleFont.bold: true
}

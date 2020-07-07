import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Templates 2.12 as T
import QtQuick.Controls.Material 2.12

import easyInterface.Animations 1.0 as InterfaceAnimations

T.ApplicationWindow {
    color: Material.backgroundColor
    Behavior on color {
        InterfaceAnimations.ThemeChange {}
    }
}

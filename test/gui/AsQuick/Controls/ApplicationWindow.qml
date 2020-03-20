import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Templates 2.13 as T
import QtQuick.Controls.Material 2.13

import AsQuick.Globals 1.0 as Globals
import AsQuick.Animations 1.0 as Animations

T.ApplicationWindow {
    visible: true
    flags: Globals.Variable.appWindowFlags

    minimumWidth: Globals.Size.appWindowMinimumWidth
    minimumHeight: Globals.Size.appWindowMinimumHeight

    width: minimumWidth
    height: minimumHeight

    font.family: Globals.Font.sans
    font.pointSize: Globals.Font.pointSize

    Material.theme: Globals.Color.theme
    Material.accent: Globals.Color.themeAccent
    Material.primary: Globals.Color.themePrimary
    Material.background: Globals.Color.themeBackground

    color: Globals.Color.mainAreaBackground
    Behavior on color {
        Animations.ThemeChange {}
    }
}

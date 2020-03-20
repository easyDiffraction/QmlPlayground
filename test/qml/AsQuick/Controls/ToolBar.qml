import QtQuick 2.13
import QtQuick.Templates 2.13 as T
import QtQuick.Controls.Material 2.13
import QtQuick.Controls.Material.impl 2.13

import AsQuick.Globals 1.0 as Globals
import AsQuick.Animations 1.0 as Animations

T.ToolBar {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    spacing: Globals.Size.appBarSpacing

    font.family: Globals.Font.sans
    font.pointSize: Globals.Font.pointSize

    Material.background: Globals.Color.appBarBackground
    Material.foreground: Globals.Color.appBarForeground
    Material.elevation: Globals.Size.appBarElevation

    background: Rectangle {
        implicitHeight: Globals.Size.appBarHeight

        color: control.Material.toolBarColor
        Behavior on color {
            Animations.ThemeChange {}
        }

        layer.enabled: control.Material.elevation > 0
        layer.effect: ElevationEffect {
            elevation: control.Material.elevation
            fullWidth: true
        }
    }
}

import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

Button {
    anchors.verticalCenter: parent.verticalCenter
    padding: 0
    implicitWidth: 36
    icon.height: 18
    icon.width: 18

    flat: true
    display: AbstractButton.IconOnly

    ToolTip.visible: hovered && ToolTip.text
}

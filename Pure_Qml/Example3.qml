import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Window {
    visible: true
    width: 400
    height: 200
    color: "#fafafa"

    RowLayout {
        anchors.fill: parent

        Button {
            Layout.alignment: Qt.AlignCenter
            text: "Ok"
        }

        Button {
            Layout.alignment: Qt.AlignCenter
            text: "Cancel"
            ToolTip.visible: hovered
            ToolTip.text: qsTr("This is a tooltip message")
        }
    }
}

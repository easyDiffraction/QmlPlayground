import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtQuick.Window 2.0

Window {
    visible: true
    width: 400
    height: 300
    title: qsTr("QtQuick: Hello World!")

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20

        Button {
            text: "One"
            Layout.fillWidth: true
        }

        Button {
            text: "Two"
            Layout.fillWidth: true
        }

        Button {
            text: "Three"
            Layout.fillWidth: true
        }
    }
}

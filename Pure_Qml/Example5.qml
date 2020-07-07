import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

Window {
    visible: true
    width: 420
    height: 300
    color: "#fafafa"

    Column {
        id: column
        x: 131
        y: 18
        width: 200
        height: 400

        Label {
            id: label
            anchors.centerIn: parent
            font.pixelSize: 22
            font.bold: true
            text: "Hello, World -- "
            opacity: 1
        }
    }

    Component.onCompleted: {
        label.text += Math.random()
    }
}

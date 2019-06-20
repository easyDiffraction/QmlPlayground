import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

Window {
    property int window_width: 400
    property int window_height: 200

    visible: true
    title: "Hello World"
    color: "#fafafa"

    width: window_width
    height: window_height

    Button {
        anchors.centerIn: parent
        text: "Window size: " + window_width + " x " + window_height
    }
}

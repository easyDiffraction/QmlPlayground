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
        anchors.margins: 20
        spacing: 20

        Button {
            Layout.fillWidth: true
            id: okButton
            text: "Ok"
        }

        Button {
            Layout.fillWidth: true
            text: "Cancel"
            onClicked: {
                okButton.text = "Not Ok!!!"
            }
        }
    }
}

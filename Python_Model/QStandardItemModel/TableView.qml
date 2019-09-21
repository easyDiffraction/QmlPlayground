import QtQuick 2.12
import QtQuick.Controls 2.12

Rectangle {
    property alias headerModel: headerTableView.model
    property alias dataModel: contentTableView.model

    property bool editable: false

    property int borderWidth: 1
    property int cellWidth: 150
    property int cellHeight: 30
    property int rowCountToDisplayWithoutHeader: 4

    property string rowBackgroundColor: 'white'
    property string alternateRowBackgroundColor: '#f7f7f7'
    property string headerBackgroundColor: '#eee'
    property string headerBorderColor: '#dedede'

    width: childrenRect.width
    height: childrenRect.height
    border.color: headerBorderColor
    border.width: borderWidth

    Column {
        width: childrenRect.width + borderWidth * 2
        height: childrenRect.height + borderWidth * 2
        x: borderWidth
        y: borderWidth
        spacing: 0

        // Header
        TableView {
            id: headerTableView
            width: cellWidth * columns
            height: cellHeight
            enabled: false

            delegate: Rectangle {
                implicitWidth: cellWidth
                implicitHeight: cellHeight
                color: headerBackgroundColor

                Text {
                    anchors.fill: parent
                    leftPadding: font.pixelSize
                    rightPadding: leftPadding
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    enabled: false
                    text: display
                }
            }
        }

        // Main content
        TableView {
            id: contentTableView
            width: cellWidth * columns
            height: cellHeight * rowCountToDisplayWithoutHeader
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            ScrollBar.horizontal: ScrollBar { policy: ScrollBar.AlwaysOff }
            ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded; minimumSize: 1 / rowCountToDisplayWithoutHeader }

            delegate: Rectangle {
                implicitWidth: cellWidth
                implicitHeight: cellHeight
                color: row % 2 ? alternateRowBackgroundColor : rowBackgroundColor

                TextInput {
                    anchors.fill: parent
                    leftPadding: font.pixelSize
                    rightPadding: leftPadding
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    enabled: editable
                    text: display
                    onEditingFinished: edit = text
                }
            }
        }
    }
}


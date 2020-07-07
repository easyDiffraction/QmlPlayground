import QtQuick 2.12
import QtQuick.Controls 2.12

Rectangle {
    property alias model: contentListView.model

    property int borderWidth: 1
    property int cellHeight: 40
    property int rowCountToDisplayWithoutHeader: 4

    property string rowBackgroundColor: 'white'
    property string alternateRowBackgroundColor: '#f7f7f7'
    property string highlightedRowBackgroundColor: "#2a99d9"
    property string rowForegroundColor: "black"
    property string highlightedRowForegroundColor: "white"
    property string headerBackgroundColor: '#eee'
    property string headerBorderColor: '#dedede'

    id: listViewWrapper
    width: parent.width
    height: cellHeight * (rowCountToDisplayWithoutHeader + 1) + border.width * 2
    border.color: headerBorderColor
    border.width: borderWidth

    function cellWidthProvider(column) {
        const allColumnWidth = width
        const numberColumnWidth = 40
        const refineColumnWidth = cellHeight * 1.5
        const flexibleColumnsWidth = allColumnWidth - numberColumnWidth - refineColumnWidth
        const flexibleColumnsCount = 3
        if (column === 1)
            return numberColumnWidth
        else if (column === 2)
            return flexibleColumnsWidth / flexibleColumnsCount
        else if (column === 3)
            return flexibleColumnsWidth / flexibleColumnsCount
        else if (column === 4)
            return flexibleColumnsWidth / flexibleColumnsCount
        else if (column === 5)
            return refineColumnWidth
        else return 0
    }

    Column {
        anchors.fill: parent
        anchors.margins: parent.border.width
        spacing: 0

        // Header
        ListView {
            id: headerListView
            width: parent.width
            height: cellHeight
            enabled: false

            header: Rectangle {
                width: parent.width
                height: cellHeight
                color: headerBackgroundColor

                Row {
                    anchors.fill: parent

                    Text {
                        width: cellWidthProvider(1)
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignRight
                        leftPadding: font.pixelSize
                        rightPadding: leftPadding
                        text: "No."
                    }
                    Text {
                        width: cellWidthProvider(2)
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        leftPadding: font.pixelSize
                        rightPadding: leftPadding
                        text: "Label"
                    }
                    Text {
                        width: cellWidthProvider(3)
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignRight
                        leftPadding: font.pixelSize
                        rightPadding: leftPadding
                        text: "Value"
                    }
                    Text {
                        width: cellWidthProvider(4)
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignRight
                        leftPadding: font.pixelSize
                        rightPadding: leftPadding
                        text: "Error"
                    }
                    Text {
                        width: cellWidthProvider(5)
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: "Fit"
                    }
                }
            }
        }

        // Main content
        ListView {

            id: contentListView
            width: parent.width
            height: cellHeight * rowCountToDisplayWithoutHeader
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            ScrollBar.horizontal: ScrollBar { policy: ScrollBar.AlwaysOff }
            ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded; minimumSize: 1 / rowCountToDisplayWithoutHeader }

            // Content row
            delegate: Rectangle {
                id: contentRow
                width: parent.width
                height: cellHeight
                color: backgroundColor()

                function foregroundColor() {
                    return index === contentListView.currentIndex ? highlightedRowForegroundColor : rowForegroundColor
                }
                function backgroundColor() {
                    if (index === contentListView.currentIndex)
                        return highlightedRowBackgroundColor
                    else
                        return index % 2 ? alternateRowBackgroundColor : rowBackgroundColor
                }

                Row {
                    anchors.fill: parent

                    Text {
                        width: cellWidthProvider(1)
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignRight
                        leftPadding: font.pixelSize
                        rightPadding: leftPadding
                        text: model.index + 1
                        color: foregroundColor()
                    }
                    Text {
                        width: cellWidthProvider(2)
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        leftPadding: font.pixelSize
                        rightPadding: leftPadding
                        text: model.label
                        color: foregroundColor()
                    }
                    TextInput {
                        width: cellWidthProvider(3)
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignRight
                        leftPadding: font.pixelSize
                        rightPadding: leftPadding
                        text: model.value
                        color: foregroundColor()
                        onEditingFinished: model.value = text
                    }
                    Text {
                        width: cellWidthProvider(4)
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignRight
                        leftPadding: font.pixelSize
                        rightPadding: leftPadding
                        text: model.error
                        color: foregroundColor()
                    }
                    CheckBox {
                        width: cellWidthProvider(5)
                        height: parent.height
                        checked: model.refine
                        onToggled: model.refine = checked
                    }
                }

                // Change current row by mouse click
                MouseArea {
                    anchors.fill: parent
                    propagateComposedEvents: true
                    acceptedButtons: Qt.LeftButton
                    onPressed: {
                        contentListView.currentIndex = index
                        mouse.accepted = false
                    }
                }

            }
            // Content row

        }

    }

}

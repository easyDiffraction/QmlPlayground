import QtQuick 2.12
import QtQuick.Controls 2.12

Column {
    property alias model: contentListView.model

    //property int currentIndexX: -1

    property int borderWidth: 1
    property int cellHeight: 38
    property int rowCountToDisplayWithoutHeader: 10

    property string rowBackgroundColor: 'white'
    property string alternateRowBackgroundColor: '#f7f7f7'
    property string highlightedRowBackgroundColor: "#2a99d9"
    property string rowForegroundColor: "black"
    property string highlightedRowForegroundColor: "white"
    property string headerBackgroundColor: '#eee'
    property string headerBorderColor: '#dedede'

    spacing: 6

    function cellWidthProvider(column) {
        const allColumnWidth = width - borderWidth * 2
        const numberColumnWidth = 40
        const refineColumnWidth = cellHeight * 1.5
        const flexibleColumnsWidth = allColumnWidth - numberColumnWidth - refineColumnWidth
        const flexibleColumnsCount = 3
        if (column === 1)
            return numberColumnWidth
        else if (column === 2)
            return 2 * flexibleColumnsWidth / flexibleColumnsCount
        else if (column === 3)
            return 0.5 * flexibleColumnsWidth / flexibleColumnsCount
        else if (column === 4)
            return 0.5 * flexibleColumnsWidth / flexibleColumnsCount
        else if (column === 5)
            return refineColumnWidth
        else return 0
    }

    Rectangle {
        id: listViewWrapper
        width: parent.width
        height: childrenRect.height
        border.color: headerBorderColor
        border.width: borderWidth

        Column {
            width: parent.width - parent.border.width * 2
            height: childrenRect.height + parent.border.width * 2
            spacing: 0
            padding: parent.border.width

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
                            text: index + 1
                            color: foregroundColor()
                        }
                        Text {
                            width: cellWidthProvider(2)
                            height: parent.height
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            leftPadding: font.pixelSize
                            rightPadding: leftPadding
                            text: label
                            color: foregroundColor()
                        }
                        TextInput {
                            id: qwe
                            width: cellWidthProvider(3)
                            height: parent.height
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignRight
                            leftPadding: font.pixelSize
                            rightPadding: leftPadding
                            text: typeof value === 'number' ? value.toFixed(4) : value
                            color: foregroundColor()
                            onEditingFinished: valueEdit = text
                        }
                        Text {
                            width: cellWidthProvider(4)
                            height: parent.height
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignRight
                            leftPadding: font.pixelSize
                            rightPadding: leftPadding
                            text: error ? error.toFixed(4) : ""
                            color: foregroundColor()
                        }
                        CheckBox {
                            width: cellWidthProvider(5)
                            height: parent.height
                            checked: refine
                            onToggled: refineEdit = checked
                        }
                    }

                    // Change current row by mouse click
                    MouseArea {
                        anchors.fill: parent
                        propagateComposedEvents: true
                        acceptedButtons: Qt.LeftButton
                        onPressed: {
                            contentListView.currentIndex = index
                            //currentIndexX = index
                            mouse.accepted = false
                        }
                    }

                }
                // Content row

            }
        }
    }

    // Slider
    Row {
        id: slideRow
        width: parent.width
        height: cellHeight
        spacing: 10

        Label {
            id: min
            width: 80
            height: parent.height
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            leftPadding: font.pixelSize
            rightPadding: leftPadding
            background: Rectangle { border.width: borderWidth; border.color: headerBorderColor }
            text: contentListView.model.data(contentListView.model.index(contentListView.currentIndex, 0), Qt.UserRole + 5).toFixed(4)
        }
        Slider {
            width: parent.width - parent.spacing * 2 - min.width - max.width;
            height: parent.height
            from: contentListView.model.data(contentListView.model.index(contentListView.currentIndex, 0), Qt.UserRole + 5)
            value: contentListView.model.data(contentListView.model.index(contentListView.currentIndex, 0), Qt.UserRole + 3)
            to: contentListView.model.data(contentListView.model.index(contentListView.currentIndex, 0), Qt.UserRole + 6)
            onMoved: contentListView.model.setData(contentListView.model.index(contentListView.currentIndex, 0), value, Qt.UserRole + 103)
            Component.onCompleted: {
                //contentListView.currentIndex = 1
                //contentListView.currentIndex = 0
            }
        }
        Label {
            id: max
            width: min.width
            height: parent.height
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            leftPadding: font.pixelSize
            rightPadding: leftPadding
            background: Rectangle { border.width: borderWidth; border.color: headerBorderColor }
            text: contentListView.model.data(contentListView.model.index(contentListView.currentIndex, 0), Qt.UserRole + 6).toFixed(4)
        }
    }
    // Slider

}

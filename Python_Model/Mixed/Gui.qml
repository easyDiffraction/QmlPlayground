import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtCharts 2.13

ApplicationWindow {
    id: window
    visible: true
    width: 700
    height: 800

    property string rowBackgroundColor: 'white'
    property string alternateRowBackgroundColor: '#f7f7f7'
    property string headerBackgroundColor: '#eee'
    property string rowBorderColor: '#e8e8e8'
    property string headerBorderColor: '#dedede'
    property string headerTextColor: '#666'

    property int borderWidth: 1
    property int cellWidth: 150
    property int cellHeight: 30

    property var startTime: Date.now()

    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        //////////////////////////////////////////
        // Fitables table as ListView
        Rectangle {
            width: parent.width
            height: cellHeight * 4 + borderWidth * 2
            border.width: borderWidth
            border.color: headerBorderColor

            ListView {
                id: listView
                anchors.fill: parent
                anchors.margins: borderWidth
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                headerPositioning: ListView.OverlayHeader // 'z' property in 'header' is also needed

                model: proxy.list

                // Table header
                header: Rectangle {
                    width: parent.width
                    height: cellHeight
                    color: headerBackgroundColor
                    z: 2 // needed in connection with 'headerPositioning' property above

                    Row {
                        width: parent.width
                        height: parent.height
                        spacing: 10

                        Text {
                            width: cellWidth
                            height: cellHeight
                            leftPadding: font.pixelSize
                            rightPadding: leftPadding
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                            text: "Name"
                        }

                        Text {
                            width: cellWidth
                            height: cellHeight
                            leftPadding: font.pixelSize
                            rightPadding: leftPadding
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignVCenter
                            text: "Value"
                        }

                        Text {
                            width: 2*cellWidth
                            height: cellHeight
                            leftPadding: font.pixelSize
                            rightPadding: leftPadding
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignVCenter
                            text: "Error"
                        }

                        Text {
                            width: cellHeight
                            height: cellHeight
                            leftPadding: font.pixelSize
                            rightPadding: leftPadding
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            text: "Fit"
                        }
                    }
                }
                // Table header

                // Table row
                delegate: Rectangle {
                    width: parent.width
                    height: cellHeight
                    color: index % 2 ? alternateRowBackgroundColor : rowBackgroundColor

                    Row {
                        width: parent.width
                        height: parent.height
                        spacing: 10

                        Text {
                            id: nameColumn
                            width: cellWidth
                            height: cellHeight
                            leftPadding: font.pixelSize
                            rightPadding: leftPadding
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                            text: nameRole
                        }

                        TextInput {
                            id: valueColumn
                            width: cellWidth
                            height: cellHeight
                            leftPadding: font.pixelSize
                            rightPadding: leftPadding
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignVCenter
                            validator : RegExpValidator { regExp : /[0-9]*\.[0-9]+/ }
                            text: valueRole
                            onEditingFinished: valueRole = text
                        }

                        Text {
                            id: errorColumn
                            width: 2*cellWidth
                            height: cellHeight
                            leftPadding: font.pixelSize
                            rightPadding: leftPadding
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignVCenter
                            text: errorRole
                        }

                        CheckBox {
                            id: refineColumn
                            width: cellHeight
                            height: cellHeight
                            checked: refineRole
                            onToggled: refineRole = checked
                        }
                    }
                }
                // Table row

                ScrollBar.horizontal: ScrollBar { policy: ScrollBar.AlwaysOff }
                ScrollBar.vertical: ScrollBar { z: 0; policy: ScrollBar.AsNeeded }
            }
        }
        // Fitables table as ListView
        //////////////////////////////////////////

        //////////////////////////////////////////
        // Chart
        Rectangle {
            width: parent.width
            height: cellHeight * 10
            border.width: borderWidth
            border.color: headerBorderColor

            ChartView {
                id: chartView
                width: parent.width
                height: parent.height
                anchors.margins: -12
                antialiasing: true
                legend.visible: true
                legend.alignment: Qt.AlignBottom

                ScatterSeries {
                    name: mapper1.model.header(mapper1.yColumn) // header is not updated
                    //useOpenGL: true
                    VXYModelMapper{
                        id: mapper1
                        model: proxy.table
                        xColumn: 0
                        yColumn: 1
                    }
                }

                LineSeries {
                    name: mapper2.model.header(mapper2.yColumn) // header is not updated
                    //useOpenGL: true
                    VXYModelMapper{
                        id: mapper2
                        model: proxy.table
                        xColumn: 0
                        yColumn: 2
                    }
                }
            }
        }
        // Chart
        //////////////////////////////////////////

        //////////////////////////////////////////
        // Simulated data table as TableView
        Rectangle {
            width: childrenRect.width + borderWidth * 2
            height: childrenRect.height + borderWidth * 2
            border.width: borderWidth
            border.color: headerBorderColor

            // Table header as separate independent TableView, but using the same model as simulatedDataTable
            TableView {
                id: columnsHeader
                x: borderWidth
                y: borderWidth
                width: simulatedDataTable.width
                height: cellHeight

                model: proxy.table

                delegate: Rectangle {
                    implicitWidth: cellWidth
                    implicitHeight: cellHeight
                    color: headerBackgroundColor

                    Text {
                        anchors.fill: parent
                        leftPadding: font.pixelSize
                        rightPadding: leftPadding
                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter
                        text: headerRole
                    }
                }
            }

            // Table cells
            TableView {
                id: simulatedDataTable
                x: columnsHeader.x
                anchors.top: columnsHeader.bottom
                width: cellWidth * columns
                height: cellHeight * 5
                clip: true
                boundsBehavior: Flickable.StopAtBounds

                model: proxy.table

                delegate: Rectangle {
                    implicitWidth: cellWidth
                    implicitHeight: cellHeight
                    color: row % 2 ? alternateRowBackgroundColor : rowBackgroundColor

                    TextInput {
                        anchors.fill: parent
                        leftPadding: font.pixelSize
                        rightPadding: leftPadding
                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter
                        validator : RegExpValidator { regExp : /[0-9]*\.[0-9]+/ }
                        text: dataRole
                        onEditingFinished: dataRole = text
                    }
                }

                ScrollBar.horizontal: ScrollBar { policy: ScrollBar.AlwaysOff }
                ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded; minimumSize: 0.2 }
            }
        }
        // Simulated data table as TableView
        //////////////////////////////////////////

        //////////////////////////////////////////
        // Button
        Button {
            text: 'Random change of both ListView, ChartView and TableView'
            onClicked: {
                proxy.randomChange()
            }
        }
        // Button
        //////////////////////////////////////////
    }

    // Profiling
    Component.onCompleted: print("Duration:", Date.now() - startTime, "ms")
}


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
        // Chart
        Rectangle {
            width: parent.width
            height: cellHeight * 10
            border.width: borderWidth
            border.color: headerBorderColor

            ChartView {
                width: parent.width
                height: parent.height
                anchors.margins: -12
                antialiasing: true
                //legend.visible: false
                legend.visible: true
                legend.alignment: Qt.AlignBottom
                //animationOptions: ChartView.AllAnimations

                LineSeries {
                    name: mapper1.model.headerData(mapper1.yColumn, Qt.Horizontal)
                    //useOpenGL: true
                    VXYModelMapper{
                        id: mapper1
                        model: experimentalDataModel
                        xColumn: 0
                        yColumn: 1
                    }
                }

                ScatterSeries {
                    name: experimentalDataModel.headerData(mapper2.yColumn, Qt.Horizontal)
                    //useOpenGL: true
                    VXYModelMapper{
                        id: mapper2
                        model: experimentalDataModel
                        xColumn: 0
                        yColumn: 2
                    }
                }
            }
        }
        // Chart
        //////////////////////////////////////////

        //////////////////////////////////////////
        // Simulated data table
        Rectangle {
            width: childrenRect.width + borderWidth * 2
            height: childrenRect.height + borderWidth * 2
            border.width: borderWidth
            border.color: headerBorderColor

            // Horizontal Header
            Rectangle {
                id: columnsHeader
                x: borderWidth
                y: borderWidth
                width: simulatedDataTable.width
                height: cellHeight
                color: headerBackgroundColor

                Row {
                    anchors.fill: parent

                    Repeater {
                        anchors.fill: parent
                        model: simulatedDataTable.columns

                        TextInput {
                            width: cellWidth
                            height: cellHeight
                            leftPadding: font.pixelSize
                            rightPadding: leftPadding
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignVCenter
                            color: headerTextColor
                            //text: simulatedDataTable2.model.headerData(modelData, Qt.Horizontal)
                            text: experimentalDataModel.headerData(modelData, Qt.Horizontal)
                            onEditingFinished: experimentalDataModel.setHeaderData(modelData, Qt.Horizontal, text, Qt.EditRole)
                        }
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

                model: experimentalDataModel

                delegate: Rectangle {
                    implicitWidth: cellWidth
                    implicitHeight: cellHeight
                    color: row % 2 ? alternateRowBackgroundColor : rowBackgroundColor
                    //color: column === 0 ? headerBackgroundColor : rowBackgroundColor

                    TextInput {
                        anchors.fill: parent
                        leftPadding: font.pixelSize
                        rightPadding: leftPadding
                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter
                        validator : RegExpValidator { regExp : /[0-9]*\.[0-9]+/ }
                        text: display
                        onEditingFinished: edit = text
                    }
                }

                ScrollBar.horizontal: ScrollBar { policy: ScrollBar.AlwaysOff }
                ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded; minimumSize: 0.2 }
            }
        }
        // Simulated data table
        //////////////////////////////////////////

        //////////////////////////////////////////
        // Simulated data table
        Rectangle {
            width: childrenRect.width + borderWidth * 2
            height: childrenRect.height + borderWidth * 2
            border.width: borderWidth
            border.color: headerBorderColor

            // Horizontal Header
            Rectangle {
                id: columnsHeader2
                x: borderWidth
                y: borderWidth
                width: simulatedDataTable2.width
                height: cellHeight
                color: headerBackgroundColor

                Row {
                    anchors.fill: parent

                    Repeater {
                        anchors.fill: parent
                        model: simulatedDataTable2.columns

                        TextEdit {
                            width: cellWidth
                            height: cellHeight
                            leftPadding: font.pixelSize
                            rightPadding: leftPadding
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignVCenter
                            color: headerTextColor
                            //text: simulatedDataTable2.model.headerData(modelData, Qt.Horizontal)
                            text: experimentalDataModel.headerData(modelData, Qt.Horizontal)
                            onEditingFinished: experimentalDataModel.setHeaderData(modelData, Qt.Horizontal, text, Qt.EditRole)
                        }
                    }
                }
            }

            // Table cells
            TableView {
                id: simulatedDataTable2
                x: columnsHeader2.x
                anchors.top: columnsHeader2.bottom
                width: cellWidth * columns
                height: cellHeight * 5
                clip: true
                boundsBehavior: Flickable.StopAtBounds

                model: experimentalDataModel

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
                        text: display
                        onEditingFinished: edit = text
                    }
                }

                ScrollBar.horizontal: ScrollBar { policy: ScrollBar.AlwaysOff }
                ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded; minimumSize: 0.2 }
            }
        }
        // Simulated data table
        //////////////////////////////////////////

        //////////////////////////////////////////
        // Button
        Button {
            Layout.fillWidth: true
            text: 'Set data randomly' //+ experimentalDataModel.headerData(0, Qt.Horizontal)
            onClicked: experimentalDataModel.setModelRandomly()
        }
        // Button
        //////////////////////////////////////////
    }

    // Profiling
    Component.onCompleted: print("Duration:", Date.now() - startTime, "ms")
}


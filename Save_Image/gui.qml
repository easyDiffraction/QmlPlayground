import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtCharts 2.13

ApplicationWindow {
    id: window
    visible: true
    width: column.width
    height: column.height

    Column {
        id: column
        width: childrenRect.width
        height: childrenRect.height
        anchors.margins: 10
        spacing: 10

        ChartView {
            id: chartView
            width: 500
            height: 400
            antialiasing: true

            LineSeries {
                name: "LineSeries"
                XYPoint { x: 0; y: 0 }
                XYPoint { x: 1.1; y: 2.1 }
                XYPoint { x: 1.9; y: 3.3 }
                XYPoint { x: 2.1; y: 2.1 }
                XYPoint { x: 2.9; y: 4.9 }
                XYPoint { x: 3.4; y: 3.0 }
                XYPoint { x: 4.1; y: 3.3 }
            }
        }

        Button {
            width: chartView.width
            text: 'Save image'
            onClicked: {
                chartView.grabToImage(function(result) {
                    result.saveToFile(imageFilePath)
                })
            }
        }

    }

}


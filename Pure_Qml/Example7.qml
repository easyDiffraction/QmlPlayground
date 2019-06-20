import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtCharts 2.3

Window {
    visible: true
    width: 600
    height: 700
    title: "Hello World"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 30
        spacing: 10

        ChartView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            antialiasing: true

            PieSeries {
                PieSlice { label: "eaten"; value: 100 - slider.value }
                PieSlice { label: "not yet eaten"; value: slider.value }
            }
        }

        Slider {
            id: slider
            Layout.fillWidth: true

            from: 0
            value: 5.1
            to: 100
        }
    }
}

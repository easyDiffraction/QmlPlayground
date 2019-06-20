import QtQuick 2.12
import QtQuick.Window 2.12
import QtCharts 2.3

Window {
    visible: true
    width: 400
    height: 500
    color: "#fafafa"

    ChartView {
        anchors.fill: parent
        antialiasing: true

        PieSeries {
            PieSlice { label: "eaten"; value: 94.9 }
            PieSlice { label: "not yet eaten"; value: 5.1 }
        }
    }
}

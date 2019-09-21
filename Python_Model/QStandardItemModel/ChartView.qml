import QtQuick 2.12
import QtQuick.Controls 2.12
import QtCharts 2.13

ChartView {
    property int borderWidth: 1
    property string headerBorderColor: '#dedede'

    height: 210
    width: parent.width
    antialiasing: true

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.color: headerBorderColor
        border.width: borderWidth
    }
}


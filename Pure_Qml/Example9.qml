import QtQuick 2.12
import QtQuick.Window 2.12

import "Charts" as CustomCharts

Window {
    visible: true
    color: "#fafafa"
    width: 400
    height: 400

    CustomCharts.SimpleChart {
        anchors.fill: parent
    }
}

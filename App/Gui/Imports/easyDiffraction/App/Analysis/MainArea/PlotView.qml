import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtCharts 2.12

import easyInterface.App 1.0 as InterfaceApp

InterfaceApp.PlotView {

    ValueAxis {
        id: axisX
        titleText: "X axis"
    }

    ValueAxis {
        id: axisY
        titleText: "Y axis"
    }

    ScatterSeries {
        axisX: axisX
        axisY: axisY

        color: parent.Material.accentColor

        XYPoint {
            x: 0
            y: 0
        }
        XYPoint {
            x: 1.1
            y: 2.1
        }
        XYPoint {
            x: 1.9
            y: 3.3
        }
        XYPoint {
            x: 2.1
            y: 2.1
        }
        XYPoint {
            x: 2.9
            y: 4.9
        }
        XYPoint {
            x: 3.4
            y: 3.0
        }
        XYPoint {
            x: 4.1
            y: 3.3
        }
    }
}

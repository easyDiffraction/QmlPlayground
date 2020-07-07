import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtCharts 2.12
import QtQuick.XmlListModel 2.12

import easyInterface.App 1.0 as InterfaceApp
import easyInterface.Globals 1.0 as InterfaceGlobals
import easyInterface.Animations 1.0 as InterfaceAnimations

import easyDiffraction.Globals 1.0 as DiffractionGlobals

InterfaceApp.PlotView {
    id: plotView

    InterfaceApp.PlotAxis {
        id: axisX
        titleText: "X axis"
        min: DiffractionGlobals.Experiment.chartLimits.x.min
        max: DiffractionGlobals.Experiment.chartLimits.x.max
    }

    InterfaceApp.PlotAxis {
        id: axisY
        titleText: "Y axis"
        min: DiffractionGlobals.Experiment.chartLimits.y.min
        max: DiffractionGlobals.Experiment.chartLimits.y.max
    }

    LineSeries {
        id: lineSeries

        axisX: axisX
        axisY: axisY

        color: parent.Material.accentColor
        onColorChanged: width = 2

        // Default data points
        XYPoint {
            x: 0
            y: 0
        }
        XYPoint {
            x: 0.5
            y: 1
        }
        XYPoint {
            x: 1
            y: 0.1
        }

        // Save chart
        onPointsReplaced: {
            saveImageTimer.restart()
        }

        // Pass lineSeries as reference to python
        Component.onCompleted: {
            DiffractionGlobals.Experiment.bindChartSeries(lineSeries)
        }
    }

    Timer {
        id: saveImageTimer

        interval: 1
        onTriggered: {
            plotView.grabToImage(function (result) {
                const path = toLocalFile(DiffractionGlobals.Images.refinement)
                const success = result.saveToFile(path)
                print("path", path)
                print("success", success)
            })
        }
    }

    // https://stackoverflow.com/questions/24927850/get-the-path-from-a-qml-url
    // https://bugreports.qt.io/browse/QTBUG-54988
    function toLocalFile(path) {
        if (typeof path !== 'string')
            return path
        const re = new RegExp("^(file:\/{" + slashCount() + "})")
        const out = path.replace(re, "")
        return out
    }

    function slashCount() {
        switch (Qt.platform.os) {
        case "windows":
            return 3
        case "osx" || "unix" || "linux":
            return 2
        default:
            return 0
        }
    }
}

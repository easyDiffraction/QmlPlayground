import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtCharts 2.12

import easyInterface.Globals 1.0 as InterfaceGlobals

ChartView {
    id: chart

    margins.top: 0
    margins.bottom: 0
    margins.left: 0
    margins.right: 0

    antialiasing: true
    legend.visible: false

    theme: InterfaceGlobals.Color.chartTheme

    backgroundColor: InterfaceGlobals.Color.chartBackground
    backgroundRoundness: 0

    titleColor: InterfaceGlobals.Color.chartForeground
    titleFont.family: InterfaceGlobals.Font.regular
    titleFont.bold: true

    animationOptions: ChartView.SeriesAnimations

    // Zoom rectangle
    Rectangle{
        id: recZoom

        property int xScaleZoom: 0
        property int yScaleZoom: 0

        visible: false
        transform: Scale { origin.x: 0; origin.y: 0; xScale: recZoom.xScaleZoom; yScale: recZoom.yScaleZoom}

        border.color: Material.accentColor
        border.width: 1

        opacity: 0.5
        color: "transparent"
        Rectangle {
            anchors.fill: parent
            opacity: 0.3
            color: Material.accentColor
        }
    }

    // Left mouse button events
    MouseArea {
        anchors.fill: chart
        acceptedButtons: Qt.LeftButton

        onPressed: {
            recZoom.x = mouseX
            recZoom.y = mouseY
            recZoom.visible = true
        }

        onMouseXChanged: {
            if (mouseX > recZoom.x) {
                recZoom.xScaleZoom = 1
                recZoom.width = Math.min(mouseX, chart.width) - recZoom.x
            } else {
                recZoom.xScaleZoom = -1
                recZoom.width = recZoom.x - Math.max(mouseX, 0)
            }
        }

        onMouseYChanged: {
            if (mouseY > recZoom.y) {
                recZoom.yScaleZoom = 1
                recZoom.height = Math.min(mouseY, chart.height) - recZoom.y
            } else {
                recZoom.yScaleZoom = -1
                recZoom.height = recZoom.y - Math.max(mouseY, 0)
            }
        }

        onReleased: {
            const x = Math.min(recZoom.x, mouseX) - chart.anchors.leftMargin
            const y = Math.min(recZoom.y, mouseY) - chart.anchors.topMargin

            const width = recZoom.width
            const height = recZoom.height

            chart.zoomIn(Qt.rect(x, y, width, height))
            recZoom.visible = false
        }
    }

    // Right mouse button events
    MouseArea {
        anchors.fill: chart
        acceptedButtons: Qt.RightButton

        onClicked: {
            chart.zoomReset()
        }
    }
}





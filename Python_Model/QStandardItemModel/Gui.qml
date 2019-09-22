import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtCharts 2.13

import "." as Custom

ApplicationWindow {
    id: window
    visible: true
    width: 750
    height: 1000

    property var startTime: Date.now()
    property var endTime: Date.now()

    ScrollView {
        height: parent.height
        contentWidth: parent.width - padding * 2
        padding: 10

        Column {
            width: parent.width
            height: parent.height
            spacing: 10

            // project (Text)

            Text { text: "measuredData (TableView)"; color: "red" }

            ScrollView {
                width: parent.width
                height: 150

                TextArea {
                    wrapMode: Text.Wrap
                    text: "project: " + JSON.stringify(proxy.project)
                    color: "blue"
                }

            }

            // spacer

            Item { height: 15; width: 1 }

            // measuredData and calculated (TableView)

            Text { text: "measuredData and calculatedData (TableView)"; color: "red" }

            Row {
                width: parent.width
                height: childrenRect.height
                spacing: 10

                Custom.TableView {
                    headerModel: proxy.measuredDataHeader
                    dataModel: proxy.measuredData
                }

                Custom.TableView {
                    editable: true
                    headerModel: proxy.calculatedDataHeader
                    dataModel: proxy.calculatedData
                }
            }

            // spacer

            Item { height: 15; width: 1 }

            // measuredData (ChartView)

            Text { text: "measuredData (ChartView)"; color: "red" }

            Custom.ChartView {

                LineSeries {
                    name: "Iobs"

                    VXYModelMapper{
                        model: proxy.measuredData
                        xColumn: 0
                        yColumn: 1
                    }
                }

                LineSeries {
                    name: "Icalc"

                    VXYModelMapper{
                        model: proxy.calculatedData
                        xColumn: 0
                        yColumn: 1
                    }
                }
            }

            // spacer

            Item { height: 15; width: 1 }

            // fitables (ListView)

            Text { text: "fitables (ListView)"; color: "red" }

            Row {
                width: parent.width
                height: childrenRect.height
                spacing: 10

                Custom.FitablesView {
                    width: (parent.width - parent.spacing) / 2
                    model: proxy.fitables
                }

                Custom.FitablesView {
                    width: (parent.width - parent.spacing) / 2
                    model: proxy.fitables
                }
            }

            // Button

            Button {
                text: 'Random change of calculated data'
                onClicked: {
                    startTime = Date.now()
                    proxy.updateCalculatedDataModelRandomly()
                    endTime = Date.now()
                    print("Duration:", endTime - startTime, "ms")
                }
            }

        }

    }

    // Profiling
    Component.onCompleted: {
        endTime = Date.now()
        print("Duration:", endTime - startTime, "ms")
    }
}


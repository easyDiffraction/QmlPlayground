import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtCharts 2.13

import "Qml" as Custom

ApplicationWindow {
    id: window
    visible: true
    width: 1200
    height: 1100

    property var startTime: Date.now()
    property var endTime: Date.now()

    property string currentPhaseId: Object.keys(proxy.project.phases)[0]

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
                height: 125

                TextArea {
                    wrapMode: Text.Wrap
                    ///text: "project: " + JSON.stringify(proxy.project,null,2) ### SLOW for large dicts !!!
                    text: "length_a: " + JSON.stringify(proxy.project.phases[currentPhaseId].cell.length_a, null, 2)
                    color: "blue"
                }

            }

            // spacer

            Item { height: 5; width: 1 }

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
                    headerModel: proxy.calculatedDataHeader
                    dataModel: proxy.calculatedData
                }
            }

            // spacer

            Item { height: 5; width: 1 }

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

            Item { height: 5; width: 1 }

            // fitables (ListView)

            Text { text: "fitables (ListView)"; color: "red" }

            Row {
                width: parent.width
                height: childrenRect.height
                spacing: 10

                Custom.FitablesView {
                    //id: fitablesTable
                    width: (parent.width - parent.spacing) / 2
                    model: proxy.fitables
                }

                //Custom.FitablesView {
                //    width: (parent.width - parent.spacing) / 2
                //    model: proxy.fitables
                //}
            }

            // spacer

            Item { height: 5; width: 1 }

            // selector (ListView)

            Text { text: "selector (ListView)" + Object.keys(proxy.project.phases); color: "red" }

            ListView {
                id: phasesList
                width: parent.width
                height: childrenRect.height
                focus: true
                highlight: Rectangle { color: "orange"; opacity: 0.3 }
                model: Object.keys(proxy.project.phases)
                delegate: Text {
                    width: parent.width
                    text: modelData
                    MouseArea {
                        anchors.fill: parent
                        propagateComposedEvents: true
                        acceptedButtons: Qt.LeftButton
                        onPressed: {
                            currentPhaseId = text
                            phasesList.currentIndex = index
                            mouse.accepted = false
                        }
                    }
                }
            }
            ListView {
                width: parent.width
                height: childrenRect.height
                model: 1
                delegate: Column {
                    Row {
                        Text { height: 20; width: 200; text: proxy.project.phases[currentPhaseId].cell.length_a.header }
                        Text { height: 20; width: 200; text: proxy.project.phases[currentPhaseId].cell.length_b.header }
                        Text { height: 20; width: 200; text: proxy.project.phases[currentPhaseId].cell.length_c.header }
                    }
                    Row {
                        Text { height: 20; width: 200; text: proxy.project.phases[currentPhaseId].cell.length_a.value }
                        Text { height: 20; width: 200; text: proxy.project.phases[currentPhaseId].cell.length_b.value }
                        Text { height: 20; width: 200; text: proxy.project.phases[currentPhaseId].cell.length_c.value }
                    }
                }
            }

            // spacer

            Item { height: 5; width: 1 }

            // Button

            Button {
                text: 'Start refinement'
                onClicked: {
                    startTime = Date.now()
                    const res = proxy.refine()
                    endTime = Date.now()
                    print("Duration:", endTime - startTime, "ms")
                    infoLabel.text = `${res.refinement_message}`
                    infoLabel.text += res.num_refined_parameters ? `\nNumber of refined parameters: ${res.num_refined_parameters}` : ""
                    infoLabel.text += res.nfev ? `\nnfev: ${res.nfev}` : ""
                    infoLabel.text += res.nit ? `\nnfev: ${res.nit}` : ""
                    infoLabel.text += res.njev ? `\nnfev: ${res.njev}` : ""
                    infoLabel.text += res.started_chi_sq ? `\nStarted goodnes-of-fit (\u03c7\u00b2): ${(res.started_chi_sq).toFixed(3)}` : ""
                    infoLabel.text += res.final_chi_sq ? `\nFinal goodnes-of-fit (\u03c7\u00b2): ${(res.final_chi_sq).toFixed(3)}` : ""
                    infoLabel.text += res.refinement_time ? `\nRefinement time in seconds: ${(res.refinement_time).toFixed(2)}` : ""
                    info.open()
                }
            }

        }

    }

    // Info dialog
    Dialog {
        id: info
        anchors.centerIn: parent
        modal: true

        Label {
            id: infoLabel
            anchors.centerIn: parent
        }
    }

    // Profiling
    Component.onCompleted: {
        endTime = Date.now()
        print("Duration:", endTime - startTime, "ms")
    }
}


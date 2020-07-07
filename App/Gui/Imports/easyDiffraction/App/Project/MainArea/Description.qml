import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtCharts 2.12

import easyInterface.Globals 1.0 as InterfaceGlobals
import easyInterface.Animations 1.0 as InterfaceAnimations

import easyDiffraction.Globals 1.0 as DiffractionGlobals
import easyDiffraction.App.Sample.MainArea 1.0 as DiffractionSampleMainArea
import easyDiffraction.App.Experiment.MainArea 1.0 as DiffractionExperimentMainArea

Item {
    id: container

    property int commonMargin: 20

    height: parent.height
    width: parent.width

    // State 1: No Project Created/Opened
    Column {
        anchors.fill: container

        opacity: InterfaceGlobals.Variable.projectOpened ? 0 : 1
        Behavior on opacity {
            PropertyAnimation {
                duration: InterfaceGlobals.Color.translationChangeTime
                easing.type: Easing.OutCirc
            }
        }

        Label {
            enabled: false

            height: parent.height
            width: parent.width

            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            font.pointSize: InterfaceGlobals.Font.pointSize * 3
            text: "No Project Created/Opened"
        }
    }

    // State 2: Project Created/Opened
    Column {
        anchors.verticalCenter: container.verticalCenter
        anchors.left: container.left
        anchors.leftMargin: commonMargin
        spacing: commonMargin

        opacity: InterfaceGlobals.Variable.projectOpened ? 1 : 0
        Behavior on opacity {
            PropertyAnimation {
                duration: InterfaceGlobals.Color.translationChangeTime
                easing.type: Easing.InCirc
            }
        }

        // Project name
        Label {
            lineHeight: 0.85
            font.pointSize: InterfaceGlobals.Font.pointSize * 3
            text: DiffractionGlobals.Project.name
        }

        // Keywords, Phases, Experiments, Instrument, Modified
        Grid {
            columns: 2
            rowSpacing: 0
            columnSpacing: commonMargin

            Label {
                enabled: false
                text: "Keywords:"
            }
            Label {
                text: DiffractionGlobals.Project.keywords
            }

            Label {
                enabled: false
                text: "Phases:"
            }
            Label {
                text: DiffractionGlobals.Project.phases
            }

            Label {
                enabled: false
                text: "Experiments:"
            }
            Label {
                text: DiffractionGlobals.Project.experiments
            }

            Label {
                enabled: false
                text: "Instrument:"
            }
            Label {
                text: DiffractionGlobals.Project.instrument
            }

            Label {
                enabled: false
                text: "Modified:"
            }
            Label {
                text: DiffractionGlobals.Project.modified
            }
        }

        // Images
        Row {
            spacing: commonMargin

            Rectangle {
                height: (container.width - 3 * commonMargin) / 2
                width: height
                color: InterfaceGlobals.Color.appBarBackground
                border.color: InterfaceGlobals.Color.appBorder


                /*
                Loader {
                    id: myLoader
                    source: DiffractionSampleMainArea.StructureView {} //"StructureView.qml"
                }*/
                DiffractionSampleMainArea.StructureView {
                    anchors.fill: parent
                    anchors.margins: 2
                    windowBackgroundColor: parent.color
                }
            }

            Rectangle {
                height: (container.width - 3 * commonMargin) / 2
                width: height
                color: InterfaceGlobals.Color.appBarBackground
                border.color: InterfaceGlobals.Color.appBorder

                //DiffractionExperimentMainArea.PlotView {
                //anchors.fill: parent
                //animationOptions: ChartView.NoAnimation
                //}
            }
        }
    }
}

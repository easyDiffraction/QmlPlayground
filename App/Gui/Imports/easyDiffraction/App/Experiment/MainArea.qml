import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtCharts 2.12

import easyInterface.App 1.0 as InterfaceApp

import easyDiffraction.App.Experiment.MainArea 1.0 as DiffractionMainArea

InterfaceApp.MainAreaContainer {

    // Tabs
    InterfaceApp.MainAreaTabs {
        id: tabs

        InterfaceApp.TabButton {
            text: qsTr("Plot View")
        }
        InterfaceApp.TabButton {
            text: qsTr("Table View")
        }
        InterfaceApp.TabButton {
            text: qsTr("Text View")
        }
    }

    // Content
    InterfaceApp.MainAreaContent {
        id: content

        anchors.top: tabs.bottom
        currentIndex: tabs.currentIndex

        DiffractionMainArea.PlotView {}
        DiffractionMainArea.TableView {}
        DiffractionMainArea.TableView {}
        //DiffractionMainArea.TextView {}
    }
}

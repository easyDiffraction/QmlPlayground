import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtCharts 2.12

import easyInterface.App 1.0 as InterfaceApp

import easyDiffraction.App.Summary.MainArea 1.0 as DiffractionMainArea

InterfaceApp.MainAreaContainer {

    // Tabs
    InterfaceApp.MainAreaTabs {
        id: tabs

        InterfaceApp.TabButton {
            text: qsTr("Report")
        }
    }

    // Content
    InterfaceApp.MainAreaContent {
        id: content

        anchors.top: tabs.bottom
        currentIndex: tabs.currentIndex

        DiffractionMainArea.Report {}
    }
}

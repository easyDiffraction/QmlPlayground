import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import easyInterface.App 1.0 as InterfaceApp
import easyInterface.Globals 1.0 as InterfaceGlobals

import easyDiffraction.App 1.0 as DiffractionApp
import easyDiffraction.App.Home 1.0 as DiffractionHome
import easyDiffraction.App.Project 1.0 as DiffractionProject
import easyDiffraction.App.Sample 1.0 as DiffractionSample
import easyDiffraction.App.Experiment 1.0 as DiffractionExperiment
import easyDiffraction.App.Analysis 1.0 as DiffractionAnalysis
import easyDiffraction.App.Summary 1.0 as DiffractionSummary

InterfaceApp.ApplicationWindow {

    // Central group of application bar tabs (workflow tabs)
    appBarTabs: InterfaceApp.ApplicationBarTabs {
        id: centralTabs

        currentIndex: InterfaceGlobals.Variable.appBarCurrentIndex
        onCurrentIndexChanged: InterfaceGlobals.Variable.appBarCurrentIndex = currentIndex

        InterfaceApp.TabButton {
            icon.source: InterfaceGlobals.Icon.home
            text: qsTr("Home")
            ToolTip.text: qsTr("Home page")
        }

        InterfaceApp.TabButton {
            icon.source: InterfaceGlobals.Icon.project
            text: qsTr("Project")
            ToolTip.text: qsTr("Project description page")
        }

        InterfaceApp.TabButton {
            icon.source: InterfaceGlobals.Icon.sample
            text: qsTr("Sample")
            ToolTip.text: qsTr("Sample model description page")
        }

        InterfaceApp.TabButton {
            icon.source: InterfaceGlobals.Icon.experiment
            text: qsTr("Experiment")
            ToolTip.text: qsTr("Experimental settings and data page")
        }

        InterfaceApp.TabButton {
            icon.source: InterfaceGlobals.Icon.analysis
            text: qsTr("Analysis")
            ToolTip.text: qsTr("Simulation and fitting page")
        }

        InterfaceApp.TabButton {
            icon.source: InterfaceGlobals.Icon.summary
            text: qsTr("Summary")
            ToolTip.text: qsTr("Summary of the work done")
        }
    }

    // Application content: Main Content + Sidebar
    contentArea: InterfaceApp.PagesView {
        currentIndex: centralTabs.currentIndex

        InterfaceApp.Page {
            mainContent: DiffractionHome.MainArea {}
        }

        InterfaceApp.Page {
            mainContent: DiffractionProject.MainArea {}
            sideBar: DiffractionProject.SideBar {}
        }

        InterfaceApp.Page {
            mainContent: DiffractionSample.MainArea {}
            sideBar: DiffractionSample.SideBar {}
        }

        InterfaceApp.Page {
            mainContent: DiffractionExperiment.MainArea {}
            sideBar: DiffractionExperiment.SideBar {}
        }

        InterfaceApp.Page {
            mainContent: DiffractionAnalysis.MainArea {}
            sideBar: DiffractionAnalysis.SideBar {}
        }

        InterfaceApp.Page {
            mainContent: DiffractionSummary.MainArea {}
            sideBar: DiffractionSummary.SideBar {}
        }
    }

    // Status bar
    statusBar: DiffractionApp.StatusBar {}
}

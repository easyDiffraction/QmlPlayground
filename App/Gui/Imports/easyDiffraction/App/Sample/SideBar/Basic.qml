import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import easyInterface.App 1.0 as InterfaceApp
import easyInterface.Globals 1.0 as InterfaceGlobals

Column {
    width: parent.width

    // GROUP
    InterfaceApp.GroupBox {
        title: "Structural phases"
        collapsible: false

        InterfaceApp.GroupColumn {

            InterfaceApp.GroupRow {

                InterfaceApp.GroupButton {
                    enabled: false
                    text: qsTr("Add new phase manually")
                    ToolTip.text: qsTr("???")
                    icon.source: InterfaceGlobals.Icon.createProject
                }

                InterfaceApp.GroupButton {
                    enabled: false
                    text: qsTr("Remove all phases")
                    ToolTip.text: qsTr("???")
                    icon.source: InterfaceGlobals.Icon.openProject
                }
            }

            InterfaceApp.GroupRow {

                InterfaceApp.GroupButton {
                    text: qsTr("Import new phase from CIF")
                    ToolTip.text: qsTr("???")
                    icon.source: InterfaceGlobals.Icon.cloneProject
                }

                InterfaceApp.GroupButton {
                    enabled: false
                    text: qsTr("Export selected phase to CIF")
                    ToolTip.text: qsTr("???")
                    icon.source: InterfaceGlobals.Icon.saveProject
                }
            }
        }
    }

    // GROUP
    InterfaceApp.GroupBox {
        title: "Symmetry and cell parameters"
    }

    // GROUP
    InterfaceApp.GroupBox {
        title: "Atoms, atomic coordinates and occupations"
    }

    // GROUP
    InterfaceApp.GroupBox {
        title: "Atomic displacement parameters"
    }

    // GROUP
    InterfaceApp.GroupBox {
        title: "Magnetic susceptibility parameters"
    }
}

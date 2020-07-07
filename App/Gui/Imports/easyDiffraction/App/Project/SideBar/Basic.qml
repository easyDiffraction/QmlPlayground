import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import easyInterface.App 1.0 as InterfaceApp
import easyInterface.Globals 1.0 as InterfaceGlobals

Column {
    width: parent.width

    InterfaceApp.GroupBox {
        title: "Get Started"
        collapsible: false

        InterfaceApp.GroupColumn {

            InterfaceApp.GroupRow {

                InterfaceApp.GroupButton {
                    text: qsTr("Create a new project")
                    ToolTip.text: qsTr("???")
                    icon.source: InterfaceGlobals.Icon.createProject
                }

                InterfaceApp.GroupButton {
                    text: qsTr("Open an existing project")
                    ToolTip.text: qsTr("???")
                    icon.source: InterfaceGlobals.Icon.openProject
                    onClicked: InterfaceGlobals.Variable.projectOpened = true
                }
            }

            InterfaceApp.GroupRow {

                InterfaceApp.GroupButton {
                    enabled: false
                    text: qsTr("Clone an existing project")
                    ToolTip.text: qsTr("???")
                    icon.source: InterfaceGlobals.Icon.cloneProject
                }

                InterfaceApp.GroupButton {
                    enabled: false
                    text: qsTr("Save project as...")
                    ToolTip.text: qsTr("???")
                    icon.source: InterfaceGlobals.Icon.saveProject
                }
            }
        }
    }
}

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import Qt.labs.platform 1.1

import easyInterface.App 1.0 as InterfaceApp
import easyInterface.Globals 1.0 as InterfaceGlobals

Column {
    width: parent.width

    // GROUP
    InterfaceApp.GroupBox {
        title: "Export"
        collapsible: false

        InterfaceApp.GroupColumn {

            Grid {

                //enabled: false
                width: parent.width
                columns: 3

                CheckBox {
                    width: parent.width / parent.columns
                    checked: true
                    text: qsTr("Project info")
                }
                CheckBox {
                    width: parent.width / parent.columns
                    checked: true
                    text: qsTr("Parameters table")
                }
                CheckBox {
                    width: parent.width / parent.columns
                    checked: true
                    text: qsTr("Fitting figure")
                }
                CheckBox {
                    checked: true
                    text: qsTr("Structure plot")
                }
                CheckBox {
                    checked: false
                    text: qsTr("Reliability factors")
                }
                CheckBox {
                    checked: false
                    text: qsTr("Constraints table")
                }
            }

            InterfaceApp.GroupRow {

                InterfaceApp.GroupButton {
                    width: parent.width
                    text: qsTr("Export as...")
                    ToolTip.text: qsTr("???")
                    icon.source: InterfaceGlobals.Icon.cloneProject
                    onClicked: saveDialog.open()
                }
            }
        }
    }

    // DIALOG
    FileDialog {
        id: saveDialog
        title: "Save Dialog"
        fileMode: FileDialog.SaveFile
        nameFilters: ["PDF files (*.pdf)", "HTML files (*.html)"]
    }
}

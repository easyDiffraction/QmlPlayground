import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import easyInterface.App 1.0 as InterfaceApp
import easyInterface.Globals 1.0 as InterfaceGlobals

import easyDiffraction.Globals 1.0 as DiffractionGlobals

Column {
    width: parent.width

    // GROUP
    InterfaceApp.GroupBox {
        title: "Appearance"

        InterfaceApp.GroupColumn {

            CheckBox {
                text: qsTr("Wrap text")
                checked: DiffractionGlobals.Variable.wrapSampleText
                onToggled: DiffractionGlobals.Variable.wrapSampleText = checked
            }
        }
    }
}

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Material.impl 2.12
import QtQuick.XmlListModel 2.12

import easyInterface.QtQuick 1.0 as InterfaceQtQuick
import easyInterface.Globals 1.0 as InterfaceGlobals

InterfaceQtQuick.Dialog {
    id: dialog

    title: qsTr("Application preferences")
    standardButtons: Dialog.Ok

    visible: InterfaceGlobals.Variable.showAppPreferencesDialog
    onClosed: InterfaceGlobals.Variable.showAppPreferencesDialog = false

    Column {
        padding: 20
        spacing: 20

        Column {
            Label {
                bottomPadding: 15
                text: qsTr("Appearance")
                font.bold: true
            }
            Row {
                RadioButton {
                    text: qsTr("Light theme")
                    checked: InterfaceGlobals.Color.theme == Material.Light
                    onClicked: InterfaceGlobals.Color.theme = Material.Light
                }
                RadioButton {
                    text: qsTr("Dark theme")
                    checked: InterfaceGlobals.Color.theme == Material.Dark
                    onClicked: InterfaceGlobals.Color.theme = Material.Dark
                }
            }


            /*
            CheckBox {
                text: qsTr("Show application bar")
                checked: InterfaceGlobals.Variable.showAppBar
                onToggled: InterfaceGlobals.Variable.showAppBar = checked
            }
            CheckBox {
                text: qsTr("Show status bar")
                checked: InterfaceGlobals.Variable.showAppStatusBar
                onToggled: InterfaceGlobals.Variable.showAppStatusBar = checked
            }
            */
        }

        Column {
            spacing: 0
            Label {
                bottomPadding: 15
                text: qsTr("Language")
                font.bold: true
            }
            ComboBox {
                model: XmlListModel {
                    xml: InterfaceGlobals.Translator.languagesAsXml
                    query: "/root/item/language"
                    XmlRole {
                        name: "name"
                        query: "name/string()"
                    }
                }
                onActivated: InterfaceGlobals.Translator.selectLanguage(currentIndex)
                Component.onCompleted: currentIndex = InterfaceGlobals.Translator.defaultLanguageIndex
            }
        }
    }
}

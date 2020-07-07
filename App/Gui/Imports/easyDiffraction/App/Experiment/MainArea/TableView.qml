import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.XmlListModel 2.12

import easyInterface.App 1.0 as InterfaceApp

import easyDiffraction.Globals 1.0 as DiffractionGlobals

//https://stackoverflow.com/questions/31966104/access-listview-currentindex-from-delegate

ListView {
    id: listView

    // Table model
    model: XmlListModel {
        xml: DiffractionGlobals.Experiment.xmlModel
        query: "/root/item"

        XmlRole { name: "x"; query: "x/string()" }
        XmlRole { name: "y"; query: "y/string()" }

        onStatusChanged: {
             if (status == XmlListModel.Ready) {
                 //print("READY")
             }
         }
    }

    // Table header
    header: Row {
        spacing: 0

        TextField {
            text: "2theta"
            horizontalAlignment: Text.AlignRight
            readOnly: true
            font.bold: true
        }
        TextField {
            text: "Intensity"
            horizontalAlignment: Text.AlignRight
            readOnly: true
            font.bold: true
        }
    }

    // Table row
    delegate: Row {
        id: row
        spacing: 0

        TextField {
            text: model.x
            horizontalAlignment: Text.AlignRight
        }
        TextField {
            property int rowIndex: index
            property string basePath: listView.model.query
            property string roleName: 'y'
            property string initialText: model[roleName]
            property string newText: text

            text: initialText
            horizontalAlignment: Text.AlignRight
            onEditingFinished: {
                if (newText === initialText)
                    return
                print(`DEBUG: onEditingFinished >>> ${basePath}/${roleName} in row ${rowIndex} is changed from ${initialText} to ${newText}`)
                DiffractionGlobals.Experiment.setData(basePath, roleName, rowIndex, initialText, newText)
            }
        }
    }
}

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ApplicationWindow {
    id: window
    visible: true
    width: 600
    height: 570

    property int rowHeight: 44
    property int cellSpacing: 1
    property int cellPadding: 5
    property int maxRowCountToDisplay: 4
    property string rowColor: 'whitesmoke'
    property string alternateRowColor: '#ddd'//'lightgray'
    property string headerBackgroundColor: 'coral'
    property string headerColor: 'steelblue'

    //////////////////////////////////////////
    //////////////////////////////////////////
    //////////////////////////////////////////

    ColumnLayout {
        anchors.fill: parent
        spacing: 20
        anchors.margins: 20

        //////////////////////////////////////////
        //////////////////////////////////////////

        Text { text: "Parameters (Analysis Tab)"; color: headerColor }

        ScrollView {
            Layout.fillWidth: true
            Layout.preferredHeight: rowHeight * maxRowCountToDisplay + cellSpacing * (maxRowCountToDisplay - 1)
            Layout.maximumHeight: rowHeight * maxRowCountToDisplay + cellSpacing * (maxRowCountToDisplay - 1)
            clip: true

            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            ScrollBar.vertical.policy: ScrollBar.AsNeeded

            ListView {
                //id: listView
                spacing: cellSpacing

                // Use python model
                model: pythonModel.fitables_list

                header: Rectangle {
                    width: parent.width
                    height: rowHeight
                    color: "red"

                    RowLayout {
                        width: parent.width
                        spacing: cellSpacing

                        //////////////////////////////////////////

                        // First column: Current row number
                        Rectangle {
                            color: headerBackgroundColor
                            Layout.fillHeight: true
                            Layout.preferredWidth: rowHeight
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                padding: cellPadding
                                text: "No."
                            }
                        }

                        //////////////////////////////////////////

                        // Next column: name
                        Rectangle {
                            color: headerBackgroundColor
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            Layout.preferredWidth: 2*rowHeight
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                padding: cellPadding
                                text: "Parameter"
                            }
                        }

                        //////////////////////////////////////////

                        // Next column: value
                        Rectangle {
                            color: headerBackgroundColor
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            Layout.preferredWidth: rowHeight
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                padding: cellPadding
                                text: "Value"
                            }
                        }

                        //////////////////////////////////////////

                        // Next column: error
                        Rectangle {
                            color: headerBackgroundColor
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            Layout.preferredWidth: rowHeight
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                padding: cellPadding
                                text: "Error"
                            }
                        }

                        //////////////////////////////////////////

                        // Next column: refine
                        Rectangle {
                            color: headerBackgroundColor
                            Layout.preferredHeight: rowHeight
                            Layout.preferredWidth: rowHeight
                        }

                        //////////////////////////////////////////

                    }








                }

                // Table row view
                delegate: Rectangle {
                    width: parent.width
                    height: rowHeight
                    color: "white"

                    RowLayout {
                        width: parent.width
                        spacing: cellSpacing

                        //////////////////////////////////////////

                        // First column: Current row number
                        Rectangle {
                            color: index % 2 ? rowColor : alternateRowColor
                            Layout.fillHeight: true
                            Layout.preferredWidth: rowHeight
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                padding: cellPadding
                                text: index + 1
                            }
                        }

                        //////////////////////////////////////////

                        // Next column: name
                        Rectangle {
                            color: index % 2 ? rowColor : alternateRowColor
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            Layout.preferredWidth: 2*rowHeight
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                padding: cellPadding
                                text: {
                                    const fitable = pythonModel.fitables_list[index]
                                    const datablock = fitable.datablock
                                    const group = fitable.group
                                    const subgroup = fitable.subgroup
                                    const name = fitable.name
                                    if (group && subgroup) {
                                        return `${datablock} ${group} ${subgroup} ${name}`
                                    } else {
                                        return `${datablock} ${name}`
                                    }
                                }
                            }
                        }

                        //////////////////////////////////////////

                        // Next column: value
                        Rectangle {
                            color: index % 2 ? rowColor : alternateRowColor
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            Layout.preferredWidth: rowHeight
                            TextEdit {
                                anchors.verticalCenter: parent.verticalCenter
                                padding: cellPadding
                                font.weight: pythonModel.fitables_list[index].refine ? Font.Bold : Font.Normal
                                text: pythonModel.fitables_list[index].value
                                onEditingFinished: {
                                    const fitable = pythonModel.fitables_list[index]
                                    const datablock = fitable.datablock
                                    const group = fitable.group
                                    const subgroup = fitable.subgroup
                                    const name = fitable.name
                                    let obj = pythonModel.data
                                    if (group && subgroup) {
                                        obj[datablock][group][subgroup][name].value = text
                                    } else {
                                        obj[datablock][name].value = text
                                    }
                                    pythonModel.data = obj
                                }
                            }
                        }

                        //////////////////////////////////////////

                        // Next column: error
                        Rectangle {
                            color: index % 2 ? rowColor : alternateRowColor
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            Layout.preferredWidth: rowHeight
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                padding: cellPadding
                                text: pythonModel.fitables_list[index].error
                            }
                        }

                        //////////////////////////////////////////

                        // Next column: refine
                        Rectangle {
                            color: index % 2 ? rowColor : alternateRowColor
                            Layout.preferredHeight: rowHeight
                            Layout.preferredWidth: rowHeight
                            CheckBox {
                                checked: pythonModel.fitables_list[index].refine
                                //onToggled: atomSiteModel.modify(index, model.label, model.x, model.y, model.z, checked)
                                onToggled: {
                                    const fitable = pythonModel.fitables_list[index]
                                    const datablock = fitable.datablock
                                    const group = fitable.group
                                    const subgroup = fitable.subgroup
                                    const name = fitable.name
                                    let obj = pythonModel.data
                                    if (group && subgroup) {
                                        obj[datablock][group][subgroup][name].refine = checked
                                    } else {
                                        obj[datablock][name].refine = checked
                                    }
                                    pythonModel.data = obj
                                }
                            }
                        }

                        //////////////////////////////////////////

                    }
                }
            }
        }

        //////////////////////////////////////////
        //////////////////////////////////////////

        Item { Layout.fillHeight: true }

        Text { text: "Cell (Sample Model Tab)"; color: headerColor }

        ScrollView {
            Layout.fillWidth: true
            Layout.preferredHeight: rowHeight * 2 + cellSpacing
            Layout.maximumHeight: rowHeight * 2 + cellSpacing
            clip: true

            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            ScrollBar.vertical.policy: ScrollBar.AsNeeded

            ListView {
                //id: listView
                spacing: cellSpacing

                // Use single row model
                model: 2

                // Table row view
                delegate: Rectangle {
                    width: parent.width
                    height: rowHeight
                    color: "white"

                    RowLayout {
                        width: parent.width
                        height: rowHeight
                        spacing: cellSpacing

                        //////////////////////////////////////////

                        // Next column: Cell length a
                        Rectangle {
                            color: index % 2 ? rowColor : alternateRowColor
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            TextEdit {
                                enabled: index
                                anchors.verticalCenter: parent.verticalCenter
                                padding: cellPadding
                                font.weight: pythonModel.cell_dict.cell_length_a.refine ? Font.Bold : Font.Normal
                                text: index == 0 ? pythonModel.cell_dict.cell_length_a.title : pythonModel.cell_dict.cell_length_a.value
                                onEditingFinished: {
                                    const datablock = pythonModel.cell_dict.datablock
                                    let obj = pythonModel.data
                                    obj[datablock].cell_length_a.value = text
                                    pythonModel.data = obj
                                }
                            }
                            MouseArea {
                                anchors.fill: parent
                                acceptedButtons: Qt.RightButton
                                onClicked: {
                                    contextMenuA.x = mouse.x
                                    contextMenuA.y = mouse.y
                                    contextMenuA.open()
                                }
                                Menu {
                                    id: contextMenuA
                                    MenuItem {
                                        CheckBox {
                                            checked: pythonModel.cell_dict.cell_length_a.refine
                                            text: qsTr("refine")
                                            onToggled: {
                                                const datablock = pythonModel.cell_dict.datablock
                                                let obj = pythonModel.data
                                                obj[datablock].cell_length_a.refine = checked
                                                pythonModel.data = obj
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        //////////////////////////////////////////

                        // Next column: Cell length b
                        Rectangle {
                            color: index % 2 ? rowColor : alternateRowColor
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            TextEdit {
                                enabled: index
                                anchors.verticalCenter: parent.verticalCenter
                                padding: cellPadding
                                font.weight: pythonModel.cell_dict.cell_length_b.refine ? Font.Bold : Font.Normal
                                text: index == 0 ? pythonModel.cell_dict.cell_length_b.title : pythonModel.cell_dict.cell_length_b.value
                                onEditingFinished: {
                                    const datablock = pythonModel.cell_dict.datablock
                                    let obj = pythonModel.data
                                    obj[datablock].cell_length_b.value = text
                                    pythonModel.data = obj
                                }
                            }
                        }

                        //////////////////////////////////////////

                        // Next column: Cell length c
                        Rectangle {
                            color: index % 2 ? rowColor : alternateRowColor
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            TextEdit {
                                enabled: index
                                anchors.verticalCenter: parent.verticalCenter
                                padding: cellPadding
                                font.weight: pythonModel.cell_dict.cell_length_c.refine ? Font.Bold : Font.Normal
                                text: index == 0 ? pythonModel.cell_dict.cell_length_c.title : pythonModel.cell_dict.cell_length_c.value
                                onEditingFinished: {
                                    const datablock = pythonModel.cell_dict.datablock
                                    let obj = pythonModel.data
                                    obj[datablock].cell_length_c.value = text
                                    pythonModel.data = obj
                                }
                            }
                        }

                        //////////////////////////////////////////

                        // Next column: Cell angle alpha
                        Rectangle {
                            color: index % 2 ? rowColor : alternateRowColor
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            TextEdit {
                                enabled: index
                                anchors.verticalCenter: parent.verticalCenter
                                padding: cellPadding
                                font.weight: pythonModel.cell_dict.cell_angle_alpha.refine ? Font.Bold : Font.Normal
                                text: index == 0 ? pythonModel.cell_dict.cell_angle_alpha.title : pythonModel.cell_dict.cell_angle_alpha.value
                                onEditingFinished: {
                                    const datablock = pythonModel.cell_dict.datablock
                                    let obj = pythonModel.data
                                    obj[datablock].cell_angle_alpha.value = text
                                    pythonModel.data = obj
                                }
                            }
                        }

                        //////////////////////////////////////////

                        // Next column: Cell angle beta
                        Rectangle {
                            color: index % 2 ? rowColor : alternateRowColor
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            TextEdit {
                                enabled: index
                                anchors.verticalCenter: parent.verticalCenter
                                padding: cellPadding
                                font.weight: pythonModel.cell_dict.cell_angle_beta.refine ? Font.Bold : Font.Normal
                                text: index == 0 ? pythonModel.cell_dict.cell_angle_beta.title : pythonModel.cell_dict.cell_angle_beta.value
                                onEditingFinished: {
                                    const datablock = pythonModel.cell_dict.datablock
                                    let obj = pythonModel.data
                                    obj[datablock].cell_angle_beta.value = text
                                    pythonModel.data = obj
                                }
                            }
                        }

                        //////////////////////////////////////////

                        // Next column: Cell angle gamma
                        Rectangle {
                            color: index % 2 ? rowColor : alternateRowColor
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            TextEdit {
                                enabled: index
                                anchors.verticalCenter: parent.verticalCenter
                                padding: cellPadding
                                font.weight: pythonModel.cell_dict.cell_angle_gamma.refine ? Font.Bold : Font.Normal
                                text: index == 0 ? pythonModel.cell_dict.cell_angle_gamma.title : pythonModel.cell_dict.cell_angle_gamma.value
                                onEditingFinished: {
                                    const datablock = pythonModel.cell_dict.datablock
                                    let obj = pythonModel.data
                                    obj[datablock].cell_angle_gamma.value = text
                                    pythonModel.data = obj
                                }
                            }
                        }

                        //////////////////////////////////////////

                    }
                }
            }
        }

        //////////////////////////////////////////
        //////////////////////////////////////////

        Item { Layout.fillHeight: true }

        Text { text: "Buttons"; color: headerColor }

        RowLayout {
            Layout.fillWidth: true
            height: 100
            spacing: 20

            //////////////////////////////////////////

            Button {
                Layout.fillWidth: true
                text: 'Start fitting'
                onClicked: {
                    info.open()
                    infoLabel.text = ""
                    const res = pythonModel.refine_model()
                    if (typeof res === "string") {
                        infoLabel.text += res
                    } else {
                        infoLabel.text += `${res.message}\n`
                        infoLabel.text += `Success: ${res.success}\n`
                        infoLabel.text += `Number of iterations: ${res.nit}`
                    }
                }
            }

            //////////////////////////////////////////

            Button {
                Layout.fillWidth: true
                text: 'Random change "a"'
                onClicked: {
                    pythonModel.random_change_cell_length_a()
                }
            }

            //////////////////////////////////////////

        }

        //////////////////////////////////////////
        //////////////////////////////////////////

    }

    //////////////////////////////////////////
    //////////////////////////////////////////
    //////////////////////////////////////////

    Component.onCompleted: {
    }

    //////////////////////////////////////////
    //////////////////////////////////////////
    //////////////////////////////////////////

    Dialog {
        id: info
        anchors.centerIn: parent
        modal: true

        Label {
            id: infoLabel
            anchors.centerIn: parent
        }
    }

    //////////////////////////////////////////
    //////////////////////////////////////////
    //////////////////////////////////////////

}

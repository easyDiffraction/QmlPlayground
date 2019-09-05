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
    property int maxRowCountToDisplay: 6
    property string rowColor: 'whitesmoke'
    property string alternateRowColor: 'lightgray'

    //////////////////////////////////////////
    //////////////////////////////////////////
    //////////////////////////////////////////

    ColumnLayout {
        anchors.fill: parent
        spacing: 20
        anchors.margins: 20

        //////////////////////////////////////////
        //////////////////////////////////////////

        Text { text: "Parameters (Analysis Tab)"; color: "darkblue" }

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
                                    const datablock = pythonModel.fitables_list[index].datablock
                                    const group = pythonModel.fitables_list[index].group
                                    const subgroup = pythonModel.fitables_list[index].subgroup
                                    const fitable = pythonModel.fitables_list[index].fitable
                                    if (group && subgroup) {
                                        return `${datablock} ${group} ${subgroup} ${fitable}`
                                    } else {
                                        return `${datablock} ${fitable}`
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
                                text: pythonModel.fitables_list[index].value
                                onEditingFinished: {
                                    let obj = pythonModel.data
                                    const datablock = pythonModel.fitables_list[index].datablock
                                    const group = pythonModel.fitables_list[index].group
                                    const subgroup = pythonModel.fitables_list[index].subgroup
                                    const fitable = pythonModel.fitables_list[index].fitable
                                    if (group && subgroup) {
                                        obj[datablock][group][subgroup][fitable].value = text
                                    } else {
                                        obj[datablock][fitable].value = text
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
                                    let obj = pythonModel.data
                                    const datablock = pythonModel.fitables_list[index].datablock
                                    const group = pythonModel.fitables_list[index].group
                                    const subgroup = pythonModel.fitables_list[index].subgroup
                                    const fitable = pythonModel.fitables_list[index].fitable
                                    if (group && subgroup) {
                                        obj[datablock][group][subgroup][fitable].refine = checked
                                    } else {
                                        obj[datablock][fitable].refine = checked
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

        Text { text: "Cell (Sample Model Tab)"; color: "darkblue" }

        ScrollView {
            Layout.fillWidth: true
            Layout.preferredHeight: rowHeight
            Layout.maximumHeight: rowHeight
            clip: true

            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            ScrollBar.vertical.policy: ScrollBar.AsNeeded

            ListView {
                //id: listView
                spacing: cellSpacing

                // Use single row model
                model: 1

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
                                anchors.verticalCenter: parent.verticalCenter
                                padding: cellPadding
                                text: pythonModel.cell_dict.cell_length_a.value
                                onEditingFinished: {
                                    const datablock = pythonModel.cell_dict.datablock
                                    let obj = pythonModel.data
                                    obj[datablock].cell_length_a.value = text
                                    pythonModel.data = obj
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
                                anchors.verticalCenter: parent.verticalCenter
                                padding: cellPadding
                                text: pythonModel.cell_dict.cell_length_b.value
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
                                anchors.verticalCenter: parent.verticalCenter
                                padding: cellPadding
                                text: pythonModel.cell_dict.cell_length_c.value
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
                                anchors.verticalCenter: parent.verticalCenter
                                padding: cellPadding
                                text: pythonModel.cell_dict.cell_angle_alpha.value
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
                                anchors.verticalCenter: parent.verticalCenter
                                padding: cellPadding
                                text: pythonModel.cell_dict.cell_angle_beta.value
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
                                anchors.verticalCenter: parent.verticalCenter
                                padding: cellPadding
                                text: pythonModel.cell_dict.cell_angle_gamma.value
                                onEditingFinished: {
                                    const datablock = pythonModel.cell_dict.datablock
                                    let obj = pythonModel.data
                                    obj[datablock].cell_angle_gamma.value = text
                                    pythonModel.data = obj
                                    pythonModel.update_rhochi_model()
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

        Text { text: "Buttons"; color: "darkblue" }

        RowLayout {
            Layout.fillWidth: true
            height: 100
            spacing: 20

            //////////////////////////////////////////

            Button {
                Layout.fillWidth: true
                text: 'refine'
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
                text: 'random change cell_length_a'
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

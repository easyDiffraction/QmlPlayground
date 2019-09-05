import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ApplicationWindow {
    id: window
    visible: true
    width: 600
    height: 700

    property int rowHeight: 44
    property int cellSpacing: 1
    property int cellPadding: 5
    property int maxRowCountToDisplay: 4
    property string rowColor: 'whitesmoke'
    property string alternateRowColor: 'lightgray'

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

                        // Next column: name
                        Rectangle {
                            color: index % 2 ? rowColor : alternateRowColor
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                padding: cellPadding
                                text: {
                                    const datablock = pythonModel.fitables_list[index].datablock
                                    const group = pythonModel.fitables_list[index].group
                                    const subgroup = pythonModel.fitables_list[index].subgroup
                                    const fitable = pythonModel.fitables_list[index].fitable
                                    if (group && subgroup) {
                                        `${datablock} ${group} ${subgroup} ${fitable}`
                                    } else {
                                        `${datablock} ${fitable}`
                                    }
                                }
                            }
                        }

                        // Next column: value
                        Rectangle {
                            color: index % 2 ? rowColor : alternateRowColor
                            Layout.fillHeight: true
                            Layout.fillWidth: true
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

                        // Next column: refine
                        Rectangle {
                            color: index % 2 ? rowColor : alternateRowColor
                            Layout.preferredHeight: rowHeight
                            Layout.preferredWidth: rowHeight
                            CheckBox {
                                checked: pythonModel.fitables_list[index].refine
                                //onToggled: atomSiteModel.modify(index, model.label, model.x, model.y, model.z, checked)
                            }
                        }
                    }
                }
            }
        }

        //////////////////////////////////////////
        //////////////////////////////////////////

        Text { text: "Atoms (Sample Model Tab)"; color: "darkblue" }

        ScrollView {
            Layout.fillWidth: true
            Layout.preferredHeight: rowHeight * maxRowCountToDisplay + cellSpacing * (maxRowCountToDisplay - 1)
            Layout.maximumHeight: rowHeight * maxRowCountToDisplay + cellSpacing * (maxRowCountToDisplay - 1)
            clip: true

            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            ScrollBar.vertical.policy: ScrollBar.AsNeeded

            ListView {
                id: listView
                spacing: cellSpacing

                // Use python model
                model: pythonModel.atom_site_list

                // Table row view
                delegate: Rectangle {
                    width: parent.width
                    height: rowHeight
                    color: "white"

                    RowLayout {
                        width: parent.width
                        height: rowHeight
                        spacing: cellSpacing

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

                        // Next column: Atom site label
                        Rectangle {
                            color: index % 2 ? rowColor : alternateRowColor
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                padding: cellPadding
                                text: pythonModel.atom_site_list[index].label
                            }
                        }

                        // Next column: Atom site fract x
                        Rectangle {
                            color: index % 2 ? rowColor : alternateRowColor
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            TextEdit {
                                anchors.verticalCenter: parent.verticalCenter
                                padding: cellPadding
                                text: pythonModel.atom_site_list[index].fract_x.value
                                onEditingFinished: {
                                    const datablock = pythonModel.atom_site_list[index].datablock
                                    const subgroup = pythonModel.atom_site_list[index].label
                                    let obj = pythonModel.data
                                    obj[datablock].atom_site[subgroup].fract_x.value = text
                                    pythonModel.data = obj
                                }
                            }
                        }

                        // Next column: Atom site fract y
                        Rectangle {
                            color: index % 2 ? rowColor : alternateRowColor
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            TextEdit {
                                anchors.verticalCenter: parent.verticalCenter
                                padding: cellPadding
                                text: pythonModel.atom_site_list[index].fract_y.value
                                onEditingFinished: {
                                    const datablock = pythonModel.atom_site_list[index].datablock
                                    const subgroup = pythonModel.atom_site_list[index].label
                                    let obj = pythonModel.data
                                    obj[datablock].atom_site[subgroup].fract_y.value = text
                                    pythonModel.data = obj
                                }
                            }
                        }

                        // Next column: Atom site fract z
                        Rectangle {
                            color: index % 2 ? rowColor : alternateRowColor
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            TextEdit {
                                anchors.verticalCenter: parent.verticalCenter
                                padding: cellPadding
                                text: pythonModel.atom_site_list[index].fract_z.value
                                onEditingFinished: {
                                    const datablock = pythonModel.atom_site_list[index].datablock
                                    const subgroup = pythonModel.atom_site_list[index].label
                                    let obj = pythonModel.data
                                    obj[datablock].atom_site[subgroup].fract_z.value = text
                                    pythonModel.data = obj
                                }
                            }
                        }

                        // Next column: Atom site occupancy
                        Rectangle {
                            color: index % 2 ? rowColor : alternateRowColor
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            TextEdit {
                                anchors.verticalCenter: parent.verticalCenter
                                padding: cellPadding
                                text: pythonModel.atom_site_list[index].occupancy.value
                                onEditingFinished: {
                                    const datablock = pythonModel.atom_site_list[index].datablock
                                    const subgroup = pythonModel.atom_site_list[index].label
                                    let obj = pythonModel.data
                                    obj[datablock].atom_site[subgroup].occupancy.value = text
                                    pythonModel.data = obj
                                }
                            }
                        }

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
                                }
                            }
                        }

                    }
                }
            }
        }

        //////////////////////////////
        //////////////////////////////

        Item { Layout.fillHeight: true }

        Text { text: "Buttons"; color: "darkblue" }

        RowLayout {
            Layout.fillWidth: true
            height: 100
            spacing: 20

            Button {
                Layout.fillWidth: true
                text: 'random_change_cell_length_a'
                onClicked: {
                    pythonModel.random_change_cell_length_a()
                }
            }

            Text {
                text: 'a = ' + pythonModel.data.Fe3O4.cell_length_a.value
            }
        }

        //////////////////////////////
        //////////////////////////////

    }

    Component.onCompleted: {
    }

}

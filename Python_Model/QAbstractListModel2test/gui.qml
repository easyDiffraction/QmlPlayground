import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ApplicationWindow {
    id: window
    visible: true
    width: 600
    height: 800

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
                model: pythonModelZ.fitables_list

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
                                    const datablock = pythonModelZ.fitables_list[index].datablock
                                    const group = pythonModelZ.fitables_list[index].group
                                    const subgroup = pythonModelZ.fitables_list[index].subgroup
                                    const fitable = pythonModelZ.fitables_list[index].fitable
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
                                text: pythonModelZ.fitables_list[index].value
                                onEditingFinished: {
                                    let obj = pythonModelZ.data
                                    const datablock = pythonModelZ.fitables_list[index].datablock
                                    const group = pythonModelZ.fitables_list[index].group
                                    const subgroup = pythonModelZ.fitables_list[index].subgroup
                                    const fitable = pythonModelZ.fitables_list[index].fitable
                                    if (group && subgroup) {
                                        obj[datablock][group][subgroup][fitable].value = text
                                    } else {
                                        obj[datablock][fitable].value = text
                                    }
                                    pythonModelZ.data = obj
                                }
                            }
                        }

                        // Next column: refine
                        Rectangle {
                            color: index % 2 ? rowColor : alternateRowColor
                            Layout.preferredHeight: rowHeight
                            Layout.preferredWidth: rowHeight
                            CheckBox {
                                checked: pythonModelZ.fitables_list[index].refine
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
                model: pythonModelZ.atom_site_list

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
                                text: pythonModelZ.atom_site_list[index].label
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
                                text: pythonModelZ.atom_site_list[index].fract_x.value
                                onEditingFinished: {
                                    const datablock = pythonModelZ.atom_site_list[index].datablock
                                    const subgroup = pythonModelZ.atom_site_list[index].label
                                    let obj = pythonModelZ.data
                                    obj[datablock].atom_site[subgroup].fract_x.value = text
                                    pythonModelZ.data = obj
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
                                text: pythonModelZ.atom_site_list[index].fract_y.value
                                onEditingFinished: {
                                    const datablock = pythonModelZ.atom_site_list[index].datablock
                                    const subgroup = pythonModelZ.atom_site_list[index].label
                                    let obj = pythonModelZ.data
                                    obj[datablock].atom_site[subgroup].fract_y.value = text
                                    pythonModelZ.data = obj
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
                                text: pythonModelZ.atom_site_list[index].fract_z.value
                                onEditingFinished: {
                                    const datablock = pythonModelZ.atom_site_list[index].datablock
                                    const subgroup = pythonModelZ.atom_site_list[index].label
                                    let obj = pythonModelZ.data
                                    obj[datablock].atom_site[subgroup].fract_z.value = text
                                    pythonModelZ.data = obj
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
                                text: pythonModelZ.atom_site_list[index].occupancy.value
                                onEditingFinished: {
                                    const datablock = pythonModelZ.atom_site_list[index].datablock
                                    const subgroup = pythonModelZ.atom_site_list[index].label
                                    let obj = pythonModelZ.data
                                    obj[datablock].atom_site[subgroup].occupancy.value = text
                                    pythonModelZ.data = obj
                                }
                            }
                        }

                    }
                }
            }
        }

        //////////////////////////////
        /// BUTTONS FOR EDITABLE TABLE
        //////////////////////////////

        Item { Layout.fillHeight: true }

        Text { text: "BUTTONS FOR EDITABLE TABLE"; color: "darkblue" }

        RowLayout {
            Layout.fillWidth: true
            height: 100
            spacing: 20

            Button {
                Layout.fillWidth: true
                text: pythonModelZ.data.Fe3O4.cell_length_a.value
                onClicked: {
                    //pythonModelZ.random_change_cell_length_a()
                    let obj = pythonModelZ.data
                    pythonModelZ.data = obj
                }
            }

            TextEdit {
                enabled: false
                text: pythonModelZ.data.Fe3O4.cell_length_a.value
                onEditingFinished: {
                    let obj = pythonModelZ.data
                    obj.data_Fe3O4.cell_length_a.value = text
                    pythonModelZ.set_data(obj)

                }
            }

            TextEdit {
                text: pythonModelZ.data.Fe3O4.cell_length_a.value
                onEditingFinished: {
                    //print("before", pythonModelZ.data.data_Fe3O4.cell_length_a)
                    //pythonModelZ.data.data_Fe3O4.cell_length_a = text
                    //print("after", pythonModelZ.data.data_Fe3O4.cell_length_a)
                    //pythonModelZ.set_data(pythonModelZ.data)

                    let obj = pythonModelZ.data
                    obj.data_Fe3O4.cell_length_a.value = text
                    print("text", text, obj.data_Fe3O4.cell_length_a)
                    print("1 pythonModelZ.data.data_Fe3O4.cell_length_a", pythonModelZ.data.data_Fe3O4.cell_length_a)
                    //pythonModelZ.data = obj
                    //pythonModelZ.data.data_Fe3O4.cell_length_a = text
                    //pythonModelZ.data["data_Fe3O4"]["cell_length_a"] = text
                    pythonModelZ.data = obj
                    print("2 pythonModelZ.data.data_Fe3O4.cell_length_a", pythonModelZ.data.data_Fe3O4.cell_length_a)

                }
            }
            /*
            Button {
                Layout.fillWidth: true
                text: "Change atom site No. 2"
                onClicked: atomSiteModel.modifyAtomSiteNo2()
            }

            Button {
                Layout.fillWidth: true
                text: "Add default atom site"
                onClicked: atomSiteModel.append('H', 0.0, 0.0, 0.0, false)
            }
            */

            /*
            Button {
                Layout.fillWidth: true
                text: "Remove last stom site"
                onClicked: atomSiteModel.remove(listView.model.rowCount() - 1)
            }
            */

            /*
            Button {
                id: infoButton
                Layout.fillWidth: true
                //text: "old:" + pythonModelZ.datablocks.data_Fe3O4.cell_length_a
            }
            */

            /*
            Button {
                Layout.fillWidth: true
                text: "PRESS"
                onClicked: {
                    //pythonModel2.modify_cell_length_a()
                    infoButton.text = "new:" + pythonModelZ.datablocks.data_Fe3O4.cell_length_a
                }
            }
            */

        }

        ///////////////////////////////////
        /// VIEWER SYNCED WITH PYTHON MODEL
        ///////////////////////////////////

        Item { Layout.fillHeight: true }

        Text { text: "VIEWER SYNCED WITH PYTHON MODEL"; color: "darkblue" }

        ScrollView {
            Layout.fillWidth: true
            Layout.preferredHeight: 200
            clip: true

            background: Rectangle { color: "whitesmoke" }

            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            ScrollBar.vertical.policy: ScrollBar.AsNeeded

            ListView {
                model: pythonModelZ.data.Fe3O4.atom_site

                delegate: RowLayout {
                    enabled: false

                    Text { text: pythonModelZ.data.Fe3O4.atom_site[index].label }
                    Text { text: pythonModelZ.data.Fe3O4.atom_site[index].fract_x.value }
                    Text { text: pythonModelZ.data.Fe3O4.atom_site[index].fract_y.value }
                    Text { text: pythonModelZ.data.Fe3O4.atom_site[index].fract_z.value }
                    Text { text: pythonModelZ.data.Fe3O4.atom_site[index].occupancy.value }
                }
            }
        }

    }

    Component.onCompleted: {
        //print("1", pythonModel.datablocks.data_Fe3O4.cell_length_a)
        //print("2", pythonModel.datablocks.data_Fe3O4)
        //print("2", pythonModel.datablocks["data_Fe3O4"])
        //print("3", pythonModel.datablocks)
        //print("4", pythonModel["datablocks"])
        //print("5", pythonModel)
        //print("6", pythonModel._datablocks.datablocks.data_Fe3O4.cell_length_a)

        //print("01", pythonModel2.datablocks().data_Fe3O4.cell_length_a)
        ///print("pythonModel from QML", pythonModel)
        print("== len", pythonModelZ.data.Fe3O4.atom_site)
    }



}

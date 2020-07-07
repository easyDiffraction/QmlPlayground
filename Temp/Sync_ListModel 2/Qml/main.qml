import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import Qt.labs.settings 1.1
import QtQuick.Controls 1.4 as Controls1

//import CustomTableModel 1.0

ApplicationWindow {
    id: window

    visible: true

    width: 600
    height: 600

    property int rowHeight: 44
    property int cellSpacing: 1
    property int maxRowCountToDisplay: 5

    ColumnLayout {

        anchors.fill: parent
        spacing: 0



        ////////
        ListView {
            id: listView
            Layout.fillWidth: true
            //Layout.fillHeight: true
            //height: tableHeight()
            height: rowHeight * maxRowCountToDisplay + cellSpacing * (maxRowCountToDisplay - 1)
            clip: true
            spacing: cellSpacing






            model: personModel

            /*
            Rectangle {
                z: -1
                anchors.fill: parent
                color: "blue"
                border.color: "blue"
                border.width: 1
            }
            */

            //headerPositioning: ListModel.Over

            //header:

            delegate: Rectangle {
                width: parent.width
                height: rowHeight
                color: "white"

                RowLayout {
                    width: parent.width
                    spacing: cellSpacing

                    Rectangle {
                        color: index % 2 ? 'whitesmoke' : 'lightgray'
                        Layout.fillHeight: true
                        Layout.preferredWidth: rowHeight
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            padding: 5
                            text: index + 1
                        }
                    }

                    Rectangle {
                        color: index % 2 ? 'whitesmoke' : 'lightgray'
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        TextEdit {
                            anchors.verticalCenter: parent.verticalCenter
                            padding: 5
                            //Component.onCompleted: text = model.name
                            text: model.name
                            //onTextChanged: personModel.editPerson(index, text, model.age, model.refine, true)
                            onEditingFinished: personModel.editPerson(index, text, model.age, model.refine)
                        }
                    }

                    Rectangle {
                        color: index % 2 ? 'whitesmoke' : 'lightgray'
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        TextEdit {
                            anchors.verticalCenter: parent.verticalCenter
                            padding: 5
                            text: model.age
                            onEditingFinished: personModel.editPerson(index, model.name, text, model.refine)
                        }
                    }

                    Rectangle {
                        color: index % 2 ? 'whitesmoke' : 'lightgray' // ghostwhite
                        Layout.preferredHeight: rowHeight
                        Layout.preferredWidth: rowHeight
                        CheckBox {
                            checked: model.refine
                            //onCheckedChanged: personModel.editPerson(index, model.name, model.age, checked, true)
                            onToggled: personModel.editPerson(index, model.name, model.age, checked)
                        }
                    }
                }
            }
        }



        /////////////
        /// DUPLICATE
        /////////////
        ListView {
            width: 200
            height: 150
            clip: true

            enabled: false

            model: personModel

            delegate: RowLayout {
                Text { text: model.name }
                Text { text: age }
                CheckBox { checked: model.refine }
            }
        }



        /////////////
        /// BUTTONS
        /////////////
        RowLayout {
            Layout.fillWidth: true
            spacing: 20

            //////
            Button {
                Layout.fillWidth: true
                text: "Change person No. 2"
                onClicked: personModel.refineIt()
            }

            //////
            Button {
                Layout.fillWidth: true
                text: "Add person 'luis'"
                onClicked: personModel.addPerson("luis", 22, false)
            }

            //////
            Button {
                Layout.fillWidth: true
                text: "Add person"
                onClicked: personModel.addPerson("", 0, false)
            }

            //////
            Button {
                Layout.fillWidth: true
                text: "Remove last person"
                onClicked: personModel.deletePerson(listView.model.rowCount() - 1)
            }
        }





/*
        ListView {
            id : xxx
            width: 300
            height: 200
            //anchors.fill: parent
            model: myModel
            delegate: Component {
                Rectangle {
                    height: 25
                    width: 100
                    Text {
                        function displayText() {
                            var result = ""
                            if (typeof display !== "undefined")
                                result = display + ": "
                            result += modelData
                            return result
                        }

                        text: displayText()
                    }
                }
            }
        }
*/




    }







/*
    GenericAppElements.GridLayout {
        columns: 1
        rowSpacing: 2
        Text { text: "Lattice parameters"; color: Generic.Style.sidebarLabelColor; font.pointSize: Generic.Style.fontPointSize - 1 }
        Text { text: msg.helloMessage(); color: Generic.Style.sidebarLabelColor; font.pointSize: Generic.Style.fontPointSize - 1 }

        GenericAppElements.ParametersTable {
            model: ListModel {
                ListElement { a:"4.256782"; b:"4.256782"; c:"10.633879"; alpha:"90.0"; beta:"90.0"; gamma:"90.0" }
            }
            Controls1.TableViewColumn { role:"a";       title:"a (\u212B)" }
            Controls1.TableViewColumn { role:"b";       title:"b (\u212B)" }
            Controls1.TableViewColumn { role:"c";       title:"c (\u212B)"  }
            Controls1.TableViewColumn { role:"alpha";   title:"alpha (°)"  }
            Controls1.TableViewColumn { role:"beta";    title:"beta (°)"  }
            Controls1.TableViewColumn { role:"gamma";   title:"gamma (°)" }
            Component.onCompleted: {
                const data = { 'a':"???", 'b':"4.256782", 'c':"10.633879", 'alpha':"90.0", 'beta':"90.0", 'gamma':"90.0" }
                model.append(data)
                group1.title = proxy.cell_length_a()
            }
        }
    }


    GenericAppElements.ParametersTable {
        width: parent.width
        model: cellModel
        //model: ListModel {
        //    ListElement { a:"4.256782"; b:"4.256782"; c:"10.633879"; alpha:"90.0"; beta:"90.0"; gamma:"90.0" }
        //}
        //Controls1.TableViewColumn { role:"Date";       title:"Title Date" }
        //Controls1.TableViewColumn { role:"Magnitude";  title:"Magnitude" }
    }

*/


    // Introduction animation
//    GenericApp.Intro {}

    // Application menubar
    ///GenericAppMenubar.Menubar {}

    // Application window layout
    /*
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        GenericAppToolbar.Toolbar {}
        GenericAppContentArea.ContentArea {}
    }
    */

    // On completed
    Component.onCompleted: {
    }

    // On destruction
    Component.onDestruction: {
    }

}





/*
class CustomTableModel(QAbstractTableModel):
    def __init__(self, data=None):
        QAbstractTableModel.__init__(self)
        self.load_data(data)

    def load_data(self, data):
        self.input_dates = [1, 2] #data[0].values
        self.input_magnitudes = [3, 4] #data[1].values

        self.column_count = 2
        self.row_count = len(self.input_magnitudes)

    def rowCount(self, parent=QModelIndex()):
        return self.row_count

    def columnCount(self, parent=QModelIndex()):
        return self.column_count

    def headerData(self, section, orientation, role):
        if role != Qt.DisplayRole:
            return None
        if orientation == Qt.Horizontal:
            print("1", ("Date", "Magnitude")[section])
            return ("Date", "Magnitude")[section]
        else:
            print("2", "{}".format(section))
            return "{}".format(section)

    def data(self, index, role=Qt.DisplayRole):
        column = index.column()
        row = index.row()

        if role == Qt.DisplayRole:
            if column == 0:
                return "{:.2f}".format(self.input_dates[row])
            elif column == 1:
                return "{:.2f}".format(self.input_magnitudes[row])
        elif role == Qt.BackgroundRole:
            return QColor(Qt.white)
        elif role == Qt.TextAlignmentRole:
            return Qt.AlignRight

        return None
*/





/*
    GenericAppElements.ParametersTable {
        model: ListModel {
            ListElement { a:"4.256782"; b:"4.256782"; c:"10.633879"; alpha:"90.0"; beta:"90.0"; gamma:"90.0" }
        }
        Controls1.TableViewColumn { role:"a";       title:"a (\u212B)" }
        Controls1.TableViewColumn { role:"b";       title:"b (\u212B)" }
        Controls1.TableViewColumn { role:"c";       title:"c (\u212B)"  }
        Controls1.TableViewColumn { role:"alpha";   title:"alpha (°)"  }
        Controls1.TableViewColumn { role:"beta";    title:"beta (°)"  }
        Controls1.TableViewColumn { role:"gamma";   title:"gamma (°)" }
        Component.onCompleted: {
            console.log(proxy.cell_length_a)
            model.clear()
            model.append({
                'a':proxy.cell_length_a(),
                'b':proxy.cell_length_b(),
                'c':proxy.cell_length_c(),
                'alpha':proxy.cell_angle_alpha(),
                'beta':proxy.cell_angle_beta(),
                'gamma':proxy.cell_angle_gamma()
            })
        }
    }
*/





//    GenericAppElements.ParametersTable {
//    Controls1.TableView {
    /*
    TableView {
        anchors.fill: parent
        columnSpacing: 1
        rowSpacing: 1
        clip: true

        model: cellModel //TableModel {}

        delegate: Rectangle {
            implicitWidth: 100
            implicitHeight: 50
            Text {
                text: model.display
            }
        }
    }

    */

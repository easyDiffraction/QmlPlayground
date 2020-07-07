import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtCharts 2.13

ApplicationWindow {
    id: window
    visible: true
    width: 700
    height: 900

    property int rowHeight: 44
    property int cellSpacing: 0//1
    property int cellPadding: 5

    property int maxRowCountToDisplay: 4

    property string rowBackgroundColor: 'white'
    property string alternateRowBackgroundColor: '#f7f7f7'
    property string headerBackgroundColor: '#eee'
    property string rowBorderColor: '#e8e8e8'
    property string headerBorderColor: '#dedede'
    property string headerTextColor: '#666'//'#2a99d9'

    property int currentRowNumberColumnWidth: 0

    property int borderWidth: 1
    property int cellWidth: 150
    property int cellHeight: 30

    property var startTime: Date.now()


    //////////////////////////////////////////
    //////////////////////////////////////////
    //////////////////////////////////////////

    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        //////////////////////////////////////////
        // Analysis plot
        Rectangle {
            width: parent.width
            height: cellHeight * 7
            border.width: borderWidth
            border.color: headerBorderColor

            ChartView {
                width: parent.width
                height: parent.height
                anchors.margins: -12
                antialiasing: true
                legend.visible: false
                //animationOptions: ChartView.AllAnimations

                LineSeries {
                    //useOpenGL: true
                    VXYModelMapper{
                        model: pythonModel.experimental_data_model
                        xColumn: 0
                        yColumn: 1
                    }
                }

                LineSeries {
                    //useOpenGL: true
                    VXYModelMapper{
                        model: pythonModel.simulated_data_model
                        xColumn: 0
                        yColumn: 1
                    }
                }
            }
        }
        // Analysis plot
        //////////////////////////////////////////

        /*
        //////////////////////////////////////////
        // Simulated data table
        Rectangle {
            width: cellWidth * 3.5 + borderWidth * 3
            height: cellHeight * 5
            border.width: borderWidth
            border.color: headerBorderColor

            ScrollView {
                anchors.fill: parent
                anchors.margins: borderWidth
                clip: true
                ScrollBar.vertical.minimumSize: 0.1
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                ScrollBar.vertical.policy: ScrollBar.AsNeeded

                TableView {
                    id: tableView
                    anchors.fill: parent
                    leftMargin: rowsHeader.implicitWidth
                    topMargin: columnsHeader.implicitHeight
                    boundsBehavior: Flickable.StopAtBounds

                    model: pythonModel.simulated_data_model///tableModel

                    // table row
                    delegate: Rectangle {
                        implicitWidth: cellWidth
                        implicitHeight: cellHeight
                        color: index % 2 ? alternateRowBackgroundColor : rowBackgroundColor
                        // cell text
                        Text {
                            width: parent.width
                            height: parent.height
                            leftPadding: 10
                            rightPadding: leftPadding
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignVCenter
                            text: display
                        }
                        // cell left border
                        Rectangle {
                            width: borderWidth
                            height: parent.height
                            color: rowBorderColor
                        }
                        // cell top border
                        Rectangle {
                            width: parent.width
                            height: borderWidth
                            color: rowBorderColor
                        }
                    }

                    // table columns and rows headers
                    Rectangle { // mask the headers
                        z: 3
                        color: headerBackgroundColor
                        x: tableView.contentX
                        y: tableView.contentY
                        width: tableView.leftMargin
                        height: tableView.topMargin
                        //border.color: "red"
                    }
                    Row {
                        id: columnsHeader
                        y: tableView.contentY
                        z: 2
                        Repeater {
                            model: tableView.columns > 0 ? tableView.columns : 1
                            Label {
                                width: cellWidth //tableView.columnWidthProvider(modelData)
                                height: cellHeight //tableView.rowHeightProvider(modelData)
                                leftPadding: 10
                                rightPadding: leftPadding
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                color: headerTextColor
                                background: Rectangle {
                                    color: headerBackgroundColor
                                    // header left border
                                    Rectangle {
                                        width: borderWidth
                                        height: parent.height
                                        color: headerBorderColor
                                    }
                                }
                                ///text: pythonModel.simulated_data_model.headerData(modelData, Qt.Horizontal)
                            }
                        }
                    }
                    Column {
                        id: rowsHeader
                        x: tableView.contentX
                        z: 2
                        Repeater {
                            model: tableView.rows > 0 ? tableView.rows : 1
                            Label {
                                width: cellWidth / 2 //tableView.columnWidthProvider(modelData) / 2
                                height: cellHeight //tableView.rowHeightProvider(modelData)
                                leftPadding: 10
                                rightPadding: leftPadding
                                horizontalAlignment: Text.AlignRight
                                verticalAlignment: Text.AlignVCenter
                                color: headerTextColor
                                background: Rectangle {
                                    color: headerBackgroundColor
                                    // header top border
                                    Rectangle {
                                        width: parent.width
                                        height: borderWidth
                                        color: headerBorderColor
                                    }
                                }
                                ///text: pythonModel.simulated_data_model.headerData(modelData, Qt.Vertical)
                            }

                        }
                    }
                }
            }
        }
        // Simulated data table
        //////////////////////////////////////////
        */

        //////////////////////////////////////////
        // Simulated data table - AS TABLE

        Rectangle {
            width: childrenRect.width + borderWidth * 2
            height: childrenRect.height + borderWidth * 2
            border.width: borderWidth
            border.color: headerBorderColor

            // Horizontal Header
            Row {
                id: columnsHeader
                x: borderWidth
                y: borderWidth
                width: simulatedDataTable.width
                height: cellHeight
                Repeater {
                    model: simulatedDataTable.columns
                    Label {
                        width: cellWidth
                        height: cellHeight
                        leftPadding: font.pixelSize
                        rightPadding: leftPadding
                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter
                        color: headerTextColor
                        background: Rectangle { color: headerBackgroundColor }
                        text: simulatedDataTable.model.headerData(modelData, Qt.Horizontal)
                    }
                }
            }

            // Table cells
            TableView {
                id: simulatedDataTable
                x: columnsHeader.x
                anchors.top: columnsHeader.bottom
                width: cellWidth * columns
                height: cellHeight * 5
                clip: true
                boundsBehavior: Flickable.StopAtBounds

                model: pythonModel.simulated_data_model

                delegate: Rectangle {
                    implicitWidth: cellWidth
                    implicitHeight: cellHeight
                    color: row % 2 ? alternateRowBackgroundColor : rowBackgroundColor
                    TextInput {
                        anchors.fill: parent
                        leftPadding: font.pixelSize
                        rightPadding: leftPadding
                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter
                        validator : RegExpValidator { regExp : /[0-9]*\.[0-9]+/ }
                        text: display
                        onEditingFinished: edit = text
                    }
                }

                ScrollBar.horizontal: ScrollBar { policy: ScrollBar.AlwaysOff }
                ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded; minimumSize: 0.2 }
            }
        }

        // Simulated data table
        //////////////////////////////////////////

        //////////////////////////////////////////
        // Simulated data table - AS TABLE
        Rectangle {
            width: parent.width
            height: cellHeight * 5
            border.width: borderWidth
            border.color: headerBorderColor

            ScrollView {
                anchors.fill: parent
                anchors.margins: borderWidth
                clip: true
                ScrollBar.vertical.minimumSize: 0.2
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                ScrollBar.vertical.policy: ScrollBar.AsNeeded

                TableView {
                    id: simulatedDataTable22222
                    anchors.fill: parent
                    boundsBehavior: Flickable.StopAtBounds

                    model: pythonModel.simulated_data_model

                    delegate: Rectangle {
                        implicitWidth: parent.width / simulatedDataTable22222.columns
                        implicitHeight: cellHeight
                        color: row % 2 ? alternateRowBackgroundColor : rowBackgroundColor
                        TextInput {
                            anchors.fill: parent
                            leftPadding: font.pixelSize
                            rightPadding: leftPadding
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignVCenter
                            text: display
                            onEditingFinished: {
                                //edit = text
                            }
                        }
                    }
                }
            }
        }
        // Simulated data table
        //////////////////////////////////////////


        //////////////////////////////////////////
        // Unit cell table
        Rectangle {
            width: parent.width
            height: cellHeight * 2 + borderWidth * 2
            border.width: borderWidth
            border.color: headerBorderColor

                ListView {
                    //id: listView
                    anchors.fill: parent
                    anchors.margins: borderWidth
                    spacing: cellSpacing
                    boundsBehavior: Flickable.StopAtBounds

                    // Use single row model
                    model: 2

                    // Table row view
                    delegate: Rectangle {
                        width: parent.width
                        height: cellHeight
                        color: "white"

                        RowLayout {
                            width: parent.width
                            height: parent.height
                            spacing: cellSpacing

                            //////////////////////////////////////////

                            // Next column: Cell length a
                            Rectangle {
                                color: index % 2 ? rowBackgroundColor : alternateRowBackgroundColor
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
                                        let obj = pythonModel.main_dict
                                        obj[datablock].cell_length_a.value = text
                                        pythonModel.main_dict = obj
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
                                                    let obj = pythonModel.main_dict
                                                    obj[datablock].cell_length_a.refine = checked
                                                    pythonModel.main_dict = obj
                                                }
                                            }
                                        }
                                    }
                                }
                            }

                            //////////////////////////////////////////

                            // Next column: Cell length b
                            Rectangle {
                                color: index % 2 ? rowBackgroundColor : alternateRowBackgroundColor
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
                                        let obj = pythonModel.main_dict
                                        obj[datablock].cell_length_b.value = text
                                        pythonModel.main_dict = obj
                                    }
                                }
                            }

                            //////////////////////////////////////////

                            // Next column: Cell length c
                            Rectangle {
                                color: index % 2 ? rowBackgroundColor : alternateRowBackgroundColor
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
                                        let obj = pythonModel.main_dict
                                        obj[datablock].cell_length_c.value = text
                                        pythonModel.main_dict = obj
                                    }
                                }
                            }

                            //////////////////////////////////////////

                            // Next column: Cell angle alpha
                            Rectangle {
                                color: index % 2 ? rowBackgroundColor : alternateRowBackgroundColor
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
                                        let obj = pythonModel.main_dict
                                        obj[datablock].cell_angle_alpha.value = text
                                        pythonModel.main_dict = obj
                                    }
                                }
                            }

                            //////////////////////////////////////////

                            // Next column: Cell angle beta
                            Rectangle {
                                color: index % 2 ? rowBackgroundColor : alternateRowBackgroundColor
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
                                        let obj = pythonModel.main_dict
                                        obj[datablock].cell_angle_beta.value = text
                                        pythonModel.main_dict = obj
                                    }
                                }
                            }

                            //////////////////////////////////////////

                            // Next column: Cell angle gamma
                            Rectangle {
                                color: index % 2 ? rowBackgroundColor : alternateRowBackgroundColor
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
                                        let obj = pythonModel.main_dict
                                        obj[datablock].cell_angle_gamma.value = text
                                        pythonModel.main_dict = obj
                                    }
                                }
                            }

                            //////////////////////////////////////////

                        }
                    }


                }

        }


        // Unit cell table
        //////////////////////////////////////////

        //////////////////////////////////////////
        // Button
        Button {
            Layout.fillWidth: true
            text: 'Start fitting'
            onClicked: {
                // chart model: https://forum.qt.io/topic/77439/can-someone-provide-a-working-example-of-vxymodelmapper-with-lineseries-chart/3
                // !!!!!!!!! PyQt VXYModelMapper,...: https://github.com/Upcios/PyQtSamples
                const res = pythonModel.refine_model()
                infoLabel.text = `${res.refinement_message}`
                infoLabel.text += res.num_refined_parameters ? `\nNumber of refined parameters: ${res.num_refined_parameters}` : ""
                infoLabel.text += res.started_chi_sq ? `\nStarted goodnes-of-fit (\u03c7\u00b2): ${(res.started_chi_sq).toFixed(3)}` : ""
                infoLabel.text += res.final_chi_sq ? `\nFinal goodnes-of-fit (\u03c7\u00b2): ${(res.final_chi_sq).toFixed(3)}` : ""
                infoLabel.text += res.refinement_time ? `\nRefinement time in seconds: ${(res.refinement_time).toFixed(2)}` : ""
                info.open()
            }
        }
        // Button
        //////////////////////////////////////////


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


    /*
    Rectangle {
        anchors.fill: parent
        //height: parent.height
        //width: tableView.childrenRect.width

        //implicitWidth: 200

        anchors.margins: 10
        color: "transparent"
        border.width: borderWidth
        border.color: headerBorderColor


    }
    */

    Component.onCompleted: print("Duration:", Date.now() - startTime, "ms")



}


        /*


        //////////////////////////////////////////
        //////////////////////////////////////////

        Text { text: "Parameters (Analysis Tab)"; color: headerColor }

/////        ScrollView {
/////            Layout.fillWidth: true
/////            Layout.preferredHeight: rowHeight * maxRowCountToDisplay + cellSpacing * (maxRowCountToDisplay - 1)
/////            Layout.maximumHeight: rowHeight * maxRowCountToDisplay + cellSpacing * (maxRowCountToDisplay - 1)
/////            clip: true

/////            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
/////            ScrollBar.vertical.policy: ScrollBar.AsNeeded

            TableView {
                id: listView
                ///spacing: -cellSpacing

                width: 400
                height: 200


                columnSpacing: 15
                rowSpacing: 15

                clip: true
                ScrollIndicator.horizontal: ScrollIndicator { }
                ScrollIndicator.vertical: ScrollIndicator { }


                // Use python model
                model: pythonModel.fitables_list

                /-*
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
                            Layout.preferredWidth: listView.delegate.currentRowNumberColumn.width //qqq//delegate.currentRowNumberColumn.width
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                padding: cellPadding
                                text: ""
                                //text: "No."
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
                *-/

                //Rectangle { id: qqq }


                // Table row view
                delegate: Rectangle {
                    //width: parent.width
                    implicitWidth: 100//parent.width
                    implicitHeight: 20//rowHeight

                    ///height: rowHeight
                    //color: "white"
                    ///color: index % 2 ? rowBackgroundColor : alternateRowBackgroundColor
                    border.color: "red"
                    border.width: 2

                    //RowLayout {
                    //    width: parent.width
                    //    spacing: cellSpacing

                        //////////////////////////////////////////

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "________"
                    }

                        // First column: Current row number
                        Rectangle {
                            id: currentRowNumberColumn
                            ///anchors.left: parent.left
//                            width: childrenRect.width
//                            height: rowHeight
                            height: parent.height
                            width: 100
                            implicitWidth: 100
                            color: "transparent"
//                            border.color: "red"
//                            border.width: cellSpacing
                        //    color: index % 2 ? rowBackgroundColor : alternateRowBackgroundColor
                            //Layout.preferredHeight: rowHeight
                            //Layout.preferredWidth: currentRowNumberColumn.width
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                padding: cellPadding
                                text: index + 1
                            }
                        }

                        //////////////////////////////////////////

                        // Next column: name
                        Rectangle {
                            id: nameColumn
                            ///anchors.left: currentRowNumberColumn.right
//                            width: childrenRect.width
//                            height: rowHeight
                            height: parent.height
                            width: 100
                            color: "transparent"
 //                           border.color: "red"
 //                           border.width: cellSpacing
                       //    color: index % 2 ? rowBackgroundColor : alternateRowBackgroundColor
                            //Layout.preferredHeight: rowHeight
                            //Layout.fillWidth: true
                            //Layout.preferredWidth: nameColumn.width

                            Text {
                                //anchors.margins: 20
                                //padding: 20
                                anchors.verticalCenter: parent.verticalCenter
                                //padding: cellPadding
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

                        // Next column: error
                        Rectangle {
                            id: errorColumn
                            ///anchors.left: nameColumn.right
//                            width: childrenRect.width
//                            height: rowHeight
                            height: parent.height
                            width: 100
                            color: "transparent"
//                            border.color: "red"
//                            border.width: cellSpacing
                        //    color: index % 2 ? rowBackgroundColor : alternateRowBackgroundColor
                            //Layout.preferredHeight: rowHeight
                            //Layout.fillWidth: true
                            //Layout.preferredWidth: errorColumn.width
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                padding: cellPadding
                                text: pythonModel.fitables_list[index].error
                            }
                        }

                        //////////////////////////////////////////


                            //////////////////////////////////////////

                            // Next column: error
                            Rectangle {
                                id: currentRowNumberColumn2
                                ///anchors.left: errorColumn.right
 //                               width: childrenRect.width
 //                               height: rowHeight
                                height: parent.height
                                width: 100
                                color: "transparent"
 //                               border.color: "red"
 //                               border.width: cellSpacing
                            //    color: index % 2 ? rowBackgroundColor : alternateRowBackgroundColor
                                //Layout.preferredHeight: rowHeight
                                //Layout.fillWidth: true
                                //Layout.preferredWidth: errorColumn.width
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                padding: cellPadding
                                text: index + 1
                            }
                            }

                            //////////////////////////////////////////


                    //}
                }




                /-*
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
                            color: index % 2 ? rowBackgroundColor : alternateRowBackgroundColor
                            Layout.fillHeight: true
                            Layout.preferredWidth: currentRowNumberColumn.width
                            Text {
                                id: currentRowNumberColumn
                                anchors.verticalCenter: parent.verticalCenter
                                padding: cellPadding
                                text: index + 1
                            }
                        }

                        //////////////////////////////////////////

                        // Next column: name
                        Rectangle {
                            color: index % 2 ? rowBackgroundColor : alternateRowBackgroundColor
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            Layout.preferredWidth: nameColumn.width
                            Text {
                                id: nameColumn
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
                            color: index % 2 ? rowBackgroundColor : alternateRowBackgroundColor
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            Layout.preferredWidth: valueColumn.width
                            TextEdit {
                                id: valueColumn
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
                                    let obj = pythonModel.main_dict
                                    if (group && subgroup) {
                                        obj[datablock][group][subgroup][name].value = text
                                    } else {
                                        obj[datablock][name].value = text
                                    }
                                    pythonModel.main_dict = obj
                                }
                            }
                        }

                        //////////////////////////////////////////

                        // Next column: error
                        Rectangle {
                            color: index % 2 ? rowBackgroundColor : alternateRowBackgroundColor
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            Layout.preferredWidth: errorColumn.width
                            Text {
                                id: errorColumn
                                anchors.verticalCenter: parent.verticalCenter
                                padding: cellPadding
                                text: pythonModel.fitables_list[index].error
                            }
                        }

                        //////////////////////////////////////////

                        // Next column: refine
                        Rectangle {
                            color: index % 2 ? rowBackgroundColor : alternateRowBackgroundColor
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
                                    let obj = pythonModel.main_dict
                                    if (group && subgroup) {
                                        obj[datablock][group][subgroup][name].refine = checked
                                    } else {
                                        obj[datablock][name].refine = checked
                                    }
                                    pythonModel.main_dict = obj
                                }
                            }
                        }

                        //////////////////////////////////////////

                    }
                }
                  *-/










            }
/////        }

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
                            color: index % 2 ? rowBackgroundColor : alternateRowBackgroundColor
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
                                    let obj = pythonModel.main_dict
                                    obj[datablock].cell_length_a.value = text
                                    pythonModel.main_dict = obj
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
                                                let obj = pythonModel.main_dict
                                                obj[datablock].cell_length_a.refine = checked
                                                pythonModel.main_dict = obj
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        //////////////////////////////////////////

                        // Next column: Cell length b
                        Rectangle {
                            color: index % 2 ? rowBackgroundColor : alternateRowBackgroundColor
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
                                    let obj = pythonModel.main_dict
                                    obj[datablock].cell_length_b.value = text
                                    pythonModel.main_dict = obj
                                }
                            }
                        }

                        //////////////////////////////////////////

                        // Next column: Cell length c
                        Rectangle {
                            color: index % 2 ? rowBackgroundColor : alternateRowBackgroundColor
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
                                    let obj = pythonModel.main_dict
                                    obj[datablock].cell_length_c.value = text
                                    pythonModel.main_dict = obj
                                }
                            }
                        }

                        //////////////////////////////////////////

                        // Next column: Cell angle alpha
                        Rectangle {
                            color: index % 2 ? rowBackgroundColor : alternateRowBackgroundColor
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
                                    let obj = pythonModel.main_dict
                                    obj[datablock].cell_angle_alpha.value = text
                                    pythonModel.main_dict = obj
                                }
                            }
                        }

                        //////////////////////////////////////////

                        // Next column: Cell angle beta
                        Rectangle {
                            color: index % 2 ? rowBackgroundColor : alternateRowBackgroundColor
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
                                    let obj = pythonModel.main_dict
                                    obj[datablock].cell_angle_beta.value = text
                                    pythonModel.main_dict = obj
                                }
                            }
                        }

                        //////////////////////////////////////////

                        // Next column: Cell angle gamma
                        Rectangle {
                            color: index % 2 ? rowBackgroundColor : alternateRowBackgroundColor
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
                                    let obj = pythonModel.main_dict
                                    obj[datablock].cell_angle_gamma.value = text
                                    pythonModel.main_dict = obj
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
                    const res = pythonModel.refine_model()
                    infoLabel.text = `${res.refinement_message}`
                    infoLabel.text += res.num_refined_parameters ? `\nNumber of refined parameters: ${res.num_refined_parameters}` : ""
                    infoLabel.text += res.started_chi_sq ? `\nStarted goodnes-of-fit (\u03c7\u00b2): ${(res.started_chi_sq).toFixed(3)}` : ""
                    infoLabel.text += res.final_chi_sq ? `\nFinal goodnes-of-fit (\u03c7\u00b2): ${(res.final_chi_sq).toFixed(3)}` : ""
                    infoLabel.text += res.refinement_time ? `\nRefinement time in seconds: ${(res.refinement_time).toFixed(2)}` : ""
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
*/

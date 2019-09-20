import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtCharts 2.13

ApplicationWindow {
    id: window
    visible: true
    width: 1000
    height: 1000

    property string rowBackgroundColor: 'white'
    property string alternateRowBackgroundColor: '#f7f7f7'
    property string headerBackgroundColor: '#eee'
    property string rowBorderColor: '#e8e8e8'
    property string headerBorderColor: '#dedede'
    property string headerTextColor: '#666'

    property int borderWidth: 1
    property int cellWidth: 150
    property int cellHeight: 24

    property var startTime: Date.now()

    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        //////////////////////////////////////////
        // project (Text)
        Text { wrapMode: Text.Wrap; width: parent.width; text: "project: " + JSON.stringify(proxy.project); color: "blue" }
        // project (Text)
        //////////////////////////////////////////

        Item { height: 0.5*cellHeight; width: 1 }

        //////////////////////////////////////////
        // experimentalData (TableView)
        Text { text: "experimentalData (TableView)"; color: "red" }
        Rectangle { width: parent.width; height: cellHeight * proxy.experimentalData.rowCount(); border.color: headerBorderColor; Row { spacing: 20
                TableView { width: cellWidth; height: parent.parent.height; columnSpacing: 20
                    model: proxy.experimentalData
                    delegate: Text { text: display }
                }
            }}
        // experimentalData (TableView)
        //////////////////////////////////////////

        Item { height: 0.5*cellHeight; width: 1 }

        //////////////////////////////////////////
        // experimentalData (ChartView)
        Text { text: "experimentalData (ChartView)"; color: "red" }
        Rectangle { width: parent.width; height: cellHeight * 12; border.color: headerBorderColor
            ChartView { width: parent.width; height: parent.height
                LineSeries {
                    //name: mapperX.model.header(mapper.yColumn) // not updated automatically, how to fix?
                    //name: proxy.pyListOfInt2dHeader[mapperX.yColumn] // not updated automatically, how to fix?
                    VXYModelMapper{ id: mapperX; model: proxy.experimentalData; xColumn: 0; yColumn: 1 }
                }
            }
        }
        Item { height: 0.5*cellHeight; width: 1 }
        // experimentalData (ChartView)
        //////////////////////////////////////////

        Item { height: 0.5*cellHeight; width: 1 }

        //////////////////////////////////////////
        // fitables (ListView)
        Text { text: "fitables (ListView)"; color: "red" }
        Rectangle { width: parent.width; height: cellHeight * (proxy.fitables.rowCount() + 1); border.color: headerBorderColor; Row { spacing: 20
                ListView {width: cellWidth; height: parent.parent.height
                    model: proxy.fitables
                    header: Row { spacing: 20
                        Text { text: "Value" }
                        Text { text: "Error" }
                        Text { text: "Refine" }
                    }
                    delegate: Row { spacing: 20
                        TextInput { text: value; onEditingFinished: value = text }
                        TextInput { text: error; onEditingFinished: error = text }
                        CheckBox { checked: refine; onToggled: refine = checked; height: cellHeight }
                    }
                }
                ListView { width: cellWidth; height: parent.parent.height
                    model: proxy.fitables
                    header: Row { spacing: 20
                        Text { text: "Value" }
                        Text { text: "Error" }
                        Text { text: "Refine" }
                    }
                    delegate: Row { spacing: 20
                        TextInput { text: value; onEditingFinished: value = text }
                        TextInput { text: error; onEditingFinished: error = text }
                        CheckBox { checked: refine; onToggled: refine = checked; height: cellHeight }
                    }
                }
            }}
        // fitables (ListView)
        //////////////////////////////////////////

        //////////////////////////////////////////
        // Button
        Button {
            text: 'Random change of experimental data'
            onClicked: {
                //print(JSON.stringify(proxy.project))
                //print(proxy.experimentalData.rowCount())
                proxy.updateExperimentalDataModelRandomly()
            }
        }
        // Button
        //////////////////////////////////////////

    }

    // Profiling
    Component.onCompleted: print("Duration:", Date.now() - startTime, "ms")
}


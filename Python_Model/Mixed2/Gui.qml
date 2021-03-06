import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtCharts 2.13

ApplicationWindow {
    id: window
    visible: true
    width: 700
    height: 1000

    property string rowBackgroundColor: 'white'
    property string alternateRowBackgroundColor: '#f7f7f7'
    property string headerBackgroundColor: '#eee'
    property string rowBorderColor: '#e8e8e8'
    property string headerBorderColor: '#dedede'
    property string headerTextColor: '#666'

    property int borderWidth: 1
    property int cellWidth: 150
    property int cellHeight: 16

    property var startTime: Date.now()

    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        //////////////////////////////////////////
        // pyString (TextInput)
        Label { text: "pyString (TextInput): " + proxy.pyString; color: "red" }
        Rectangle {width: parent.width; height: cellHeight; border.color: headerBorderColor; Row { spacing: 20
                TextInput { text: proxy.pyString; onEditingFinished: proxy.pyString = text }
                TextInput { text: proxy.pyString; onEditingFinished: proxy.pyString = text }
            }}
        Item { height: 0.5*cellHeight; width: 1 }
        // pyString (TextInput)
        //////////////////////////////////////////

        //////////////////////////////////////////
        // pyListOfInt (ListView)
        Label { text: "pyListOfInt (ListView): " + JSON.stringify(proxy.pyListOfInt); color: "red" }
        Rectangle { width: parent.width; height: cellHeight * proxy.pyListOfInt.length; border.color: headerBorderColor; Row { spacing: 20
                ListView { width: cellWidth; height: parent.parent.height
                    model: proxy.pyListOfInt
                    delegate: TextInput { text: modelData; onEditingFinished: modelData = text }
                }
                ListView { width: cellWidth; height: parent.parent.height
                    model: proxy.pyListOfInt
                    delegate: TextInput { text: modelData; onEditingFinished: modelData = text }
                }
                ListView { width: cellWidth; height: parent.parent.height
                    model: proxy.pyListOfInt
                    delegate: TextInput { text: modelData; onEditingFinished: { let obj = proxy.pyListOfInt; obj[index] = text; proxy.pyListOfInt = obj } }
                }
                ListView { width: cellWidth; height: parent.parent.height
                    model: proxy.pyListOfInt
                    delegate: TextInput { text: modelData; onEditingFinished: { let obj = proxy.pyListOfInt; obj[index] = text; proxy.pyListOfInt = obj } }
                }
            }}
        Item { height: 0.5*cellHeight; width: 1 }
        // pyListOfInt (ListView)
        //////////////////////////////////////////

        //////////////////////////////////////////
        // qAbstractTable (TableView)
        Label { text: "qAbstractTable (TableView): " + JSON.stringify(proxy.qAbstractTable.entireData()); color: "red" } // not updated automatically, how to fix?
        Rectangle { width: parent.width; height: cellHeight * proxy.qAbstractTable.rowCount(); border.color: headerBorderColor; Row { spacing: 200
                TableView { width: cellWidth; height: parent.parent.height; columnSpacing: 20
                    model: proxy.qAbstractTable
                    delegate: TextInput { text: dataRole;  onEditingFinished: dataRole = text }
                }
                TableView { width: cellWidth; height: parent.parent.height; columnSpacing: 20
                    model: proxy.qAbstractTable
                    delegate: TextInput { text: dataRole;  onEditingFinished: dataRole = text }
                }
            }}
        // qAbstractTable (TableView)
        //////////////////////////////////////////

        //////////////////////////////////////////
        // qAbstractTable (ChartView)
        Rectangle { width: parent.width; height: cellHeight * 12; border.color: headerBorderColor
            ChartView { width: parent.width; height: parent.height
                LineSeries {
                    name: mapper.model.header(mapper.yColumn) // not updated automatically, how to fix?
                    VXYModelMapper{ id: mapper; model: proxy.qAbstractTable; xColumn: 0; yColumn: 1 }
                }
            }
        }
        Item { height: 0.5*cellHeight; width: 1 }
        // qAbstractTable (ChartView)
        //////////////////////////////////////////

        //////////////////////////////////////////
        // pyListOfInt2d (TableView)
        // doesn't work
        Label { text: "pyListOfInt2d (TableView): " + JSON.stringify(proxy.pyListOfInt2d); color: "red" }
        Rectangle { width: parent.width; height: cellHeight * proxy.pyListOfInt2d.length; border.color: headerBorderColor; Row { spacing: 200
                TableView { width: cellWidth; height: parent.parent.height; columnSpacing: 20
                    model: proxy.pyListOfInt2d
                    delegate: TextInput { text: proxy.pyListOfInt2d[row][column] }
                }
                TableView { width: cellWidth; height: parent.parent.height; columnSpacing: 20
                    model: proxy.pyListOfInt2d
                    delegate: TextInput { text: modelData[column] }
                }
            }}
        // pyListOfInt2d (TableView)
        //////////////////////////////////////////

        //////////////////////////////////////////
        // pyListOfInt2d (ListView)
        // doesn't work
        Label { text: "pyListOfInt2d (ListView): " + JSON.stringify(proxy.pyListOfInt2d); color: "red" }
        Rectangle { width: parent.width; height: cellHeight * proxy.pyListOfInt2d.length; border.color: headerBorderColor; Row { spacing: 200
                ListView { width: cellWidth; height: parent.parent.height
                    model: proxy.pyListOfInt2d
                    delegate: TextInput { text: proxy.pyListOfInt2d[index][0] }
                }
            }}
        // pyListOfInt2d (ListView)
        //////////////////////////////////////////

        //////////////////////////////////////////
        // pyDict (TextInput)
        Label { text: "pyDict (TextInput): " + JSON.stringify(proxy.pyDict); color: "red" }
        Rectangle { width: parent.width; height: cellHeight; border.color: headerBorderColor; Row { spacing: 20
                // onEditingFinished doesn't work, if you try to pass back just a single item of the dict
                TextInput { text: proxy.pyDict.a; onEditingFinished: proxy.pyDict.a = text }
                TextInput { text: proxy.pyDict.a; onEditingFinished: proxy.pyDict.a = text }
                TextInput { text: proxy.pyDict.c.x; onEditingFinished: proxy.pyDict.c.x = text }
                TextInput { text: proxy.pyDict.c.x; onEditingFinished: proxy.pyDict.c.x = text }
                TextInput { text: proxy.pyDict.d[0]; onEditingFinished: proxy.pyDict.d[0] = text }
                TextInput { text: proxy.pyDict.d[0]; onEditingFinished: proxy.pyDict.d[0] = text }
                // onEditingFinished could work, if you pass back a copy of the whole dict
                TextInput { text: proxy.pyDict.d[0]; onEditingFinished: { let obj = proxy.pyDict; obj.d[0] = text; proxy.pyDict = obj } }
                TextInput { text: proxy.pyDict.d[0]; onEditingFinished: { let obj = proxy.pyDict; obj.d[0] = text; proxy.pyDict = obj } }
            }}
        Item { height: 0.5*cellHeight; width: 1 }
        // pyDict (TextInput)
        //////////////////////////////////////////

        //////////////////////////////////////////
        // qAbstractList (ListView)
        Label { text: "qAbstractList (ListView): " + JSON.stringify(proxy.qAbstractList.entireData()); color: "red" } // not updated automatically, how to fix?
        Rectangle { width: parent.width; height: cellHeight * proxy.qAbstractList.rowCount(); border.color: headerBorderColor; Row { spacing: 200
                ListView { width: cellWidth; height: parent.parent.height
                    model: proxy.qAbstractList
                    delegate: Row { spacing: 20
                        TextInput { text: nameRole; onEditingFinished: nameRole = text }
                        TextInput { text: valueRole; onEditingFinished: valueRole = text }
                        CheckBox { checked: refineRole; onToggled: refineRole = checked; height: cellHeight }
                    }
                }
                ListView { width: cellWidth; height: parent.parent.height
                    model: proxy.qAbstractList
                    delegate: Row { spacing: 20
                        TextInput { text: nameRole; onEditingFinished: nameRole = text }
                        TextInput { text: valueRole; onEditingFinished: valueRole = text }
                        CheckBox { checked: refineRole; onToggled: refineRole = checked; height: cellHeight }
                    }
                }
            }}
        Item { height: 0.5*cellHeight; width: 1 }
        // qAbstractList (ListView)
        //////////////////////////////////////////

        //////////////////////////////////////////
        // pyListOfDict (ListView)
        Label { text: "pyListOfDict (ListView): " + JSON.stringify(proxy.pyListOfDict); color: "red" }
        Rectangle { width: parent.width; height: cellHeight * proxy.pyListOfDict.length; border.color: headerBorderColor; Row { spacing: 200
                ListView { width: cellWidth; height: parent.parent.height
                    model: proxy.pyListOfDict
                    delegate: Row { spacing: 20
                        TextInput { text: modelData.a; onEditingFinished: modelData.a = text }
                        TextInput { text: modelData.b; onEditingFinished: proxy.pyListOfDict.b = text }
                        CheckBox { checked: modelData.c; onToggled: proxy.pyListOfDict.c = checked; height: cellHeight }
                    }
                }
                ListView { width: cellWidth; height: parent.parent.height
                    model: proxy.pyListOfDict
                    delegate: Row { spacing: 20
                        TextInput { text: modelData.a; onEditingFinished: modelData.a = text }
                        TextInput { text: modelData.b; onEditingFinished: proxy.pyListOfDict.b = text }
                        CheckBox { checked: modelData.c; onToggled: proxy.pyListOfDict.c = checked; height: cellHeight }
                    }
                }
            }}
        Item { height: 0.5*cellHeight; width: 1 }
        // pyListOfDict (ListView)
        //////////////////////////////////////////


        //////////////////////////////////////////
        // Button
        Button {
            text: 'Random change of both ListView, ChartView and TableView'
            onClicked: proxy.randomChange()
        }
        // Button
        //////////////////////////////////////////
    }

    // Profiling
    Component.onCompleted: print("Duration:", Date.now() - startTime, "ms")
}


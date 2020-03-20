import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
//import QtCharts 2.3

import AsQuick.Globals 1.0 as Globals
import AsQuick.Controls 1.0

ApplicationWindow {


    /*
    ChartView {
        id: chart
        title: "Top-5 car brand shares in Finland"
        anchors.fill: parent
        legend.alignment: Qt.AlignBottom
        //antialiasing: true

        PieSeries {
            id: pieSeries
            PieSlice { label: "Volkswagen"; value: 13.5 }
            PieSlice { label: "Toyota"; value: 10.9 }
            PieSlice { label: "Ford"; value: 8.6 }
            PieSlice { label: "Skoda"; value: 8.2 }
            PieSlice { label: "Volvo"; value: 6.8 }
        }
    }*/



    header: ToolBar {

        Row {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 15

            spacing: 20

            ComboBox {
                id: countrySelector

                anchors.verticalCenter: parent.verticalCenter

                Material.elevation: 1

                model: [ { name: "Denmark" } ]

                textRole: "name"
                onCurrentIndexChanged: {
                    //currentCountryIndex = model[currentIndex].index
                   // updateCharts()
                }
            }

            Row {
                id: dataSelector

                anchors.verticalCenter: parent.verticalCenter

                RadioButton {
                    text: qsTr("Total")
                   // checked: showTotalCases
                    onClicked: {
                       // showTotalCases = checked
                        //updateCharts()
                    }
                }
                RadioButton {
                    text: qsTr("Daily New")
                    //checked: !showTotalCases
                    onClicked: {
                        //showTotalCases = !checked
                        //updateCharts()
                    }
                }
            }

        }

        Row {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 15

            spacing: 20

            Row {
                id: themeSelector
                anchors.verticalCenter: parent.verticalCenter

                RadioButton {
                    text: qsTr("Light")
                    checked: Globals.Color.theme === Material.Light
                    onClicked: Globals.Color.theme = Material.Light
                }
                RadioButton {
                    text: qsTr("Dark")
                    checked: Globals.Color.theme === Material.Dark
                    onClicked: Globals.Color.theme = Material.Dark
                }
            }
        }

    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"

        /*
        ChartView {
            id: chart
            title: "Top-5 car brand shares in Finland"
            anchors.fill: parent
            legend.alignment: Qt.AlignBottom
            antialiasing: true

            PieSeries {
                id: pieSeries
                PieSlice { label: "Volkswagen"; value: 13.5 }
                PieSlice { label: "Toyota"; value: 10.9 }
                PieSlice { label: "Ford"; value: 8.6 }
                PieSlice { label: "Skoda"; value: 8.2 }
                PieSlice { label: "Volvo"; value: 6.8 }
            }
        }
        */

        Text {
            text: "WEEEEEEEEEE"
            font.pixelSize: 50
            color: "coral"
            anchors.centerIn: parent
            RotationAnimator on rotation {
                running: true
                loops: Animation.Infinite
                from: 0
                to: 360
                duration: 700
            }
        }
    }
}

import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
//import QtQuick.Controls.impl 2.12
import QtQuick.Controls.Material 2.12

//import Controls 1.0 as GenericControls1
//import Controls 2.0 as GenericControls2

ApplicationWindow {
    id: window
    visible: true
    width: 800
    height: 600

    //color: Material.color(palette.window)

    SystemPalette { id: myPalette; colorGroup: SystemPalette.Active }

    Column {
        anchors.centerIn: parent
        spacing: 20

        Button {
            text: "Preferences"
            onClicked: dialog.open()
        }

        Dialog {
            id: dialog
            title: "Preferences"

            visible: true

            //parent: Overlay.overlay
            anchors.centerIn: parent

            standardButtons: Dialog.Save | Dialog.Cancel

            contentItem: Rectangle {
                id: content
                color: "transparent"
                //color: Material.backgroundColor //"transparent"
                border.color: Material.backgroundColor
                height: childrenRect.height
                implicitHeight: childrenRect.height

                Column {
                    //spacing: 20
                    //height: childrenRect.height
                    //implicitHeight: childrenRect.height

                    TabBar {
                        id: bar

                        TabButton {
                            id: tabButton
                            text: "General"
                            width: implicitWidth + 20
                        }
                        TabButton {
                            text: "Appearance"
                            width: implicitWidth + 20
                        }
                        TabButton {
                            text: "Debugging"
                            width: implicitWidth + 20
                        }
                    }

                    SwipeView {
                        id: view

                        implicitHeight: 300

                        width: bar.width
                        padding: 20
                        rightPadding: -20
                        clip: true

                        currentIndex: bar.currentIndex

                        Item {
                            id: firstPage

                            Column {
                                spacing: 15

                                Column {
                                    Label {
                                        text: "Guides"
                                        font.bold: true
                                    }
                                    Column {
                                        CheckBox { text: qsTr("Show Animated Intro") }
                                        CheckBox { text: qsTr("Show User Guides"); checked: true; topPadding: 0 }
                                    }
                                }

                                Column {
                                    Label {
                                        enabled: false
                                        font.bold: true
                                        text: "Update"
                                    }
                                    Column {
                                        CheckBox {
                                            enabled: false
                                            text: qsTr("Automatically check for updates")
                                        }
                                    }
                                }



                            }
                        }

                        Item {
                            id: secondPage

                            Column {

                                Label {
                                    text: "Theme"
                                    font.bold: true
                                }

                                Column {
                                    id: themeButtons

                                    RadioButton { text: qsTr("Light") }
                                    RadioButton { text: qsTr("Dark"); checked: true; topPadding: 0 }
                                    RadioButton { text: qsTr("System"); topPadding: 0 }
                                }

                                ButtonGroup {
                                    buttons: themeButtons.children

                                    onClicked: {
                                        const theme = button.text
                                        if (theme === "Light")
                                            window.Material.theme = Material.Light
                                        else if (theme === "Dark")
                                            window.Material.theme = Material.Dark
                                        else if (theme === "System")
                                            window.Material.theme = Material.System
                                        else
                                            print("ERROR: Unknown theme", theme)
                                    }
                                }
                            }

                        }

                        Item {
                            id: thirdPage
                        }
                    }




            }


        }














        }




    }

}

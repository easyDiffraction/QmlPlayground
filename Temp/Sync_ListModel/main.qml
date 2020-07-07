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
        // EDITABLE TABLE SYNCED WITH PYTHON MODEL
        //////////////////////////////////////////

        Text { text: "EDITABLE TABLE BASED ON PYTHON MODEL"; color: "darkblue" }

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

                // Use python model AtomSiteModel
                model: atomSiteModel

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

                        // Next column: Atom site label
                        Rectangle {
                            color: index % 2 ? rowColor : alternateRowColor
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            TextEdit {
                                anchors.verticalCenter: parent.verticalCenter
                                padding: cellPadding
                                text: model.label
                                onEditingFinished: atomSiteModel.modify(index, text, model.x, model.y, model.z, model.refine)
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
                                text: model.x
                                onEditingFinished: atomSiteModel.modify(index, model.label, text, model.y, model.z, model.refine)
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
                                text: model.y
                                onEditingFinished: atomSiteModel.modify(index, model.label, model.x, text, model.z, model.refine)
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
                                text: model.z
                                onEditingFinished: atomSiteModel.modify(index, model.label, model.x, model.y, text, model.refine)
                            }
                        }

                        // Next column: Atom site fract z
                        Rectangle {
                            color: index % 2 ? rowColor : alternateRowColor
                            Layout.preferredHeight: rowHeight
                            Layout.preferredWidth: rowHeight
                            CheckBox {
                                checked: model.refine
                                onToggled: atomSiteModel.modify(index, model.label, model.x, model.y, model.z, checked)
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
                text: "Change atom site No. 2"
                onClicked: atomSiteModel.modifyAtomSiteNo2()
            }

            Button {
                Layout.fillWidth: true
                text: "Add default atom site"
                onClicked: atomSiteModel.append('H', 0.0, 0.0, 0.0, false)
            }

            Button {
                Layout.fillWidth: true
                text: "Remove last stom site"
                onClicked: atomSiteModel.remove(listView.model.rowCount() - 1)
            }
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
                model: atomSiteModel

                delegate: RowLayout {
                    enabled: false

                    Text { text: model.label }
                    Text { text: model.x }
                    Text { text: model.y }
                    Text { text: model.z }
                    CheckBox { checked: model.refine }
                }
            }
        }

    }
}

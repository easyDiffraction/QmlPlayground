import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtGraphicalEffects 1.12

Dialog {
    property int animationDuration: 500
    property real initialDimmedAreaTransparency: 0.5
    property string dimmedAreaColor: "black"
    property string dialogBackgroundColor: control.palette.window //"#efefef"
    property string headerBackgroundColor: "#ddd"
    property string headerBorderColor: "#ccc"

    property int headerHeight: 60
    property int borderThickness: 1
    property int headerPadding: 12

    property var headerFontFamily: control.font.family
    property var headerFontPointSize: control.font.pointSize + 3

    id: control

    visible: false
    parent: Overlay.overlay
    anchors.centerIn: parent

    modal: true
    dim: false  // dimming is implemented via 'hiddenPopup'

    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    // Dialog background
    /*
    background: Rectangle {
        color: control.palette.window //dialogBackgroundColor
    }
    */

    // Dialog header
    header: Label {
        visible: control.title
        padding: headerPadding
        rightPadding: padding + exitButton.width
        bottomPadding: padding + headerBorder.height
        background: Rectangle {
            anchors.fill: parent
            color: palette.window
            //color: headerBackgroundColor  // control.palette.window
        }
        elide: Label.ElideRight
        font.bold: true
        text: control.title

        // Exit button
        Button {
            id: exitButton
            anchors.right: parent.right
            height: parent.height - headerBorder.height
            width: height
            flat: true
            text: "x" // cross
            onClicked: dialog.close()
        }

        // Border at the headers' bottom
        Rectangle {
            id: headerBorder
            anchors.bottom: parent.bottom
            width: parent.width
            height: borderThickness
            color: headerBorderColor
        }
    }

    // Enter dialog animation
    enter: Transition {
        SequentialAnimation {

            PropertyAction { target: hiddenPopup; property: "visible"; value: true }

            ParallelAnimation {
                NumberAnimation { target: hiddenPopup; easing.type: Easing.OutExpo; property: "dimmedAreaTransparency";
                    from: 0.0; to: initialDimmedAreaTransparency; duration: animationDuration }

                NumberAnimation { target: control; easing.type: Easing.OutBack; property: "scale";
                    from: 0.0; to: 1.0; duration: animationDuration }
            }
        }
    }

    // Exit dialog animation
    exit: Transition {
        SequentialAnimation {

            ParallelAnimation {
                NumberAnimation { target: control; easing.type: Easing.InBack; property: "scale";
                    from: 1.0; to: 0.0; duration: animationDuration }

                NumberAnimation { target: hiddenPopup; easing.type: Easing.InExpo; property: "dimmedAreaTransparency";
                    from: initialDimmedAreaTransparency; to: 0.0; duration: animationDuration }
            }

            PropertyAction { target: hiddenPopup; property: "visible"; value: false }
        }
    }

    // Exit animation of the out-of-dialog dimmed area transparency is implemented via
    // additional hidden Popup element 'hiddenPopup'. It is needed to sync the scale
    // animation of the main dialog and transparency animation on the out-of-dialog dimmed
    // area created by the hiddenPopup element.
    Popup {
        id: hiddenPopup

        z: -1       // this popup element must be placed
        width: 0    // below the main dialog 'control' and
        height: 0   // thus remain invisible

        parent: Overlay.overlay
        modal: true
        closePolicy: Popup.NoAutoClose

        // Out-of-dialog dimmed area
        property real dimmedAreaTransparency
        Overlay.modal: Rectangle {
            anchors.fill: parent
            color: Color.transparent(dimmedAreaColor, dimmedAreaTransparency)
        }

        // Reset show preferences global variable
        //onClosed: Generic.Variables.showPreferences = 0
    }




}



/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
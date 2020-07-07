import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Material.impl 2.12
import QtGraphicalEffects 1.12
import QtDataVisualization 1.12

import easyInterface.Globals 1.0 as InterfaceGlobals

//Rectangle {
//    id: chartContainer

//    default property alias contentData: chart.data

//    color: InterfaceGlobals.Color.mainAreaBackground
Scatter3D {
    id: chart

    property real xRotationInitial: -60.0
    property real yRotationInitial: 15.0
    property real zoomLevelInitial: 200.0
    property real xTargetInitial: 0.0
    property real yTargetInitial: 0.0
    property real zTargetInitial: 0.0

    property int animationDuration: 1000

    property color windowBackgroundColor: InterfaceGlobals.Color.mainAreaBackground

    //width: parent.width //Math.min(parent.width, parent.height)
    //height: parent.height //Math.min(parent.width, parent.height)
    //anchors.centerIn: parent

    // Camera view settings
    orthoProjection: false
    scene.activeCamera.xRotation: xRotationInitial
    scene.activeCamera.yRotation: yRotationInitial
    scene.activeCamera.zoomLevel: zoomLevelInitial
    scene.activeCamera.target.x: xTargetInitial
    scene.activeCamera.target.y: yTargetInitial
    scene.activeCamera.target.z: zTargetInitial

    // Geometrical settings
    //horizontalAspectRatio: 0.0
    aspectRatio: 1.0

    // Interactivity
    selectionMode: AbstractGraph3D.SelectionNone // Left mouse button will be used for "reset view" coded below

    // Visualization settings
    theme: Theme3D {
        type: Theme3D.ThemeUserDefined
        ambientLightStrength: 0.5
        windowColor: windowBackgroundColor //"orange"//InterfaceGlobals.Color.mainAreaBackground //chartContainer.color
        backgroundEnabled: false
        gridEnabled: false
    }
    shadowQuality: AbstractGraph3D.ShadowQualityNone // AbstractGraph3D.ShadowQualitySoftHigh

    // Axes
    axisX: ValueAxis3D {
        labelFormat: ""
    }
    axisY: ValueAxis3D {
        labelFormat: ""
    }
    axisZ: ValueAxis3D {
        labelFormat: ""
    }

    //}//}

    // Reset view with animation: Override default left mouse button
    //MouseArea {
    //anchors.fill: parent.parent //chartContainer
    //acceptedButtons: Qt.LeftButton
    //onClicked: print("aaaaaaaa") //animo.restart()
    //}
    onChildrenChanged: print("onChildrenChanged")


    /*

    ParallelAnimation {
        id: animo
        NumberAnimation {
            easing.type: Easing.OutCubic
            target: chart
            property: "scene.activeCamera.target.x"
            to: chart.xTargetInitial
            duration: chart.animationDuration
        }
        NumberAnimation {
            easing.type: Easing.OutCubic
            target: chart
            property: "scene.activeCamera.target.y"
            to: chart.yTargetInitial
            duration: chart.animationDuration
        }
        NumberAnimation {
            easing.type: Easing.OutCubic
            target: chart
            property: "scene.activeCamera.target.z"
            to: chart.zTargetInitial
            duration: chart.animationDuration
        }
        NumberAnimation {
            easing.type: Easing.OutCubic
            target: chart
            property: "scene.activeCamera.xRotation"
            to: chart.xRotationInitial
            duration: chart.animationDuration
        }
        NumberAnimation {
            easing.type: Easing.OutCubic
            target: chart
            property: "scene.activeCamera.yRotation"
            to: chart.yRotationInitial
            duration: chart.animationDuration
        }
        NumberAnimation {
            easing.type: Easing.OutCubic
            target: chart
            property: "scene.activeCamera.zoomLevel"
            to: chart.zoomLevelInitial
            duration: chart.animationDuration
        }
    }
    */
} //}

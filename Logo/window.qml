import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14

Item {

  ///////////////////////////////////////////////////////////////////////////////////////
  // Public interface
  ///////////////////////////////////////////////////////////////////////////////////////

  // Sizes
  property int logoSize: 200
  property real largeSpotSize: logoSize * 0.25
  property real mediumSpotSize: logoSize * 0.2
  property real smallSpotSize: logoSize * 0.165

  // Border
  property real borderWidth: logoSize * 0.03

  // Asymmetry
  property int logoRotationAngle: -11
  property real smallSpotOffsetAngle: 60

  property real mediumSpotOffsetDist: smallSpotSize * 0.075 * 0
  property real smallSpotOffsetDist: smallSpotSize * -0.1 * 0

  // Colors
  property string logoLightFillColor: '#00aaed'
  property string logoDarkFillColor: '#0091ca'
  property string largeSpotFillColor: '#ffffff'
  property string mediumSpotFillColor: '#d4f3ff'
  property string smallSpotFillColor: '#b3e9ff'

  property string logoLightBorderColor: '#98e2ff'
  property string logoDarkBorderColor: '#4ec1ef'
  property string largeSpotBorderColor: '#98e2ff'
  property string mediumSpotBorderColor: '#63d3ff'
  property string smallSpotBorderColor: '#4ec1ef'

  // Animation
  property var animationEasingType: Easing.OutExpo
  property int animationDuration: 1000
  property int delayDuration: 1000

  ///////////////////////////////////////////////////////////////////////////////////////
  // Root properties
  ///////////////////////////////////////////////////////////////////////////////////////
  id: root

  width: logoSize
  height: width

  ///////////////////////////////////////////////////////////////////////////////////////
  // DRAW LOGO ELEMENTS
  ///////////////////////////////////////////////////////////////////////////////////////
  Item {
    id: logoContainer

    transform: Rotation {
      origin.x: logoSize * 0.5
      origin.y: logoSize * 0.5
      angle: logoRotationAngle
    }

    // Logo border
    Rectangle {
      id: logoBorder
      width: logoSize
      height: width
      radius: width
      gradient: Gradient {
        GradientStop {
          position: 0.0
          color: logoLightBorderColor
        }
        GradientStop {
          position: 1.0
          color: logoDarkBorderColor
        }
      }
    }
    // Logo circle
    Rectangle {
      id: logoCircle
      x: borderWidth
      y: x
      width: logoSize - 2 * x
      height: width
      radius: width
      gradient: Gradient {
        GradientStop {
          position: 0.0
          color: logoLightFillColor
        }
        GradientStop {
          position: 1.0
          color: logoDarkFillColor
        }
      }
    }
  }

  Item {
    id: spotsContainer

    transform: Rotation {
      id: spotsRotation
      origin.x: logoSize * 0.5
      origin.y: logoSize * 0.5
      angle: logoRotationAngle
    }

    // Top right small spot
    Rectangle {
      id: topRightSmallSpot
      x: topRightSmallSpotX
      y: topRightSmallSpotY
      width: smallSpotSize
      color: smallSpotFillColor
      border.color: smallSpotBorderColor
      border.width: borderWidth
      height: width
      radius: width
    }
    // Bottom right small spot
    Rectangle {
      id: bottomRightSmallSpot
      x: bottomRightSmallSpotX
      y: bottomRightSmallSpotY
      width: smallSpotSize
      color: smallSpotFillColor
      border.color: smallSpotBorderColor
      border.width: borderWidth
      height: width
      radius: width
    }
    // Bottom left small spot
    Rectangle {
      id: bottomLeftSmallSpot
      x: bottomLeftSmallSpotX
      y: bottomLeftSmallSpotY
      width: smallSpotSize
      color: smallSpotFillColor
      border.color: smallSpotBorderColor
      border.width: borderWidth
      height: width
      radius: width
    }
    // Top left small spot
    Rectangle {
      id: topLeftSmallSpot
      x: topLeftSmallSpotX
      y: topLeftSmallSpotY
      width: smallSpotSize
      color: smallSpotFillColor
      border.color: smallSpotBorderColor
      border.width: borderWidth
      height: width
      radius: width
    }
    // Top medium spot
    Rectangle {
      id: topMediumSpot
      x: topMediumSpotX
      y: topMediumSpotY
      width: mediumSpotSize
      color: mediumSpotFillColor
      border.color: mediumSpotBorderColor
      border.width: borderWidth
      height: width
      radius: width
    }
    // Bottom medium spot
    Rectangle {
      id: bottomMediumSpot
      x: bottomMediumSpotX
      y: bottomMediumSpotY
      width: mediumSpotSize
      color: mediumSpotFillColor
      border.color: mediumSpotBorderColor
      border.width: borderWidth
      height: width
      radius: width
    }
    // Central large spot (direct beam)
    Rectangle {
      id: centralLargeSpot
      x: centralLargeSpotX
      y: centralLargeSpotY
      width: largeSpotSize
      color: largeSpotFillColor
      border.color: largeSpotBorderColor
      border.width: borderWidth
      height: width
      radius: width
    }
  }

  MouseArea {
    anchors.fill: parent
    onClicked: animo.restart()
  }

  ///////////////////////////////////////////////////////////////////////////////////////
  // ANIMATION
  ///////////////////////////////////////////////////////////////////////////////////////

  // Sequential Animation
  SequentialAnimation {
    id: animo

    // HIDE ANIMATION

    // Move medium and small spots
    ParallelAnimation {
      // Medium spots
      PropertyAnimation {
        target: topMediumSpot
        property: "y"
        from: target.y
        to: logoSize * 0.5 - target.width * 0.5
        duration: animationDuration
        easing.type: animationEasingType
      }
      PropertyAnimation {
        target: topMediumSpot
        property: "x"
        from: target.x
        to: logoSize * 0.5 - target.width * 0.5
        duration: animationDuration
        easing.type: animationEasingType
      }
      PropertyAnimation {
        target: bottomMediumSpot
        property: "y"
        from: target.y
        to: logoSize * 0.5 - target.width * 0.5
        duration: animationDuration
        easing.type: animationEasingType
      }
      PropertyAnimation {
        target: bottomMediumSpot
        property: "x"
        from: target.x
        to: logoSize * 0.5 - target.width * 0.5
        duration: animationDuration
        easing.type: animationEasingType
      }
      // Small spots
      PropertyAnimation {
        target: topRightSmallSpot
        property: "y"
        from: target.y
        to: logoSize * 0.5 - target.width * 0.5
        duration: animationDuration
        easing.type: animationEasingType
      }
      PropertyAnimation {
        target: topRightSmallSpot
        property: "x"
        from: target.x
        to: logoSize * 0.5 - target.width * 0.5
        duration: animationDuration
        easing.type: animationEasingType
      }
      PropertyAnimation {
        target: bottomRightSmallSpot
        property: "y"
        from: target.y
        to: logoSize * 0.5 - target.width * 0.5
        duration: animationDuration
        easing.type: animationEasingType
      }
      PropertyAnimation {
        target: bottomRightSmallSpot
        property: "x"
        from: target.x
        to: logoSize * 0.5 - target.width * 0.5
        duration: animationDuration
        easing.type: animationEasingType
      }
      PropertyAnimation {
        target: bottomLeftSmallSpot
        property: "y"
        from: target.y
        to: logoSize * 0.5 - target.width * 0.5
        duration: animationDuration
        easing.type: animationEasingType
      }
      PropertyAnimation {
        target: bottomLeftSmallSpot
        property: "x"
        from: target.x
        to: logoSize * 0.5 - target.width * 0.5
        duration: animationDuration
        easing.type: animationEasingType
      }
      PropertyAnimation {
        target: topLeftSmallSpot
        property: "y"
        from: target.y
        to: logoSize * 0.5 - target.width * 0.5
        duration: animationDuration
        easing.type: animationEasingType
      }
      PropertyAnimation {
        target: topLeftSmallSpot
        property: "x"
        from: target.x
        to: logoSize * 0.5 - target.width * 0.5
        duration: animationDuration
        easing.type: animationEasingType
      }
    }

    // Hide
    ParallelAnimation {
      // Large spot
      PropertyAnimation {
        target: centralLargeSpot
        property: "width"
        to: 0
        duration: animationDuration
        easing.type: animationEasingType
      }
      PropertyAnimation {
        target: centralLargeSpot
        property: "x"
        to: logoSize * 0.5
        duration: animationDuration
        easing.type: animationEasingType
      }
      PropertyAnimation {
        target: centralLargeSpot
        property: "y"
        to: logoSize * 0.5
        duration: animationDuration
        easing.type: animationEasingType
      }
      PropertyAnimation {
        target: centralLargeSpot
        property: "opacity"
        to: 0
        duration: animationDuration
        easing.type: animationEasingType
      }
      // Medium spots
      PropertyAction {
        target: topMediumSpot
        property: "opacity"
        value: 0
      }
      PropertyAction {
        target: bottomMediumSpot
        property: "opacity"
        value: 0
      }
      // Small spots
      PropertyAction {
        target: topRightSmallSpot
        property: "opacity"
        value: 0
      }
      PropertyAction {
        target: bottomRightSmallSpot
        property: "opacity"
        value: 0
      }
      PropertyAction {
        target: bottomLeftSmallSpot
        property: "opacity"
        value: 0
      }
      PropertyAction {
        target: topLeftSmallSpot
        property: "opacity"
        value: 0
      }
    }

    // SHOW ANIMATION
    PauseAnimation {
      duration: delayDuration
    }

    // Reset logo rotation angle
    PropertyAction {
      target: spotsRotation
      property: "angle"
      value: 0
    }

    // Show large spot
    ParallelAnimation {
      PropertyAnimation {
        target: centralLargeSpot
        property: "width"
        to: largeSpotSize
        duration: animationDuration
        easing.type: animationEasingType
      }
      PropertyAnimation {
        target: centralLargeSpot
        property: "x"
        to: logoSize * 0.5 - largeSpotSize * 0.5
        duration: animationDuration
        easing.type: animationEasingType
      }
      PropertyAnimation {
        target: centralLargeSpot
        property: "y"
        to: logoSize * 0.5 - largeSpotSize * 0.5
        duration: animationDuration
        easing.type: animationEasingType
      }
      PropertyAnimation {
        target: centralLargeSpot
        property: "opacity"
        to: 1
        duration: animationDuration
        easing.type: animationEasingType
      }
    }

    // Restore medium and small spots opacity
    ParallelAnimation {
      // Medium spots
      PropertyAction {
        target: topMediumSpot
        property: "opacity"
        value: 1
      }
      PropertyAction {
        target: bottomMediumSpot
        property: "opacity"
        value: 1
      }
      // Small spots
      PropertyAction {
        target: topRightSmallSpot
        property: "opacity"
        value: 1
      }
      PropertyAction {
        target: bottomRightSmallSpot
        property: "opacity"
        value: 1
      }
      PropertyAction {
        target: bottomLeftSmallSpot
        property: "opacity"
        value: 1
      }
      PropertyAction {
        target: topLeftSmallSpot
        property: "opacity"
        value: 1
      }
    }

    // Show Medium spots
    ParallelAnimation {
      PropertyAnimation {
        target: topMediumSpot
        property: "y"
        from: logoSize * 0.5 - target.width * 0.5
        to: target.y
        duration: animationDuration
        easing.type: animationEasingType
      }
      PropertyAnimation {
        target: topMediumSpot
        property: "x"
        from: logoSize * 0.5 - target.width * 0.5
        to: target.x
        duration: animationDuration
        easing.type: animationEasingType
      }
      PropertyAnimation {
        target: bottomMediumSpot
        property: "y"
        from: logoSize * 0.5 - target.width * 0.5
        to: target.y
        duration: animationDuration
        easing.type: animationEasingType
      }
      PropertyAnimation {
        target: bottomMediumSpot
        property: "x"
        from: logoSize * 0.5 - target.width * 0.5
        to: target.x
        duration: animationDuration
        easing.type: animationEasingType
      }
    }

    // Show small spots
    ParallelAnimation {
      PropertyAnimation {
        target: topRightSmallSpot
        property: "y"
        from: logoSize * 0.5 - target.width * 0.5
        to: target.y
        duration: animationDuration
        easing.type: animationEasingType
      }
      PropertyAnimation {
        target: topRightSmallSpot
        property: "x"
        from: logoSize * 0.5 - target.width * 0.5
        to: target.x
        duration: animationDuration
        easing.type: animationEasingType
      }
      PropertyAnimation {
        target: bottomRightSmallSpot
        property: "y"
        from: logoSize * 0.5 - target.width * 0.5
        to: target.y
        duration: animationDuration
        easing.type: animationEasingType
      }
      PropertyAnimation {
        target: bottomRightSmallSpot
        property: "x"
        from: logoSize * 0.5 - target.width * 0.5
        to: target.x
        duration: animationDuration
        easing.type: animationEasingType
      }
      PropertyAnimation {
        target: bottomLeftSmallSpot
        property: "y"
        from: logoSize * 0.5 - target.width * 0.5
        to: target.y
        duration: animationDuration
        easing.type: animationEasingType
      }
      PropertyAnimation {
        target: bottomLeftSmallSpot
        property: "x"
        from: logoSize * 0.5 - target.width * 0.5
        to: target.x
        duration: animationDuration
        easing.type: animationEasingType
      }
      PropertyAnimation {
        target: topLeftSmallSpot
        property: "y"
        from: logoSize * 0.5 - target.width * 0.5
        to: target.y
        duration: animationDuration
        easing.type: animationEasingType
      }
      PropertyAnimation {
        target: topLeftSmallSpot
        property: "x"
        from: logoSize * 0.5 - target.width * 0.5
        to: target.x
        duration: animationDuration
        easing.type: animationEasingType
      }
    }

    // Rotate logo
    PropertyAnimation {
      target: spotsRotation
      property: "angle"
      to: 360 + logoRotationAngle
      duration: animationDuration
      easing.type: animationEasingType
    }
  }

  ///////////////////////////////////////////////////////////////////////////////////////
  // LOGIC
  ///////////////////////////////////////////////////////////////////////////////////////

  // Return position of the circle element
  function pos(element, angle) {
    const sinAngle = Math.sin(angle * Math.PI / 180)
    const cosAngle = Math.cos(angle * Math.PI / 180)
    const logoRadius = logoSize * 0.5
    const largeSpotRadius = largeSpotSize * 0.5
    const elementRadius = element.width * 0.5
    const spacer = (logoRadius - largeSpotRadius - elementRadius * 2) * 0.5
    const offsetDist = largeSpotRadius + spacer + elementRadius
    const offsetX = offsetDist * sinAngle
    const offsetY = offsetDist * cosAngle
    return {
      "x": logoRadius + offsetX - elementRadius,
      "y": logoRadius - offsetY - elementRadius
    }
  }

  // Set positions of all the circle elements
  property real centralLargeSpotX: logoSize * 0.5 - largeSpotSize * 0.5
  property real centralLargeSpotY: logoSize * 0.5 - largeSpotSize * 0.5
  property real topMediumSpotX: pos(topMediumSpot, 0).x
  property real topMediumSpotY: pos(topMediumSpot, 0).y
  property real bottomMediumSpotX: pos(bottomMediumSpot, 180).x
  property real bottomMediumSpotY: pos(bottomMediumSpot, 180).y
  property real topRightSmallSpotX: pos(topRightSmallSpot,
                                        smallSpotOffsetAngle).x
  property real topRightSmallSpotY: pos(topRightSmallSpot,
                                        smallSpotOffsetAngle).y
  property real bottomRightSmallSpotX: pos(topRightSmallSpot,
                                           180 - smallSpotOffsetAngle).x
  property real bottomRightSmallSpotY: pos(topRightSmallSpot,
                                           180 - smallSpotOffsetAngle).y
  property real bottomLeftSmallSpotX: pos(topRightSmallSpot,
                                          180 + smallSpotOffsetAngle).x
  property real bottomLeftSmallSpotY: pos(topRightSmallSpot,
                                          180 + smallSpotOffsetAngle).y
  property real topLeftSmallSpotX: pos(topRightSmallSpot,
                                       -smallSpotOffsetAngle).x
  property real topLeftSmallSpotY: pos(topRightSmallSpot,
                                       -smallSpotOffsetAngle).y
}

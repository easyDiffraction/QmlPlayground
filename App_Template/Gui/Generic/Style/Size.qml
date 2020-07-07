pragma Singleton

import QtQuick 2.12

QtObject {
  // Application Window
  readonly property int appWindowMinimumWidth: 500
  readonly property int appWindowMinimumHeight: 400
  readonly property int appWindowRadius: 10
  readonly property int appWindowShadowRadius: 20

  // Tab bar
  readonly property int tabBarHeight: 50
  readonly property int tabBarButtonWidth: 100

  // Side bar
  readonly property int sideBarWidth: 200

  // Status bar
  readonly property int statusBarHeight: 30

  // Common
  readonly property int borderThickness: 1
}

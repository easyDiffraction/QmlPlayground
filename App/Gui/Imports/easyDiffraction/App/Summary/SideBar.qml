import QtQuick 2.12
import QtQuick.Controls 2.12

import easyInterface.App 1.0 as InterfaceApp

import easyDiffraction.App.Summary.SideBar 1.0 as DiffractionSideBar

InterfaceApp.SideBar {
    basicControls: DiffractionSideBar.Basic {}
    advancedControls: DiffractionSideBar.Advanced {}
}

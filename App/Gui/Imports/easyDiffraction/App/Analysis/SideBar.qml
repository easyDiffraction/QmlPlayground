import easyInterface.App 1.0 as InterfaceApp

import easyDiffraction.App.Analysis.SideBar 1.0 as DiffractionSideBar

InterfaceApp.SideBar {
    basicControls: DiffractionSideBar.Basic {}
    advancedControls: DiffractionSideBar.Advanced {}
}

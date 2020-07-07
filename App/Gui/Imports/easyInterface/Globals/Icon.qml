pragma Singleton

import QtQuick 2.12

import easyInterface.Globals 1.0 as InterfaceGlobals

QtObject {

    // Application bar toolbuttons
    readonly property string save: iconPath("save.svg")
    readonly property string undo: iconPath("undo-alt.svg")
    readonly property string redo: iconPath("redo-alt.svg")

    readonly property string preferences: iconPath("cog.svg")
    readonly property string help: iconPath("question-circle.svg")
    readonly property string bug: iconPath("bug.svg")

    // Application bar tabbuttons
    readonly property string home: iconPath("home.svg")
    readonly property string project: iconPath("archive.svg")
    readonly property string sample: iconPath("gem.svg")
    readonly property string experiment: iconPath("microscope.svg")
    readonly property string analysis: iconPath("calculator.svg")
    readonly property string summary: iconPath("clipboard-list.svg")

    // Sidebar groups
    readonly property string play: iconPath("play.svg")
    readonly property string circle: iconPath("circle.svg")

    // Sidebar
    readonly property string cloneProject: iconPath("copy.svg")
    readonly property string createProject: iconPath("file-medical.svg")
    readonly property string openProject: iconPath("file-upload.svg")
    readonly property string saveProject: iconPath("file-download.svg")

    // Logic
    function iconPath(iconFileName) {
        const iconsDirPath = Qt.resolvedUrl("../Resources/Icons/")
        return iconsDirPath + iconFileName
    }
}

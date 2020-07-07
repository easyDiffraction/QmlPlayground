pragma Singleton

import QtQuick 2.12

QtObject {

    // Project
    readonly property string refinement: imagePath("saved_refinement.png")
    readonly property string structure: imagePath("saved_structure.png")

    // Logic
    function imagePath(imageFileName) {
        const imagesDirPath = Qt.resolvedUrl("../Resources/Images/")
        return imagesDirPath + imageFileName
    }
}

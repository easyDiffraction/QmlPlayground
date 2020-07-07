pragma Singleton

import QtQuick 2.12

QtObject {
    // Application bar index
    enum AppBarIndexEnum {
        HomeIndex = 0,
        ProjectIndex = 1,
        SampleIndex = 2,
        ExperimentIndex = 3,
        AnalysisIndex = 4,
        SummaryIndex = 5
    }

    // Initial application parameters
    property int appBarCurrentIndex: 5
    property int appWindowFlags: Qt.FramelessWindowHint | Qt.Dialog

    // Initial application elements visibility
    property bool showAppBar: false
    property bool showAppStatusBar: false
    property bool showAppPreferencesDialog: false

    // Animation
    property int introAnimationDuration: 100 //500

    // Project
    property bool projectOpened: false
}

pragma Singleton

import QtQuick 2.13

QtObject {

    // Load fonts
    property FontLoader ptSansWebRegular: FontLoader {
        source: "qrc:/qml/AsQuick/Resources/Font/PT_Sans-Web-Regular.ttf"
    }
    property FontLoader ptSansWebBold: FontLoader {
        source: "qrc:/qml/AsQuick/Resources/Font/PT_Sans-Web-Bold.ttf"
    }

    // Default font parameters
    readonly property Text _text: Text {}
    readonly property int _systemFontPointSize: _text.font.pointSize
    readonly property int pointSize: _systemFontPointSize + 1
    readonly property string sans: ptSansWebRegular.name

}

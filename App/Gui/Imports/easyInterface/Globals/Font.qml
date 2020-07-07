pragma Singleton

import QtQuick 2.12

QtObject {

    // Load fonts
    readonly property string regular: ptSansWebRegular.name
    readonly property string mono: ptMono.name
    readonly property string condensedLight: encodeSansCondensedExtraLight.name
    readonly property string condensedRegular: encodeSansCondensedRegular.name

    property FontLoader ptSansWebRegular: FontLoader {
        source: fontPath("PtSans", "PT_Sans-Web-Regular.ttf")
    }
    property FontLoader ptSansWebBold: FontLoader {
        source: fontPath("PtSans", "PT_Sans-Web-Bold.ttf")
    }
    property FontLoader ptMono: FontLoader {
        source: fontPath("PtMono", "PTM55FT.ttf")
    }
    property FontLoader encodeSansCondensedExtraLight: FontLoader {
        source: fontPath("EncodeSansCondensed",
                         "EncodeSansCondensed-ExtraLight.ttf")
    }
    property FontLoader encodeSansCondensedRegular: FontLoader {
        source: fontPath("EncodeSansCondensed",
                         "EncodeSansCondensed-Regular.ttf")
    }

    function fontPath(fontDirName, fontFileName) {
        const fontsDirPath = Qt.resolvedUrl("../Resources/Fonts")
        return fontsDirPath + "/" + fontDirName + "/" + fontFileName
    }

    // System font parameters
    readonly property Text _text: Text {}
    readonly property int _systemFontPointSize: _text.font.pointSize
    readonly property int pointSize: _systemFontPointSize + 1
}

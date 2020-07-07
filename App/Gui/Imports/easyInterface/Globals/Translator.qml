pragma Singleton

import QtQuick 2.12

QtObject {
    property bool _translatorDefined: typeof _translator !== "undefined"

    property var languagesAsXml: _translatorDefined ? _translator.languagesAsXml() : null
    property var defaultLanguageIndex: _translatorDefined ? _translator.defaultLanguageIndex() : 0

    function selectLanguage(index) {
        if (_translatorDefined) {
            _translator.selectLanguage(index)
        }
    }
}

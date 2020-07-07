pragma Singleton

import QtQuick 2.12

QtObject {
    property bool defined: typeof _experiment !== "undefined"

    property var xmlModel: defined ? _experiment.xml_model : defaultXmlModel()
    property var chartLimits: defined ? _experiment.chart_limits : defaultChartLimits()

    onXmlModelChanged: print(xmlModel)

    function defaultXmlModel() {
        const n = 10
        let s = '<root>'
        for (let i = 0; i < n; i++) {
            s += '<item>'
            const x = i + 1
            const y = Math.floor(Math.random() * 10) / 10
            s += `<x>${x}</x><y>${y}</y>`
            s += '</item>'
        }
        s += '</root>'
        return s
    }
    function defaultChartLimits() {
        return {
            'x': { 'min': 0, 'max': 1 },
            'y': { 'min': 0, 'max': 1 }
        }
    }

    function bindChartSeries(series) {
        if (defined) {
            _experiment.bindChartSeries(series)
        }
    }
    function setData(basePath, roleName, rowIndex, initialText, newText) {
        if (defined) {
            _experiment.setData(basePath, roleName, rowIndex, initialText, newText)
        } else {
            print("WARNING: This function is not implemented in pure QML")
        }
    }
}

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import easyInterface.Globals 1.0 as InterfaceGlobals
import easyInterface.App 1.0 as InterfaceApp
import easyInterface.QtQuick 1.0 as InterfaceQtQuick

import easyDiffraction.Globals 1.0 as DiffractionGlobals

InterfaceApp.TextArea {
    wrapMode: DiffractionGlobals.Variable.wrapSampleText ? TextArea.WordWrap : TextArea.NoWrap
    textFormat: TextEdit.RichText
    //text: "<b>Hello</b>...<i>World! lkgml  kj kj kj jh jh jh jh jh jj lkfg b lk klfk l kfg f gklb g lk lk kl lk lklk lk lk l kml km lkm lkm lk m lkm lk m lkm lkm  lkm 111 END</i><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>end"
    text: writeHTML()

    /////////////
    // Write HTML
    /////////////

    function writeHtmlHead() {
        let s = ''
        s += '<head>'
        s += '<style>'
        s += 'table {'
        s += 'border-collapse: collapse;'
        s += '}'
        s += 'td, th {'
        s += 'border: 1px solid #ddd;'
        s += 'padding: 2px;'
        s += 'padding-left: 12px;'
        s += 'padding-right: 12px;'
        s += '}'
        s += 'tr:nth-child(even) {'
        s += 'background-color: #eee;'
        s += '}'
        s += `a:link { color: ${Material.accent}; }`
        s += '</style>'
        s += '</head>'
        return s
    }

    function writeHtmlTable() {
        let s = ''
        s += '<table>'
        s += '<tr>'
        s += '<th align="right">No.</th>'
        s += '<th align="left">Parameter</th>'
        s += '<th align="right">Value</th>'
        s += '<th align="right">Error</th>'
        s += '<th align="right">Fit</th>'
        s += '</tr>'
        /*
        for (let row_index = 0; row_index < Specific.Variables.fitables.rowCount(); row_index++) {
            const index = Specific.Variables.fitables.index(row_index, 0)
            const label = Specific.Variables.fitables.data(index, Qt.UserRole + 2)
            const refine = Specific.Variables.fitables.data(index, Qt.UserRole + 7)
            const value = refine ? Specific.Variables.fitables.data(index, Qt.UserRole + 3).toFixed(5) : ''
            const error = refine ? Specific.Variables.fitables.data(index, Qt.UserRole + 4).toFixed(5) : ''
            const fit = refine ? '+' : ''
            s += '<tr>'
            s += '<td align="right">' + (row_index + 1) + '</td>'
            s += '<td align="left">' + label + '</td>'
            s += '<td align="right">' + value + '</td>'
            s += '<td align="right">' + error + '</td>'
            s += '<td align="right">' + fit + '</td>'
            s += '</tr>'
        }
        */
        s += '</table>'
        return s
    }

    function writeHtmlBody() {
        let s = ''
        s += '<body>'
        s += `<h1>${DiffractionGlobals.Project.name}</h1>`
        s += '<p>'
        s += `<b>Keywords:</b> ${DiffractionGlobals.Project.keywords}<br>`
        s += `<b>Phases:</b> ${DiffractionGlobals.Project.phases}<br>`
        s += `<b>Experiments:</b> ${DiffractionGlobals.Project.experiments}<br>`
        s += `<b>Instrument:</b> ${DiffractionGlobals.Project.instrument}<br>`
        s += `<b>Modified:</b> ${DiffractionGlobals.Project.modified}<br>`
        s += `<b>Software:</b> <a href="{Specific.Variables.projectDict.app.url}">{Specific.Variables.projectDict.app.name} v{Specific.Variables.projectDict.app.version}</a><br>`
        s += `<b>Calculator:</b> <a href="{Specific.Variables.projectDict.calculator.url}">{Specific.Variables.projectDict.calculator.name} v{Specific.Variables.projectDict.calculator.version}</a><br>`
        s += `<b>Chi2:</b> {Generic.Variables.chiSquared} <br>`
        s += '</p>'
        s += '<h2>Parameters</h2>'
        s += '<p>'
        s += writeHtmlTable()
        s += '<br></p>'
        s += '<h2>Fitting</h2>'
        s += '<p>'
        s += `<img src="${Qt.resolvedUrl(DiffractionGlobals.Images.refinement)}">`
        s += '</p>'
        s += '<h2>Structure</h2>'
        s += '<p>'
        s += `<img src="${Qt.resolvedUrl(DiffractionGlobals.Images.structure)}">`
        s += '</p>'
        s += '</body>'
        return s
    }

    function writeHTML() {
        let s = ''
        s += '<!DOCTYPE html>'
        s += '<html>'
        s += writeHtmlHead()
        s += writeHtmlBody()
        s += '</html>'
        return s
    }
}

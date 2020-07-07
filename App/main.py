import os
import sys
import random
import logging
from dicttoxml import dicttoxml

from PySide2.QtCore import Qt, Property, Signal, Slot
from PySide2.QtCore import QCoreApplication, QUrl, QObject, QPointF, QTranslator, QLocale
from PySide2.QtQml import QQmlApplicationEngine
from PySide2.QtWidgets import QApplication, QWidget
from PySide2.QtCharts import QtCharts

from easyInterface.Utils.DictTools import PathDict


class Experiment(QObject):
    def __init__(self):
        QObject.__init__(self)
        self._data = []
        self._data_series = []
        self._chart_series = []
        self._chart_limits = {}
        self.initData()
        self.updateDataSeries()
        self.updateChartSeries()
        self.updateChartLimits()

    def initData(self):
        for i in range (30):
            item = { 'x': i, 'y': random.randint(0, 1000) }
            self._data.append(item)
        print(self._data)

    def resetChartLimits(self):
        self._chart_limits = {
            'x': { 'min': float('Inf'), 'max': -float('Inf') },
            'y': { 'min': float('Inf'), 'max': -float('Inf') }
        }

    def updateChartLimits(self):
        self.resetChartLimits()
        for item in self._data:
            x = item['x']
            y = item['y']
            if x < self._chart_limits['x']['min']:
                self._chart_limits['x']['min'] = x
            if x > self._chart_limits['x']['max']:
                self._chart_limits['x']['max'] = x
            if y < self._chart_limits['y']['min']:
                self._chart_limits['y']['min'] = y
            if y > self._chart_limits['y']['max']:
                self._chart_limits['y']['max'] = y

    def getChartLimits(self):
        return self._chart_limits

    def asXmlString(self):
        xml = dicttoxml(self._data, attr_type=False)
        xml = xml.decode()
        return xml

    def updateDataSeries(self):
        self._data_series.clear()
        for item in self._data:
            x = item['x']
            y = item['y']
            point = QPointF(x, y)
            self._data_series.append(point)

    def updateChartSeries(self):
        for series in self._chart_series:
            series.replace(self._data_series)

    @Slot(QtCharts.QXYSeries)
    def bindChartSeries(self, series):
        self._chart_series.append(series)
        self.updateChartSeries()

    @Slot(str, str, int, str, str)
    def setData(self, base_path, role_name, row_index, old_value, new_value):
        if new_value == old_value:
            return
        old_value = float(old_value)
        new_value = float(new_value)
        full_path = f"{base_path}/{role_name}"
        path = full_path.replace("/root/item/", "", 1)
        list_path = path.split("/")
        row_dict = PathDict(self._data[row_index])
        row_dict.setItemByPath(list_path, new_value)
        #self._data[row_index] = row_dict
        print(old_value,new_value,full_path,path,list_path,row_dict)
        print(self._data)
        self.updateDataSeries()
        self.updateChartSeries()
        self.updateChartLimits()
        self.dataChanged.emit()

    dataChanged = Signal()

    xml_model = Property('QVariant', asXmlString, notify=dataChanged)
    chart_limits = Property('QVariant', getChartLimits, notify=dataChanged)


class Translator(QObject):
    def __init__(self, app, engine, translations_path):
        QObject.__init__(self)
        self._app = app
        self._engine = engine
        self._translations_path = translations_path
        self._translator = QTranslator()
        self._default_language_index = 0
        self._languages = [
            { 'language': { 'name': 'Française', 'code': 'fr' } },
            { 'language': { 'name': 'English', 'code': 'en' } },
            { 'language': { 'name': 'Русский', 'code': 'ru' } }
        ]

    def translationFilePath(self, index):
        file_suffix = self._languages[index]['language']['code']
        file_name = f"easyInterface_{file_suffix}.qm"
        file_path = os.path.join(self._translations_path, file_name)
        if os.path.isfile(file_path):
            return file_path
        return None

    def systemLanguageCode(self):
        system_locale = QLocale.system().name()
        system_language_code = system_locale[0:2]
        return system_language_code

    def selectSystemLanguage(self):
        for index, language in enumerate(self._languages):
            if language['language']['code'] == self.systemLanguageCode():
                self._default_language_index = index
                self.selectLanguage(index)

    @Slot(int)
    def selectLanguage(self, index):
        logging.info(index)
        self._app.removeTranslator(self._translator)
        translation_file_path = self.translationFilePath(index)
        if translation_file_path is not None:
            self._translator.load(translation_file_path)
            self._app.installTranslator(self._translator)
        self._engine.retranslate()

    @Slot(result=str)
    def languagesAsXml(self):
        xml = dicttoxml(self._languages, attr_type=False)
        xml = xml.decode()
        return xml

    @Slot(result=int)
    def defaultLanguageIndex(self):
        return self._default_language_index


if __name__ == '__main__':
    # logging config
    #logging.basicConfig(level=logging.INFO, format="\033[1;32;49m%(asctime)s  |  %(lineno)-4d %(filename)-30s  |  %(funcName)-35s  |  %(message)s\033[0m")

    # qml gui style
    os.environ["QT_QUICK_CONTROLS_STYLE"] = "Material"
    os.environ["QT_QUICK_CONTROLS_MATERIAL_VARIANT"] = "Dense"

    # paths
    current_path = os.path.dirname(sys.argv[0])
    qml_gui_path = QUrl.fromLocalFile(os.path.join(current_path, "Gui", "main.qml"))
    qml_imports_path = str(QUrl.fromLocalFile(os.path.join(current_path, "Gui", "Imports")).toString())
    translations_path = os.path.join(current_path, "Gui", "Imports", "easyInterface", "Translations")

    # create app and qml engine
    app = QApplication(sys.argv)
    engine = QQmlApplicationEngine()

    # translator
    translator = Translator(app, engine, translations_path)
    translator.selectSystemLanguage()

    # experimental data model
    experiment = Experiment()

    # qml engine settings
    engine.rootContext().setContextProperty("_translator", translator)
    engine.rootContext().setContextProperty("_experiment", experiment)
    engine.addImportPath(qml_imports_path)
    engine.load(qml_gui_path)

    # event loop
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())

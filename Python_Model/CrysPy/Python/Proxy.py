from PySide2.QtCore import Qt, QObject, Signal, Slot, Property
from PySide2.QtGui import QStandardItemModel

import cryspy

import logging
logging.basicConfig(format="%(asctime)-15s [%(levelname)s] %(filename)s %(funcName)s [%(lineno)d]: %(message)s", level=logging.INFO)

from Python.CryspyCalculator import *
from Python.MeasuredDataModel import *
from Python.CalculatedDataModel import *
from Python.FitablesModel import *

class Proxy(QObject):
    def __init__(self, main_rcif_path, parent=None):
        super().__init__(parent)
        logging.info("")
        self._calculator = CryspyCalculator(main_rcif_path)
        self._measured_data_model = MeasuredDataModel(self._calculator)
        self._calculated_data_model = CalculatedDataModel(self._calculator)
        self._fitables_model = FitablesModel(self._calculator)
        self._fitables_model.modelChanged.connect(self.projectChanged)

    # Project model for QML
    projectChanged = Signal()
    def getProject(self):
        return self._calculator.asDict()
    project = Property('QVariant', getProject, notify=projectChanged)

    # Measured data header model for QML
    measuredDataHeaderChanged = Signal()
    def getMeasuredDataHeader(self):
        return self._measured_data_model.asHeadersModel()
    measuredDataHeader = Property('QVariant', getMeasuredDataHeader, notify=measuredDataHeaderChanged)

    # Measured data model for QML
    measuredDataChanged = Signal()
    def getMeasuredData(self):
        return self._measured_data_model.asDataModel()
    measuredData = Property('QVariant', getMeasuredData, notify=measuredDataChanged)

    # Calculated data header model for QML
    calculatedDataHeaderChanged = Signal()
    def getCalculatedDataHeader(self):
        return self._calculated_data_model.asHeadersModel()
    calculatedDataHeader = Property('QVariant', getCalculatedDataHeader, notify=calculatedDataHeaderChanged)

    # Calculated data model for QML
    calculatedDataChanged = Signal()
    def getCalculatedData(self):
        return self._calculated_data_model.asDataModel()
    calculatedData = Property('QVariant', getCalculatedData, notify=calculatedDataChanged)

    # Fitables model for QML
    fitablesChanged = Signal()
    def getFitables(self):
        return self._fitables_model.asModel()
    fitables = Property('QVariant', getFitables, notify=fitablesChanged)

    @Slot(result='QVariant')
    def refine(self):
        """refinement ..."""
        res = self._calculator.refine()
        return res

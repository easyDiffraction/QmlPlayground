from PySide2.QtCore import Qt, QObject, Signal, Slot, Property
from PySide2.QtGui import QStandardItem, QStandardItemModel

import logging
logging.basicConfig(format="%(asctime)-15s [%(levelname)s] %(filename)s %(funcName)s [%(lineno)d]: %(message)s", level=logging.INFO)

class CalculatedDataModel(QObject):
    def __init__(self, calculator, parent=None):
        logging.info("") # profiling
        super().__init__(parent)
        calculator.projectDictChanged.connect(self.onProjectChanged)
        self._project_dict = calculator.asDict()
        self._headers_model = QStandardItemModel()
        self._data_model = QStandardItemModel()
        self._setModelsFromProjectDict()

    def _setModelsFromProjectDict(self):
        """Create the model needed for GUI calculated data table and chart."""
        self._data_model.removeColumns(0, self._data_model.columnCount()) # removeColumns() is faster than clear()
        for experiment_id, experiment_dict in self._project_dict['calculations'].items():
            headers = []
            for data_id, data_list in experiment_dict['calculated_pattern'].items():
                item = QStandardItem()
                item.setData(data_id, Qt.DisplayRole)
                headers.append(item)
                column = []
                for value in data_list:
                    item = QStandardItem()
                    item.setData(value, Qt.DisplayRole)
                    column.append(item)
                self._data_model.appendColumn(column)
            self._headers_model.appendRow(headers)

    modelChanged = Signal()

    def onProjectChanged(self):
        """Set headers and data models from project dictionary"""
        self._setModelsFromProjectDict()
        self.modelChanged.emit()

    def asHeadersModel(self):
        """Return headers model."""
        return self._headers_model

    def asDataModel(self):
        """Return data model."""
        return self._data_model

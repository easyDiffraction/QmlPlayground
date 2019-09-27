from PySide2.QtCore import Qt, QObject, Signal, Slot, Property
from PySide2.QtGui import QStandardItem, QStandardItemModel

class MeasuredDataModel(QObject):
    def __init__(self, calculator, parent=None):
        super().__init__(parent)
        self._project_dict = calculator.asDict()
        self._headers_model = QStandardItemModel()
        self._data_model = QStandardItemModel()
        self._setModelsFromProjectDict()

    def _setModelsFromProjectDict(self):
        """Create the model needed for GUI calculated data table and chart."""
        self._data_model.setColumnCount(0) # faster than clear()
        self._headers_model.setRowCount(0) # faster than clear()
        for experiment_id, experiment_dict in self._project_dict['experiments'].items():
            headers = []
            for data_id, data_list in experiment_dict['measured'].items(): # or measured_pattern as calculated_pattern in another class?
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

    def asHeadersModel(self):
        """Return headers model."""
        return self._headers_model

    def asDataModel(self):
        """Return data model."""
        return self._data_model

from PySide2.QtCore import Qt, QObject, Signal, Slot, Property
from PySide2.QtGui import QStandardItemModel

import logging
logging.basicConfig(format="%(asctime)-15s [%(levelname)s] %(filename)s %(funcName)s [%(lineno)d]: %(message)s", level=logging.INFO)

class MeasuredDataModel(QObject):
    def __init__(self, project, parent=None):
        super().__init__(parent)
        self._headers_model, self._data_model = self._createModelsFromHeadersAndData(*self._createHeadersAndDataFromProject(project))

    def _createHeadersAndDataFromProject(self, project):
        """Create the initial data 2d list with structure for GUI measured data table and chart."""
        data = []
        headers = []
        project_dict = project.asDict()
        for experiment_id, experiment_dict in project_dict['experiments'].items():
            for data_id, data_list in experiment_dict['measured'].items():
                headers.append(data_id)
                data.append(data_list)
        data_transposed = [*zip(*data)]
        return headers, data_transposed

    def _createModelsFromHeadersAndData(self, headers, data):
        """Create the model needed for GUI measured data table and chart (based on data 2d list created previously)."""
        row_count = len(data)
        column_count = len(data[0])
        # set headers
        headers_model = QStandardItemModel(1, column_count)
        for column_index in range(column_count):
            index = headers_model.index(0, column_index)
            value = headers[column_index]
            headers_model.setData(index, value, Qt.DisplayRole) #Qt.WhatsThisRole
        # set model data
        data_model = QStandardItemModel(row_count, column_count)
        for row_index in range(row_count):
            for column_index in range(column_count):
                index = data_model.index(row_index, column_index)
                value = data[row_index][column_index]
                data_model.setData(index, value, Qt.DisplayRole)
        return headers_model, data_model

    def asHeadersModel(self):
        """Return header model."""
        return self._headers_model

    def asDataModel(self):
        """Return data model."""
        return self._data_model

from PySide2.QtCore import Qt, QObject, Signal, Slot, Property
from PySide2.QtGui import QStandardItemModel

import logging
logging.basicConfig(format="%(asctime)-15s [%(levelname)s] %(filename)s %(funcName)s [%(lineno)d]: %(message)s", level=logging.INFO)

class CalculatedDataModel(QObject):
    def __init__(self, project, parent=None):
        super().__init__(parent)
        self._project = project
        self._headers_dict = {}
        self._data_dict = {}
        self._headers_model = QStandardItemModel()
        self._data_model = QStandardItemModel()
        self._setHeadersAndDataFromProject()
        self._setModelsFromHeadersAndData()
        self._project.projectDictChanged.connect(self.onProjectChanged)

    def _setHeadersAndDataFromProject(self):
        """Create the initial data 2d list with structure for GUI calculated data table and chart."""
        project_dict = self._project.asDict()
        self._headers_dict.clear()
        self._data_dict.clear()
        for experiment_id, experiment_dict in project_dict['calculations'].items():
            data = []
            headers = []
            for data_id, data_list in experiment_dict['calculated_pattern'].items():
                headers.append(data_id)
                data.append(data_list)
            self._headers_dict[experiment_id] = headers
            data_transposed = [*zip(*data)]
            self._data_dict[experiment_id] = data_transposed

    def _setModelsFromHeadersAndData(self):
        """Create the model needed for GUI calculated data table and chart (based on data 2d list created previously)."""
        if self._project.experimentsCount() > 1:
            print("Currently, only 1 measured datablock is supported. Given: ", self._project.experimentsCount())
        experiment_id = self._project.experimentsIds()[0] # only 1st measured datablock is currently taken into account
        headers = self._headers_dict[experiment_id]
        data = self._data_dict[experiment_id]
        row_count = len(data)
        column_count = len(data[0])
        # set headers
        self._headers_model.clear()
        self._headers_model.setRowCount(1)
        self._headers_model.setColumnCount(column_count)
        for column_index in range(column_count):
            index = self._headers_model.index(0, column_index)
            value = headers[column_index]
            self._headers_model.setData(index, value, Qt.DisplayRole) #Qt.WhatsThisRole
        # set model data
        self._data_model.clear()
        self._data_model.setRowCount(row_count)
        self._data_model.setColumnCount(column_count)
        for row_index in range(row_count):
            for column_index in range(column_count):
                index = self._data_model.index(row_index, column_index)
                value = data[row_index][column_index]
                self._data_model.setData(index, value, Qt.DisplayRole)

    modelChanged = Signal()

    def onProjectChanged(self):
        """..."""
        self._setHeadersAndDataFromProject()
        self._setModelsFromHeadersAndData()
        self.modelChanged.emit()

    def asHeadersModel(self):
        """Return header model."""
        return self._headers_model

    def asDataModel(self):
        """Return data model."""
        return self._data_model

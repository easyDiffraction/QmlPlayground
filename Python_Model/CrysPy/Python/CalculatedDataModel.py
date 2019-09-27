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
        self._data_model.dataChanged.connect(self.onModelDataChanged) # profiling
        self._data_model.itemChanged.connect(self.onModelItemChanged) # profiling
        self._setHeadersAndDataFromProject()
        self._setModelsFromHeadersAndData()
        self._project.projectDictChanged.connect(self.onProjectChanged)

    def _setHeadersAndDataFromProject(self):
        """Create the initial data 2d list with structure for GUI calculated data table and chart."""
        logging.info("start") # profiling
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
        logging.info("end") # profiling

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
        logging.info("") # profiling
        self._headers_model.clear()
        logging.info("") # profiling
        self._headers_model.setRowCount(1)
        logging.info("") # profiling
        self._headers_model.setColumnCount(column_count)
        logging.info("setData loop start") # profiling
        for column_index in range(column_count):
            index = self._headers_model.index(0, column_index)
            value = headers[column_index]
            self._headers_model.setData(index, value, Qt.DisplayRole) #Qt.WhatsThisRole
        logging.info("setData loop end") # profiling
        # set model data
        logging.info("") # profiling
        self._data_model.clear()
        logging.info("") # profiling
        self._data_model.setRowCount(row_count)
        logging.info("") # profiling
        self._data_model.setColumnCount(column_count)
        #self._data_model.blockSignals(True)
        logging.info("setData loop start") # profiling
        for row_index in range(row_count):
            for column_index in range(column_count):
                index = self._data_model.index(row_index, column_index)
                value = data[row_index][column_index]
                self._data_model.setData(index, value, Qt.DisplayRole)
        logging.info("setData loop end") # profiling
        #self._data_model.blockSignals(False)
        #top_left_index = self._data_model.index(0, 0)
        #bottom_right_index = self._data_model.index(self._data_model.rowCount()-1, self._data_model.columnCount()-1)
        #logging.info(bottom_right_index)
        #roles_list = [Qt.DisplayRole]
        #self._data_model.dataChanged.emit(top_left_index, bottom_right_index, roles_list)

    def onModelDataChanged(self): # profiling
        pass
        #logging.info("---")

    def onModelItemChanged(self): # profiling
        pass
        #logging.info("+++")

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

    def asDataDict(self):
        """Return ..."""
        return self._data_dict

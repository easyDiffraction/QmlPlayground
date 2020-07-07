import os, sys
import random
import operator
from functools import reduce

from PySide2.QtCore import QUrl, Qt, QCoreApplication
from PySide2.QtWidgets import QApplication
from PySide2.QtQml import QQmlApplicationEngine

from PySide2.QtCore import QObject, Signal, Slot, Property
from PySide2.QtCore import QAbstractListModel, QAbstractTableModel, QModelIndex, QByteArray

from PySide2.QtGui import QStandardItem, QStandardItemModel

#####################################################################
class ProjectModel(QObject):
    def __init__(self, parent=None):
        super().__init__(parent)
        self._data = {}
        self.initData()

    def initData(self):
        """Init data dict."""
        num_points = 20
        self._data = {
            'phases': {
                'Fe3O4': {
                    'cell': {
                        'a': { 'value': 13.5, 'error': 0.62, 'refine': False },
                        'b': { 'value': 10.0, 'error': 0.42, 'refine': True },
                        'c': { 'value': 11.2, 'error': 0.51, 'refine': False },
                    }
                },
                'impurity': {
                    'cell': {
                        'a': { 'value': 5.35, 'error': 0.32, 'refine': True },
                        'b': { 'value': 4.28, 'error': 0.22, 'refine': False },
                        'c': { 'value': 7.32, 'error': 0.21, 'refine': False },
                    }
                }
            },
            'experiments': {
                'pnd': {
                    'measured': {
                        'ttheta': [i for i in range (num_points)],
                        'obs': [random.randrange(100) for i in range (num_points)]
                    },
                    'calculated': {
                        'ttheta': [i for i in range (num_points)],
                        'calc': [random.randrange(100) for i in range (num_points)]
                    }
                }
            }
        }

    def getByPath(self, keys):
        """Access a nested object in root by key sequence."""
        return reduce(operator.getitem, keys, self._data)

    def setByPath(self, keys, value):
        """Get a value in a nested object in root by key sequence."""
        self.getByPath(keys[:-1])[keys[-1]] = value

    def setByPathAndIndex(self, keys, index, value):
        """Set a value in a nested list by key sequence to list and index of the element within list."""
        self.getByPath(keys[:-1])[keys[-1]][index] = value

    def phasesCount(self):
        """Returns number of phases in the project."""
        return len(self._data['phases'].keys())

    def experimentsCount(self):
        """Returns number of experiments in the project."""
        return len(self._data['experiments'].keys())

    def phasesIds(self):
        """Returns labels of the phases in the project."""
        return list(self._data['phases'].keys())

    def experimentsIds(self):
        """Returns labels of the experiments in the project."""
        return list(self._data['experiments'].keys())

    def asDict(self):
        """Return data dict."""
        return self._data

#####################################################################
class MeasuredDataItemModel(QObject):
    def __init__(self, project, parent=None):
        super().__init__(parent)
        self._headerModel, self._dataModel = self._createModelFromData(*self._createDataFromProject(project))

    def _createDataFromProject(self, project):
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

    def _createModelFromData(self, headers, data):
        """Create the model needed for GUI measured data table and chart (based on data 2d list created previously)."""
        row_count = len(data)
        column_count = len(data[0])
        # set headers
        headerModel = QStandardItemModel(1, column_count)
        for column_index in range(column_count):
            index = headerModel.index(0, column_index)
            value = headers[column_index]
            headerModel.setData(index, value, Qt.DisplayRole) #Qt.WhatsThisRole
        # set model data
        dataModel = QStandardItemModel(row_count, column_count)
        for row_index in range(row_count):
            for column_index in range(column_count):
                index = dataModel.index(row_index, column_index)
                value = data[row_index][column_index]
                dataModel.setData(index, value, Qt.DisplayRole)
        return headerModel, dataModel

    def asHeadersModel(self):
        """Return header model."""
        return self._headerModel

    def asDataModel(self):
        """Return data model."""
        return self._dataModel

#####################################################################
class CalculatedDataItemModel(QObject):
    def __init__(self, project, parent=None):
        super().__init__(parent)
        self._project = project
        self._headerModel, self._dataModel = self._createModelFromData(*self._createDataFromProject())
        self._dataModel.dataChanged.connect(self.onModelChanged)

    def _createDataFromProject(self):
        """Create the initial data 2d list with structure for GUI calculated data table and chart."""
        project_dict = self._project.asDict()
        data_blocks = {}
        headers_blocks = {}
        for experiment_id, experiment_dict in project_dict['experiments'].items():
            data = []
            headers = []
            for data_id, data_list in experiment_dict['calculated'].items():
                headers.append(data_id)
                data.append(data_list)
            headers_blocks[experiment_id] = headers
            data_transposed = [*zip(*data)]
            data_blocks[experiment_id] = data_transposed
        return headers_blocks, data_blocks

    def _createModelFromData(self, headers_blocks, data_blocks):
        """Create the model needed for GUI calculated data table and chart (based on data 2d list created previously)."""
        if self._project.experimentsCount() > 1:
            print("Currently, only 1 measured datablock is supported. Given: ", self._project.experimentsCount())
        experiment_id = self._project.experimentsIds()[0] # only 1st measured datablock is currently taken into account
        headers, data = headers_blocks[experiment_id], data_blocks[experiment_id]
        row_count = len(data)
        column_count = len(data[0])
        # set headers
        headerModel = QStandardItemModel(1, column_count)
        for column_index in range(column_count):
            index = headerModel.index(0, column_index)
            value = headers[column_index]
            headerModel.setData(index, value, Qt.DisplayRole) #Qt.WhatsThisRole
        # set model data
        dataModel = QStandardItemModel(row_count, column_count)
        for row_index in range(row_count):
            for column_index in range(column_count):
                index = dataModel.index(row_index, column_index)
                value = data[row_index][column_index]
                dataModel.setData(index, value, Qt.DisplayRole)
        return headerModel, dataModel

    modelChanged = Signal()

    def onModelChanged(self, top_left_index, bottom_right_index, roles):
        """Define what to do if model is changed, e.g. from GUI."""
        self.updateProject(top_left_index, roles[0])
        self.modelChanged.emit()

    def updateProject(self, index, data_role):
        """Update project element, which is changed in the model, depends on its index and role."""
        row_index = index.row()
        value = self._dataModel.data(index, data_role)
        experiment_id = self._project.experimentsIds()[0] # only 1st measured datablock is currently taken into account
        keys = ["experiments", experiment_id, "calculated", "calc"]
        self._project.setByPathAndIndex(keys, row_index, value)

    def asHeadersModel(self):
        """Return header model."""
        return self._headerModel

    def asDataModel(self):
        """Return data model."""
        return self._dataModel

#####################################################################
class FitablesItemModel(QObject):
    def __init__(self, project, parent=None):
        super().__init__(parent)
        self._project = project
        self._model = self._createModelFromData(self._createDataFromProject())
        self._model.dataChanged.connect(self.onModelChanged)

    def _createDataFromProject(self):
        """Create the initial data list with structure for GUI fitables table."""
        data = []
        project_dict = self._project.asDict()
        for phase_id, phase_dict in project_dict['phases'].items():
            for fitable_id, fitable_dict in phase_dict['cell'].items():
                data.append({
                    'id': ['phases', phase_id, 'cell', fitable_id],
                    'label': '{} {}'.format(phase_id, fitable_id),
                    'value': fitable_dict['value'],
                    'error': fitable_dict['error'],
                    'refine': fitable_dict['refine']
                })
        return data

    def _createModelFromData(self, data):
        """Create the model needed for GUI fitables table (based on data dict created previously)."""
        model = QStandardItemModel()
        model.setRowCount(len(data))
        model.setColumnCount(1)#model.setColumnCount(len(data[0]))
        # set model role names
        start_role = Qt.UserRole + 1
        role_names = {}
        for key, _ in data[0].items():
            column_index = list(data[0].keys()).index(key)
            role = start_role + column_index
            role_names[role] = key.encode()
        model.setItemRoleNames(role_names)
        # set model data
        for row_index, row_dict in enumerate(data):
            for key, value in row_dict.items():
                column_index = list(row_dict.keys()).index(key)
                index = model.index(row_index, 0)
                role = start_role + column_index
                model.setData(index, value, role)
        return model

    modelChanged = Signal()

    def onModelChanged(self, top_left_index, bottom_right_index, roles):
        """Define what to do if model is changed, e.g. from GUI."""
        self.updateProject(top_left_index, roles[0])
        self.modelChanged.emit()

    def updateProject(self, index, data_role):
        """Update project element, which is changed in the model, depends on its index and role."""
        row_index = index.row()
        id_role = Qt.UserRole + 1
        value = self._model.data(index, data_role)
        data_role_name = self._model.roleNames()[data_role].data().decode()
        keys = self._model.data(index, id_role) + [data_role_name]
        self._project.setByPath(keys, value)

    def asModel(self):
        """Return model."""
        return self._model

#####################################################################
class Proxy(QObject):
    def __init__(self, parent=None):
        super().__init__(parent)
        self._projectModel = ProjectModel()
        self._measuredDataModel = MeasuredDataItemModel(self._projectModel)
        self._calculatedDataModel = CalculatedDataItemModel(self._projectModel)
        self._calculatedDataModel.modelChanged.connect(self.projectChanged)
        self._fitablesModel = FitablesItemModel(self._projectModel)
        self._fitablesModel.modelChanged.connect(self.projectChanged)

    # Project model for QML
    projectChanged = Signal()
    def getProject(self):
        return self._projectModel.asDict()
    project = Property('QVariant', getProject, notify=projectChanged)

    # Measured data header model for QML
    measuredDataHeaderChanged = Signal()
    def getMeasuredDataHeader(self):
        return self._measuredDataModel.asHeadersModel()
    measuredDataHeader = Property('QVariant', getMeasuredDataHeader, notify=measuredDataHeaderChanged)

    # Measured data model for QML
    measuredDataChanged = Signal()
    def getCalculatedData(self):
        return self._measuredDataModel.asDataModel()
    measuredData = Property('QVariant', getCalculatedData, notify=measuredDataChanged)

    # Calculated data header model for QML
    calculatedDataHeaderChanged = Signal()
    def getCalculatedDataHeader(self):
        return self._calculatedDataModel.asHeadersModel()
    calculatedDataHeader = Property('QVariant', getCalculatedDataHeader, notify=calculatedDataHeaderChanged)

    # Calculated data model for QML
    calculatedDataChanged = Signal()
    def getMeasuredData(self):
        return self._calculatedDataModel.asDataModel()
    calculatedData = Property('QVariant', getMeasuredData, notify=calculatedDataChanged)

    # Fitables model for QML
    fitablesChanged = Signal()
    def getFitables(self):
        return self._fitablesModel.asModel()
    fitables = Property('QVariant', getFitables, notify=fitablesChanged)

    @Slot()
    def updateCalculatedDataModelRandomly(self):
        """Random change of data in all columns but 1st."""
        model = self._calculatedDataModel.asDataModel()
        for column_index in range(1, model.columnCount()):
            for row_index in range(model.rowCount()):
                index = model.index(row_index, column_index)
                value = random.randrange(100)
                role = Qt.DisplayRole
                model.setData(index, value, role)

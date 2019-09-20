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
        self._data = {
            'phases': {
                'Fe3O4': {
                    'cell': {
                        'a': { 'value': 11.5, 'error': 0.2, 'refine': True },
                        'b': { 'value': 11.5, 'error': 0.2, 'refine': True },
                        'c': { 'value': 11.5, 'error': 0.2, 'refine': True },
                    }
                }
            },
            'experiments': {
                'pnd': {
                    'measured': {
                        'ttheta': [1,2,3,4,5],
                        'obs': [100,0,31,17,88]
                    }
                }
            }
        }

    def getByPath(self, keys):
        """Access a nested object in root by key sequence."""
        return reduce(operator.getitem, keys, self._data)

    def setByPath(self, keys, value):
        """Set a value in a nested object in root by key sequence."""
        self.getByPath(keys[:-1])[keys[-1]] = value

    def asDict(self):
        """Return data dict."""
        return self._data

#####################################################################
class ExperimentalDataItemModel(QObject):
    def __init__(self, project, parent=None):
        super().__init__(parent)
        self._project = project
        a = self._createDataFromProject(project)
        self._model = self._createModelFromData(self._createDataFromProject(project))

    def _createDataFromProject(self, project):
        """Create the initial data 2d list with structure for GUI experimental data table and chart."""
        data = []
        headers = []
        project_dict = project.asDict()
        for experiment_id, experiment_dict in project_dict['experiments'].items():
            for data_id, data_list in experiment_dict['measured'].items():
                data.append(data_list)
        data_transposed = [*zip(*data)]
        return data_transposed

    def _createModelFromData(self, data):
        """Create the model needed for GUI experimental data table and chart (based on data 2d list created previously)."""
        row_count = len(data)
        column_ount = len(data[0])
        model = QStandardItemModel(row_count, column_ount)
        # set model data
        for row_index in range(row_count):
            for column_index in range(column_ount):
                index = model.index(row_index, column_index)
                value = data[row_index][column_index]
                role = Qt.DisplayRole
                model.setData(index, value, role)
        return model

    modelChanged = Signal()

    def asModel(self):
        """Return model."""
        return self._model

#####################################################################
class FitablesItemModel(QObject):
    def __init__(self, project, parent=None):
        super().__init__(parent)
        self._project = project
        self._model = self._createModelFromData(self._createDataFromProject(project))
        self._model.dataChanged.connect(self.onModelChanged)

    def _createDataFromProject(self, project):
        """Create the initial data list with structure for GUI fitables table."""
        data = []
        project_dict = project.asDict()
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
        start_role = Qt.UserRole + 1
        role_names = {}
        # set model role names
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
        self._experimentalDataModel = ExperimentalDataItemModel(self._projectModel)
        self._experimentalDataModel.modelChanged.connect(self.projectChanged)
        self._fitablesModel = FitablesItemModel(self._projectModel)
        self._fitablesModel.modelChanged.connect(self.projectChanged)

    # Project model for QML
    projectChanged = Signal()
    def getProject(self):
        return self._projectModel.asDict()
    project = Property('QVariant', getProject, notify=projectChanged)

    # Experimental data model for QML
    experimentalDataChanged = Signal()
    def getExperimentalData(self):
        return self._experimentalDataModel.asModel()
    experimentalData = Property('QVariant', getExperimentalData, notify=experimentalDataChanged)

    # Fitables model for QML
    fitablesChanged = Signal()
    def getFitables(self):
        return self._fitablesModel.asModel()
    fitables = Property('QVariant', getFitables, notify=fitablesChanged)

    @Slot()
    def updateExperimentalDataModelRandomly(self):
        """Random change of data in all columns but 1st."""
        model = self._experimentalDataModel.asModel()
        for column_index in range(1, model.columnCount()):
            for row_index in range(model.rowCount()):
                index = model.index(row_index, column_index)
                value = random.randrange(100)
                role = Qt.DisplayRole
                model.setData(index, value, role)

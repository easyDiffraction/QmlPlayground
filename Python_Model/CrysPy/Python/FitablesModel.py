from PySide2.QtCore import Qt, QObject, Signal, Slot, Property
from PySide2.QtGui import  QStandardItemModel

import logging
logging.basicConfig(format="%(asctime)-15s [%(levelname)s] %(filename)s %(funcName)s [%(lineno)d]: %(message)s", level=logging.INFO)

class FitablesModel(QObject):
    def __init__(self, project, parent=None):
        super().__init__(parent)
        #logging.info("")
        self._project = project
        self._data = []
        self._model = QStandardItemModel()
        self._setDataFromProject()
        self._setModelFromData()
        self._project.projectDictChanged.connect(self.onProjectChanged)
        self._model.dataChanged.connect(self.onModelChanged)
        #logging.info("")

    def _setDataFromProject(self):
        """Create the initial data list with structure for GUI fitables table."""
        #logging.info("")
        data = self._data
        data.clear()
        project_dict = self._project.asDict()
        for phase_id, phase_dict in project_dict['phases'].items():
            for fitable_id, fitable_dict in phase_dict['cell'].items():
                data.append({
                    'path': ['phases', phase_id, 'cell', fitable_id],
                    'label': '{} {}'.format(phase_id, fitable_id),
                    'value': fitable_dict['value'],
                    'error': fitable_dict['error'],
                    'refine': fitable_dict['refine']
                })
        #logging.info("")

    def _setModelFromData(self):
        """Create the model needed for GUI fitables table (based on data dict created previously)."""
        #logging.info("")
        data = self._data
        model = self._model
        model.clear()
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
                path_role = start_role + column_index
                model.setData(index, value, path_role)
        #logging.info("")

    def _updateProjectByIndexAndRole(self, index, data_role):
        """Update project element, which is changed in the model, depends on its index and role."""
        #logging.info("")
        row_index = index.row()
        path_role = Qt.UserRole + 1
        value = self._model.data(index, data_role)
        data_role_name = self._model.roleNames()[data_role].data().decode()
        keys = self._model.data(index, path_role) + [data_role_name]
        self._project.setByPath(keys, value)
        #logging.info("")

    modelChanged = Signal()

    def onProjectChanged(self):
        """Define what to do if project dict is changed, e.g. by external library object."""
        #logging.info("")
        self._setDataFromProject()
        self._setModelFromData()
        self.modelChanged.emit()
        #logging.info("")

    def onModelChanged(self, top_left_index, bottom_right_index, roles):
        """Define what to do if model is changed, e.g. from GUI."""
        #logging.info("")
        self._updateProjectByIndexAndRole(top_left_index, roles[0])
        self.modelChanged.emit()
        #logging.info("")

    def asModel(self):
        """Return model."""
        return self._model

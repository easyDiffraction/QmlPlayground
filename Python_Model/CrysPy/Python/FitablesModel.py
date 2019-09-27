from PySide2.QtCore import Qt, QObject, Signal, Slot, Property
from PySide2.QtGui import  QStandardItemModel

import logging
logging.basicConfig(format="%(asctime)-15s [%(levelname)s] %(filename)s %(funcName)s [%(lineno)d]: %(message)s", level=logging.INFO)

class FitablesModel(QObject):
    def __init__(self, project, parent=None):
        super().__init__(parent)
        self._project = project
        self._data = []
        self._model = QStandardItemModel()
        self._setDataFromProject()
        self._setModelFromData()
        self._project.projectDictChanged.connect(self.onProjectChanged)
        self._model.dataChanged.connect(self.onModelChanged)

    def _setDataFromProject(self):
        """Create the initial data list with structure for GUI fitables table."""
        logging.info("start") # profiling
        self._data.clear()
        for level_1_key, level_1_values in self._project.asDict().items():
            for level_2_key, level_2_values in level_1_values.items():
                if isinstance(level_2_values, dict):
                    for level_3_key, level_3_values in level_2_values.items():
                        if isinstance(level_3_values, dict):
                            for level_4_key, level_4_values in level_3_values.items():
                                if isinstance(level_4_values, dict):
                                    if 'refine' in level_4_values:
                                        ##print(level_1_key, level_2_key, level_3_key, level_4_key, level_4_values['value'], level_4_values['constraint'])
                                        self._data.append({
                                            'path': [level_1_key, level_2_key, level_3_key, level_4_key],
                                            'label': '{} {} {} {}'.format(level_1_key, level_2_key, level_3_key, level_4_key),
                                            'value': level_4_values['value'],
                                            'error': level_4_values['error'],
                                            'min': level_4_values['min'],
                                            'max': level_4_values['max'],
                                            'refine': level_4_values['refine']
                                        })
                                    for level_5_key, level_5_values in level_4_values.items():
                                        if isinstance(level_5_values, dict):
                                            if 'refine' in level_5_values:
                                                ##print(level_1_key, level_2_key, level_3_key, level_4_key, level_5_key, level_5_values['value'], level_5_values['constraint'])
                                                self._data.append({
                                                    'path': [level_1_key, level_2_key, level_3_key, level_4_key, level_5_key],
                                                    'label': '{} {} {} {} {}'.format(level_1_key, level_2_key, level_3_key, level_4_key, level_5_key),
                                                    'value': level_5_values['value'],
                                                    'error': level_5_values['error'],
                                                    'min': level_5_values['min'],
                                                    'max': level_5_values['max'],
                                                    'refine': level_5_values['refine']
                                                })
        logging.info("end") # profiling

    def _setModelFromData(self):
        """Create the model needed for GUI fitables table (based on data dict created previously)."""
        logging.info("start") # profiling
        ##self._model.clear() # ! Crashes app without clear error message!
        self._model.setRowCount(len(self._data))
        self._model.setColumnCount(1)
        # set model role names
        start_role = Qt.UserRole + 1
        start_edit_role = start_role + 100
        role_names = {}
        for key, _ in self._data[0].items():
            column_index = list(self._data[0].keys()).index(key)
            role = start_role + column_index
            edit_role = start_edit_role + column_index
            role_names[role] = key.encode()
            role_names[edit_role] = '{}Edit'.format(key).encode()
        self._model.setItemRoleNames(role_names)
        # set model data
        for row_index, row_dict in enumerate(self._data):
            for key, value in row_dict.items():
                column_index = list(row_dict.keys()).index(key)
                index = self._model.index(row_index, 0)
                role = start_role + column_index
                self._model.setData(index, value, role)
        logging.info("end") # profiling

    def _updateProjectByIndexAndRole(self, index, data_role):
        """Update project element, which is changed in the model, depends on its index and role."""
        logging.info("") # profiling
        data_role_name = self._model.roleNames()[data_role].data().decode()
        row_index = index.row()
        path_role = Qt.UserRole + 1
        value = self._model.data(index, data_role)
        keys = self._model.data(index, path_role) + [data_role_name.replace("Edit", "")]
        logging.info("start setByPath") # profiling
        self._project.setByPath(keys, value)
        logging.info("end setByPath") # profiling

    modelChanged = Signal()

    def onProjectChanged(self):
        """Define what to do if project dict is changed, e.g. by external library object."""
        self._setDataFromProject()
        self._setModelFromData()
        self.modelChanged.emit()

    def onModelChanged(self, top_left_index, bottom_right_index, roles):
        """Define what to do if model is changed, e.g. from GUI."""
        data_role_name = self._model.roleNames()[roles[0]].data().decode()
        if data_role_name.endswith("Edit"):
            self._updateProjectByIndexAndRole(top_left_index, roles[0])
        ##self.modelChanged.emit()

    def asModel(self):
        """Return model."""
        return self._model

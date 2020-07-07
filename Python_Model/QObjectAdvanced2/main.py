import os, sys
import random

from PySide2.QtCore import QUrl, Qt, QCoreApplication
from PySide2.QtWidgets import QApplication
from PySide2.QtQml import QQmlApplicationEngine

from PySide2.QtCore import QObject, Signal, Slot, Property
from PySide2.QtCore import QAbstractListModel, QModelIndex, QByteArray

#########
### MODEL
#########

class PythonModel(QObject):

    def __init__(self, parent=None):
        super().__init__(parent)
        self._data_dict = {
            'Fe3O4': {
                'cell_angle_alpha': {'value': 90.0, 'error': 0.000, 'refine': False},
                'cell_angle_beta': {'value': 89.3, 'error': 0.000, 'refine': False},
                'cell_angle_gamma': {'value': 112.2, 'error': 0.000, 'refine': False},
                'cell_length_a': {'value': 8.7, 'error': 0.000, 'refine': False},
                'cell_length_b': {'value': 5.2, 'error': 0.000, 'refine': False},
                'cell_length_c': {'value': 12.1, 'error': 0.000, 'refine': False},
                'space_group_name_H-M_alt': 'Fd-3m',
                'atom_site': {
                    'Fe3A': {
                        'fract_x': {'value': 0.125, 'error': 0.000, 'refine': False},
                        'fract_y': {'value': 0.125, 'error': 0.000, 'refine': False},
                        'fract_z': {'value': 0.125, 'error': 0.000, 'refine': False},
                        'occupancy': {'value': 0.000, 'error': 0.000, 'refine': False},
                    },
                    'Fe3B': {
                        'fract_x': {'value': 0.500, 'error': 0.000, 'refine': False},
                        'fract_y': {'value': 0.500, 'error': 0.000, 'refine': False},
                        'fract_z': {'value': 0.500, 'error': 0.000, 'refine': False},
                        'occupancy': {'value': 0.000, 'error': 0.000, 'refine': False},
                    },
                    'O1': {
                        'fract_x': {'value': 0.255, 'error': 0.000, 'refine': False},
                        'fract_y': {'value': 0.255, 'error': 0.000, 'refine': False},
                        'fract_z': {'value': 0.255, 'error': 0.000, 'refine': False},
                        'occupancy': {'value': 0.000, 'error': 0.000, 'refine': False},
                    },
                }
            },
            'pnd': {
                'pd_resolution_u': 16.9776,
                'pd_resolution_v': -2.83,
            }
        }
        self._fitables_list = []
        self._atom_site_list = []
        self._cell_dict = {}

    # Private methods

    def _get_data_dict(self):
        return self._data_dict

    def _set_data_dict(self, data):
        self._data_dict = data.toVariant()
        self.dataChanged.emit()

    def _get_fitables_list(self):
        self._fitables_list.clear()
        for key, value in self._data_dict.items():
            for subkey, subvalue in value.items():
                try:
                    self._fitables_list.append({'datablock': key, 'group': '', 'subgroup': '', 'fitable': subkey, 'value': subvalue['value'], 'refine': subvalue['refine']})
                except:
                    pass
                try:
                    for subsubkey, subsubvalue in subvalue.items():
                        for subsubsubkey, subsubsubvalue in subsubvalue.items():
                            self._fitables_list.append({'datablock': key, 'group': subkey, 'subgroup': subsubkey, 'fitable': subsubsubkey, 'value': subsubsubvalue['value'], 'refine': subsubsubvalue['refine']})
                except:
                    pass
        return self._fitables_list

    def _get_atom_site_list(self):
        self._atom_site_list.clear()
        for key, value in self._data_dict.items():
            try:
                for subkey, subvalue in value['atom_site'].items():
                   self._atom_site_list.append({'datablock': key, 'label': subkey, **subvalue})
            except:
                pass
        return self._atom_site_list

    def _get_cell_dict(self):
        for key, value in self._data_dict.items():
            try:
                self._cell_dict['cell_angle_alpha'] = value['cell_angle_alpha']
                self._cell_dict['cell_angle_beta'] = value['cell_angle_beta']
                self._cell_dict['cell_angle_gamma'] = value['cell_angle_gamma']
                self._cell_dict['cell_length_a'] = value['cell_length_a']
                self._cell_dict['cell_length_b'] = value['cell_length_b']
                self._cell_dict['cell_length_c'] = value['cell_length_c']
                self._cell_dict['datablock'] = key
            except:
                pass
        return self._cell_dict

    # Signals

    #dataChanged = Signal()

    @Signal
    def dataChanged(self):
        pass

    # QML accessible public slots

    #@Slot('QJSValue')
    #def set_data(self, data):
    #    self._data = data.toVariant()
    #    self.dataChanged.emit()

    @Slot()
    def random_change_cell_length_a(self):
        self._data_dict['Fe3O4']['cell_length_a']['value'] = '{:.7f}'.format(random.random())
        self.dataChanged.emit()

    # QML accessible properties

    data = Property('QVariant', _get_data_dict, _set_data_dict, notify=dataChanged)
    fitables_list = Property('QVariant', _get_fitables_list, notify=dataChanged)
    atom_site_list = Property('QVariant', _get_atom_site_list, notify=dataChanged)
    cell_dict = Property('QVariant', _get_cell_dict, notify=dataChanged)








########
### MAIN
########

if __name__ == '__main__':
    QCoreApplication.setAttribute(Qt.AA_EnableHighDpiScaling)

    app = QApplication(sys.argv)

    pythonModel = PythonModel()

    engine = QQmlApplicationEngine()
    engine.rootContext().setContextProperty("pythonModel", pythonModel)

    engine.load(QUrl.fromLocalFile(os.path.join(os.path.dirname(sys.argv[0]), "gui.qml")))

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec_())


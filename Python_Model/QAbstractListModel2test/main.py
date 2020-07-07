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

# !!! https://wiki.qt.io/Updating-QML-content-from-Python-threads

class RandomNumClass(QObject):

    def __init__(self, parent=None):
        super().__init__(parent)
        self._random_num = 0.0

    def _get_random_num(self):
        return self._random_num

    @Slot()
    def modify_num_randomly(self):
        self._random_num = random.random()
        self.on_random_num.emit()

    on_random_num = Signal()

    random_num = Property(float, _get_random_num, notify=on_random_num)




# !!! https://stackoverflow.com/questions/50609986/how-to-connect-python-and-qml-with-pyside2
# !!! https://stackoverflow.com/questions/50314865/pyside2-pass-list-property-to-model-combobox?noredirect=1&lq=1
# !!!!!! https://qmlbook.github.io/ch18-python/python.html : number = Property(int, get_number, notify=numberChanged)

class PythonModelZ(QObject):

    def __init__(self, parent=None):
        super().__init__(parent)
        self._data = {
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

    # Private methods

    def _get_data_dict(self):
        return self._data

    def _set_data_dict(self, data):
        self._data = data.toVariant()
        self.dataChanged.emit()

    def _get_fitables_list(self):
        self._fitables_list.clear()
        for key, value in self._data.items():
            for subkey, subvalue in value.items():
                try:
                    #print(key, subkey, '->', subvalue['value'], subvalue['refine'])
                    self._fitables_list.append({'datablock': key, 'group': '', 'subgroup': '', 'fitable': subkey, 'value': subvalue['value'], 'refine': subvalue['refine']})
                except:
                    pass
                try:
                    for subsubkey, subsubvalue in subvalue.items():
                        for subsubsubkey, subsubsubvalue in subsubvalue.items():
                            #print(key, subkey, subsubkey, subsubsubkey, '>>', subsubsubvalue['value'], subsubsubvalue['refine'])
                            self._fitables_list.append({'datablock': key, 'group': subkey, 'subgroup': subsubkey, 'fitable': subsubsubkey, 'value': subsubsubvalue['value'], 'refine': subsubsubvalue['refine']})
                except:
                    pass
        #for item in self._fitables_list:
        #    print(item)
        return self._fitables_list

    #
    def _get_atom_site_list(self):
        self._atom_site_list.clear()
        for key, value in self._data.items():
            try:
                for subkey, subvalue in value['atom_site'].items():
                   self. _atom_site_list.append({'datablock': key, 'label': subkey, **subvalue})
            except:
                pass
        return self._atom_site_list

    # Signals

    #dataChanged = Signal()

    @Signal
    def dataChanged(self):
        pass

    # QML accessible public slots


    #@Slot('QJSValue')
    #def set_data_X(self, data):
    #    self._data = data.toVariant()
    #    self.dataChanged.emit()



    @Slot('QJSValue')
    def set_data(self, data):
        self._data = data.toVariant()
        self.dataChanged.emit()

    @Slot()
    def random_change_cell_length_a(self):
        self._data['data_Fe3O4']['cell_length_a'] = random.random()
        self.dataChanged.emit()

    # QML accessible properties

    data = Property('QVariant', _get_data_dict, _set_data_dict, notify=dataChanged)
    fitables_list = Property('QVariant', _get_fitables_list, notify=dataChanged)
    atom_site_list = Property('QVariant', _get_atom_site_list, notify=dataChanged)












    class PythonModelZ2(QObject):

        def __init__(self, parent=None):
            super().__init__(parent)
            self._data = {
                'data_Fe3O4': {
                    'cell_angle_alpha': {'value': 90.0, 'error': 0.000, 'refine': False},
                    'cell_length_a': {'value': 8.7, 'error': 0.000, 'refine': False},
                    'space_group_name_H-M_alt': 'Fd-3m',
                    'atom_site': [
                        {
                            'label': 'Fe3A',
                            'fract_x': {'value': 0.125, 'error': 0.000, 'refine': False},
                            'fract_y': {'value': 0.125, 'error': 0.000, 'refine': False},
                            'fract_z': {'value': 0.125, 'error': 0.000, 'refine': False},
                            'occupancy': {'value': 0.000, 'error': 0.000, 'refine': False},
                        },
                        {
                            'label': 'Fe3B',
                            'fract_x': {'value': 0.500, 'error': 0.000, 'refine': False},
                            'fract_y': {'value': 0.500, 'error': 0.000, 'refine': False},
                            'fract_z': {'value': 0.500, 'error': 0.000, 'refine': False},
                            'occupancy': {'value': 0.000, 'error': 0.000, 'refine': False},
                        },
                        {
                            'label': 'O1',
                            'fract_x': {'value': 0.255, 'error': 0.000, 'refine': False},
                            'fract_y': {'value': 0.255, 'error': 0.000, 'refine': False},
                            'fract_z': {'value': 0.255, 'error': 0.000, 'refine': False},
                            'occupancy': {'value': 0.000, 'error': 0.000, 'refine': False},
                        },
                    ]
                },
                'data_pnd': {
                    'pd_resolution_u': 16.9776,
                    'pd_resolution_v': -2.83,
                }
            }
            self._fitables_list = []

        # Private methods

        def _get_data_dict(self):
            return self._data

        def _set_data_dict(self, data):
            self._data = data.toVariant()
            self.dataChanged.emit()

        def _get_fitables_list(self):
            self._fitables_list.clear()
            for key, value in self._data.items():
                for subkey, subvalue in value.items():
                    if isinstance(subvalue, dict):
                        try:
                            self._fitables_list.append({'datablock': key, 'group': '', 'subgroup': '', 'fitable': subkey, 'value': subvalue['value'], 'refine': subvalue['refine']})
                        except:
                            pass
                    if isinstance(subvalue, list):
                        for item in subvalue:
                            for subsubkey, subsubvalue in item.items():
                                try:
                                    self._fitables_list.append({'datablock': key, 'group': subkey, 'subgroup': item['label'], 'fitable': subsubkey, 'value': subsubvalue['value'], 'refine': subsubvalue['refine']})
                                except:
                                    pass
            #for item in self._fitables_list:
            #    print(item)
            return self._fitables_list

        # Signals

        #dataChanged = Signal()

        @Signal
        def dataChanged(self):
            pass

        # QML accessible public slots


        #@Slot('QJSValue')
        #def set_data_X(self, data):
        #    self._data = data.toVariant()
        #    self.dataChanged.emit()



        @Slot('QJSValue')
        def set_data(self, data):
            self._data = data.toVariant()
            self.dataChanged.emit()

        @Slot()
        def random_change_cell_length_a(self):
            self._data['data_Fe3O4']['cell_length_a'] = random.random()
            self.dataChanged.emit()

        # QML accessible properties

        data = Property('QVariant', _get_data_dict, _set_data_dict, notify=dataChanged)
        fitables_list = Property('QVariant', _get_fitables_list, notify=dataChanged)



#
#
#
#
#
#

#
class PythonModelZclassical(QObject):

    def __init__(self, parent=None):
        super().__init__(parent)
        self.__datablocks = {
            'data_Fe3O4': {
                'cell_angle_alpha': 90.0,
                'cell_length_a': 8.7,
                'space_group_name_H-M_alt': 'Fd-3m',
                'atom_site': [
                    {'label': 'Fe3A', 'fract_x': 0.125, 'fract_y': 0.125, 'fract_z': 0.125, 'occupancy': 0.000},
                    {'label': 'Fe3B', 'fract_x': 0.500, 'fract_y': 0.500, 'fract_z': 0.500, 'occupancy': 0.000},
                    {'label': 'O1', 'fract_x': 0.255, 'fract_y': 0.255, 'fract_z': 0.255, 'occupancy': 0.000},
                ]
            },
            'data_pnd': {
                'pd_resolution_u': 16.9776,
                'pd_resolution_v': -2.83,
            }
        }

    @Slot(result='QVariant')
    def get(self):
        return self.__datablocks

    @Slot('QVariant')
    def set(self, datablocks):
        self.__datablocks = datablocks


#
# Qt Help:
# Models can be created directly in QML using ListModel, XmlListModel or ObjectModel,
# or provided by C++ model classes. If a C++ model class is used, it must be a subclass
# of QAbstractItemModel or a simple list.


class PythonModelX(QAbstractListModel):
    mRole = Qt.UserRole + 1

    def __init__(self, parent=None):
        super().__init__(parent)
        self._datablocks = {
            'data_Fe3O4': {
                'cell_angle_alpha': 90.0,
                'cell_length_a': 8.7,
                'space_group_name_H-M_alt': 'Fd-3m',
                'atom_site': [
                    {'label': 'Fe3A', 'fract_x': 0.125, 'fract_y': 0.125, 'fract_z': 0.125, 'occupancy': 0.000},
                    {'label': 'Fe3B', 'fract_x': 0.500, 'fract_y': 0.500, 'fract_z': 0.500, 'occupancy': 0.000},
                    {'label': 'O1', 'fract_x': 0.255, 'fract_y': 0.255, 'fract_z': 0.255, 'occupancy': 0.000},
                ]
            },
            'data_pnd': {
                'pd_resolution_u': 16.9776,
                'pd_resolution_v': -2.83,
            }
        }

    #
    def rowCount(self, parent=QModelIndex()):
        return 1

    #
    def roleNames(self):
        return {
            PythonModelX.mRole: b'm',
        }

    #
    def data(self, index, role=Qt.DisplayRole):
        if role == PythonModelX.mRole:
            return self._datablocks['data_Fe3O4']

    #
    @Slot(result='QVariant')
    def get(self):
        return self._datablocks

    #
    @Slot('QVariant')
    def set(self, datablocks):
        self._datablocks = datablocks
        #self.dataChanged.emit(QModelIndex(), QModelIndex())
        #self.dataChanged.emit(ix, ix, self.roleNames())
        self.dataChanged.emit(self.index(0, 0), self.index(0, 0), self.roleNames())







class PythonModel2(QAbstractListModel):
    def __init__(self, parent=None):
        super().__init__(parent)
        self._datablocks = {
            'data_Fe3O4': {
                'cell_angle_alpha': 90.0,
                'cell_angle_beta': 90.0,
                'cell_angle_gamma': 90.0,
                'cell_length_a': 8.7,
                'cell_length_b': 4.5,
                'cell_length_c': 12.1,
                'space_group_name_H-M_alt': 'Fd-3m',
                'atom_site': [
                    {'label': 'Fe3A', 'fract_x': 0.125, 'fract_y': 0.125, 'fract_z': 0.125, 'occupancy': 0.000},
                    {'label': 'Fe3B', 'fract_x': 0.500, 'fract_y': 0.500, 'fract_z': 0.500, 'occupancy': 0.000},
                    {'label': 'O1', 'fract_x': 0.255, 'fract_y': 0.255, 'fract_z': 0.255, 'occupancy': 0.000},
                ]
            },
            'data_pnd': {
                'pd_resolution_u': 16.9776,
                'pd_resolution_v': -2.83,
            }
        }

    @Slot(result='QVariant')
    def datablocks(self):
        return self._datablocks

    @Slot()
    def modify_cell_length_a(self):
        self._datablocks['data_Fe3O4']['cell_length_a'] = -23.14
        self.dataChanged.emit(QModelIndex(), QModelIndex())

        #def emitDataChanged(self):
        #    self.dataChanged.emit(QModelIndex(), QModelIndex())



class PythonModel(QAbstractListModel):
    #atom_site_label_role = Qt.UserRole + 1
    #atom_site_fract_x_role = Qt.UserRole + 2
    #atom_site_fract_y_role = Qt.UserRole + 3
    #atom_site_fract_z_role = Qt.UserRole + 4
    #refine_role = Qt.UserRole + 5
    datablocks_role = Qt.UserRole + 1

    def __init__(self, parent=None):
        super().__init__(parent)
        #self._datablocks = [
        #    {'label': 'Fe3A', 'x': {'a':0.125, 'b':'0.999'}, 'y': 0.125,   'z': 0.125,   'refine': False},
        #    {'label': 'Fe3B', 'x': {'a':0.325, 'b':'0.799'}, 'y': 0.5,     'z': 0.5,     'refine': False},
        #    {'label': 'O1',   'x': {'a':0.525, 'b':'0.599'}, 'y': 0.25521, 'z': 0.25521, 'refine': True},
        #    {'label': 'O1',   'x': {'a':0.525, 'b':'0.599'}, 'y': 0.25521, 'z': [], 'refine': True},
        #]
        self._datablocks = {
            'datablocks': {
                'data_Fe3O4': {
                    'cell_angle_alpha': 90.0,
                    'cell_length_a': 8.7,
                    'space_group_name_H-M_alt': 'Fd-3m',
                    'atom_site': [
                        {'label': 'Fe3A', 'fract_x': 0.125, 'fract_y': 0.125, 'fract_z': 0.125, 'occupancy': 0.000},
                        {'label': 'Fe3B', 'fract_x': 0.500, 'fract_y': 0.500, 'fract_z': 0.500, 'occupancy': 0.000},
                        {'label': 'O1', 'fract_x': 0.255, 'fract_y': 0.255, 'fract_z': 0.255, 'occupancy': 0.000},
                    ]
                },
                'data_pnd': {
                    'pd_resolution_u': 16.9776,
                    'pd_resolution_v': -2.83,
                }
            }
        }

    def rowCount(self, parent=QModelIndex()):
        return len(self._datablocks)

    def roleNames(self):
        return {
            #PythonModel.atom_site_label_role: b'label',
            #PythonModel.atom_site_fract_x_role: b'x',
            #PythonModel.atom_site_fract_y_role: b'y',
            #PythonModel.atom_site_fract_z_role: b'z',
            #PythonModel.refine_role: b'refine'
            PythonModel.datablocks_role: b'datablocks'
        }

    def data(self, index, role=Qt.DisplayRole):
        row = index.row()
        #if role == PythonModel.atom_site_label_role:
        #    return self._datablocks[row]['label']
        #if role == PythonModel.atom_site_fract_x_role:
        #    return self._datablocks[row]['x']
        #if role == PythonModel.atom_site_fract_y_role:
        #    return self._datablocks[row]['y']
        #if role == PythonModel.atom_site_fract_z_role:
        #    return self._datablocks[row]['z']
        #if role == PythonModel.refine_role:
        #    return self._datablocks[row]['refine']
        if role == PythonModel.datablocks_role:
            #return self._datablocks[row]['datablocks']
            return self._datablocks['datablocks']

    # Methods accessible from qml via @Slot

    #@Slot(str, 'QVariant', float, float, bool)
    #def append(self, label, x, y, z, refine):
    #    self.beginInsertRows(QModelIndex(), self.rowCount(), self.rowCount())
    #    self._datablocks.append({'label':label, 'x':x, 'y':y, 'z':z, 'refine':refine})
    #    self.endInsertRows()

    #@Slot(int, str, 'QVariant', float, float, bool)
    #def modify(self, row, label, x, y, z, refine):
    #    ix = self.index(row, 0)
    #    self._datablocks[row] = {'label':label, 'x':x, 'y':y, 'z':z, 'refine':refine}
    #    self.dataChanged.emit(ix, ix, self.roleNames())

    @Slot(int)
    def remove(self, row):
        if row >= 0:
            self.beginRemoveColumns(QModelIndex(), row, row)
            del self._datablocks[row]
            self.endRemoveRows()

    #@Slot()
    #def modifyAtomSiteNo2(self):
    #    self.modify(1, 'Tb', random.random(), random.random(), random.random(), True)

    #def emitDataChanged(self):
    #    self.dataChanged.emit(QModelIndex(), QModelIndex())

########
### MAIN
########

if __name__ == '__main__':
    QCoreApplication.setAttribute(Qt.AA_EnableHighDpiScaling)

    app = QApplication(sys.argv)

    pythonModel = PythonModel()
    print("pythonModel from PY", pythonModel)

    pythonModel2 = PythonModel2()
    pythonModel4 = [ 1, 2, 3, 4 ]
    pythonModel3 = [
        {'label': 'Fe3A', 'fract_x': 0.125, 'fract_y': 0.125, 'fract_z': 0.125, 'occupancy': 0.000},
        {'label': 'Fe3B', 'fract_x': 0.500, 'fract_y': 0.500, 'fract_z': 0.500, 'occupancy': 0.000},
        {'label': 'O1', 'fract_x': 0.255, 'fract_y': 0.255, 'fract_z': 0.255, 'occupancy': 0.000},
    ]
    pythonModel5 = {
        'data_Fe3O4': {
            'cell_angle_alpha': 90.0,
            'cell_length_a': 8.7,
            'space_group_name_H-M_alt': 'Fd-3m',
            'atom_site': [
                {'label': 'Fe3A', 'fract_x': 0.125, 'fract_y': 0.125, 'fract_z': 0.125, 'occupancy': 0.000},
                {'label': 'Fe3B', 'fract_x': 0.500, 'fract_y': 0.500, 'fract_z': 0.500, 'occupancy': 0.000},
                {'label': 'O1', 'fract_x': 0.255, 'fract_y': 0.255, 'fract_z': 0.255, 'occupancy': 0.000},
            ]
        },
        'data_pnd': {
            'pd_resolution_u': 16.9776,
            'pd_resolution_v': -2.83,
        }
    }

    pythonModelX = PythonModelX()
    pythonModelZ = PythonModelZ()
    pythonModelZ._get_fitables_list()

    randomNumObj = RandomNumClass()


    engine = QQmlApplicationEngine()
    engine.rootContext().setContextProperty("pythonModel", pythonModel)
    engine.rootContext().setContextProperty("pythonModel2", pythonModel2)
    engine.rootContext().setContextProperty("pythonModel3", pythonModel3)
    engine.rootContext().setContextProperty("pythonModel5", pythonModel5)
    engine.rootContext().setContextProperty("pythonModelX", pythonModelX)
    engine.rootContext().setContextProperty("pythonModelZ", pythonModelZ)

    engine.rootContext().setContextProperty("randomNumProperty", randomNumObj)

    engine.load(QUrl.fromLocalFile(os.path.join(os.path.dirname(sys.argv[0]), "gui.qml")))

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec_())


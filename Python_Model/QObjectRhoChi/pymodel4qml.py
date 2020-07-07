import os, sys
import random
import numpy as np

from PySide2.QtCore import QUrl, Qt, QCoreApplication
from PySide2.QtWidgets import QApplication
from PySide2.QtQml import QQmlApplicationEngine

from PySide2.QtCore import QObject, Signal, Slot, Property
from PySide2.QtCore import QAbstractListModel, QAbstractTableModel, QModelIndex, QByteArray

import f_rcif.cl_rcif as Rhochi_rcif
import f_api_rcif.api_rcif_model as Rhochi_model
import f_common.cl_variable as Rhochi_variable

#########
### ?????
#########

class TableModel(QAbstractTableModel):
    def __init__(self, parent=None):
        super().__init__(parent)
        self._header = []
        self._data = []

    def rowCount(self, parent=QModelIndex()):
        return len(self._data)

    def columnCount(self, parent=QModelIndex()):
        #return len(self._header)
        return len(self._data[0])

    def appendData(self, list):
        self._data.append(list)

    def data(self, index, role=Qt.DisplayRole):
        if not index.isValid():
            return
        i, j = index.row(), index.column()
        if role == Qt.DisplayRole:
            return self._data[i][j]
        return None

    @Slot(int, Qt.Orientation, result="QVariant")
    def headerData(self, section, orientation, role=Qt.DisplayRole):
        if role == Qt.DisplayRole:
            if orientation == Qt.Horizontal:
                return self._header[section]
            else:
                return str(section)
        return None

#########
### MODEL
#########

class PythonModel(QObject):

    def __init__(self, parent=None):
        super().__init__(parent)
        self._data_dict = {}
        self._fitables_list = []
        self._atom_site_list = []
        self._cell_dict = {}
        self._experimental_data_dict = {}

    # ##############################################
    # Private methods
    # ##############################################

    def _get_data_dict(self):
        return self._data_dict

    def _set_data_dict(self, data):
        #self._data_dict = data.toVariant() # don't preserve order
        for key, value in data.toVariant().items():
            for subkey, subvalue in value.items():
                self._data_dict[key][subkey] = subvalue
        self.dataChanged.emit()

    def _get_fitables_list(self):
        self._fitables_list.clear()
        # ADD header now
        for key, value in self._data_dict.items():
            for subkey, subvalue in value.items():
                try:
                    self._fitables_list.append({
                        'datablock': key,
                        'group': '',
                        'subgroup': '',
                        'name': subkey,
                        'value': subvalue['value'],
                        'error': subvalue['error'],
                        'refine': subvalue['refine']
                        })
                except:
                    pass
                try:
                    for subsubkey, subsubvalue in subvalue.items():
                        for subsubsubkey, subsubsubvalue in subsubvalue.items():
                            self._fitables_list.append({
                                'datablock': key,
                                'group': subkey,
                                'subgroup': subsubkey,
                                'name': subsubsubkey,
                                'value': subsubsubvalue['value'],
                                'error': subsubsubvalue['error'],
                                'refine': subsubsubvalue['refine']
                                })
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
                self._cell_dict['cell_length_a'] = value['cell_length_a']
                self._cell_dict['cell_length_b'] = value['cell_length_b']
                self._cell_dict['cell_length_c'] = value['cell_length_c']
                self._cell_dict['cell_angle_alpha'] = value['cell_angle_alpha']
                self._cell_dict['cell_angle_beta'] = value['cell_angle_beta']
                self._cell_dict['cell_angle_gamma'] = value['cell_angle_gamma']
                self._cell_dict['datablock'] = key
            except:
                pass
        return self._cell_dict

    def _get_experimental_data_model(self):
        model = TableModel()
        model.append(self._experimental_data_dict['tth'])
        model.append(self._experimental_data_dict['int_u'])
        model.append(self._experimental_data_dict['sint_u'])
        model.append(self._experimental_data_dict['int_d'])
        model.append(self._experimental_data_dict['sint_d'])
        return model

    def _set_fitable_from_rhochi_model(self, obj, name, title, datablock, group="", subgroup=""):
        if datablock not in self._data_dict.keys():
            self._data_dict[datablock] = {}
        if group and subgroup:
            pass
        else:
            if name not in self._data_dict[datablock].keys():
                self._data_dict[datablock][name] = {}
            if isinstance(obj, float) or isinstance(obj, int):
                self._data_dict[datablock][name]['value'] = '{:.4f}'.format(obj)
                self._data_dict[datablock][name]['error'] = ''
                self._data_dict[datablock][name]['refine'] = False
                self._data_dict[datablock][name]['title'] = title
            elif isinstance(obj, Rhochi_variable.Variable):
                self._data_dict[datablock][name]['value'] = '{:.4f}'.format(obj.__getitem__(0))
                self._data_dict[datablock][name]['error'] = '{:.4f}'.format(obj.__getitem__(4))
                self._data_dict[datablock][name]['refine'] = obj.__getitem__(1)
                self._data_dict[datablock][name]['title'] = title
            else:
                print("Unknown object type", type(obj))

    def _set_data_dict_from_rhochi_model(self):
        #print("_set_data_dict_from_rhochi_model")
        self._data_dict.clear()
        for phase in self._model._list_crystal:
            self._set_fitable_from_rhochi_model(phase.get_val('cell').get_val('a'), 'cell_length_a', 'a (\u212B)', phase.get_val('name'))
            self._set_fitable_from_rhochi_model(phase.get_val('cell').get_val('b'), 'cell_length_b', 'b (\u212B)', phase.get_val('name'))
            self._set_fitable_from_rhochi_model(phase.get_val('cell').get_val('c'), 'cell_length_c', 'c (\u212B)', phase.get_val('name'))
            self._set_fitable_from_rhochi_model(phase.get_val('cell').get_val('alpha'), 'cell_angle_alpha', 'alpha (\u212B)', phase.get_val('name'))
            self._set_fitable_from_rhochi_model(phase.get_val('cell').get_val('beta'), 'cell_angle_beta', 'beta (\u212B)', phase.get_val('name'))
            self._set_fitable_from_rhochi_model(phase.get_val('cell').get_val('gamma'), 'cell_angle_gamma', 'gamma (\u212B)', phase.get_val('name'))
        for phase in self._model._list_experiment:
            self._experimental_data_dict['tth'] = phase.get_val('observed_data').get_val('tth')
            self._experimental_data_dict['int_u'] = phase.get_val('observed_data').get_val('int_u')
            self._experimental_data_dict['sint_u'] = phase.get_val('observed_data').get_val('sint_u')
            self._experimental_data_dict['int_d'] = phase.get_val('observed_data').get_val('int_d')
            self._experimental_data_dict['sint_d'] = phase.get_val('observed_data').get_val('sint_d')

    def _update_rhochi_cell_model(self):
        #print("_update_rhochi_cell_model")
        for phase in self._model._list_crystal:
            a = float(self._data_dict[phase.get_val('name')]['cell_length_a']['value'])
            b = float(self._data_dict[phase.get_val('name')]['cell_length_b']['value'])
            c = float(self._data_dict[phase.get_val('name')]['cell_length_c']['value'])
            alpha = float(self._data_dict[phase.get_val('name')]['cell_angle_alpha']['value'])
            beta = float(self._data_dict[phase.get_val('name')]['cell_angle_beta']['value'])
            gamma = float(self._data_dict[phase.get_val('name')]['cell_angle_gamma']['value'])
            #
            if self._data_dict[phase.get_val('name')]['cell_length_a']['refine']:
                a = Rhochi_variable.Variable(val = a, ref=True)
            if self._data_dict[phase.get_val('name')]['cell_length_b']['refine']:
                b = Rhochi_variable.Variable(val = b, ref=True)
            if self._data_dict[phase.get_val('name')]['cell_length_c']['refine']:
                c = Rhochi_variable.Variable(val = c, ref=True)
            if self._data_dict[phase.get_val('name')]['cell_angle_alpha']['refine']:
                alpha = Rhochi_variable.Variable(val = alpha, ref=True)
            if self._data_dict[phase.get_val('name')]['cell_angle_beta']['refine']:
                beta = Rhochi_variable.Variable(val = beta, ref=True)
            if self._data_dict[phase.get_val('name')]['cell_angle_gamma']['refine']:
                gamma = Rhochi_variable.Variable(val = gamma, ref=True)
            #
            cell = phase.get_val('cell')
            cell.set_val(a = a, b = b, c = c, alpha = alpha, beta = beta, gamma = gamma)
            #
            phase.set_val(cell = cell)

    # ##############################################
    # Signals
    # ##############################################

    #@Signal
    #def dataChanged(self):
    #    pass

    dataChanged = Signal()

    # ##############################################
    # QML accessible public slots
    # ##############################################

    #@Slot('QJSValue')
    #def set_data(self, data):
    #    self._data = data.toVariant()
    #    self.dataChanged.emit()

    @Slot()
    def testDataChanged(self):
        self.dataChanged.emit()

    @Slot()
    def random_change_cell_length_a(self):
        phase = self._model._list_crystal[0]
        self._data_dict[phase.get_val('name')]['cell_length_a']['value'] = '{:.4f}'.format(random.random())
        self.dataChanged.emit()

    @Slot(str)
    def load_rhochi_model_and_update_proxy(self, path):
        #print("load_rhochi_model_and_update_proxy: ", path)
        self._rcif_file_absolute_path = path
        self._rcif = Rhochi_rcif.RCif()
        self._rcif.load_from_file(self._rcif_file_absolute_path)
        self._model = Rhochi_model.conv_rcif_to_model(self._rcif)
        self._set_data_dict_from_rhochi_model()
        self._project_opened = True
        self.dataChanged.emit()

    @Slot(result='QVariant')
    def refine_model(self):
        #print("refine_model")
        self.update_rhochi_model()
        try:
            res = self._model.refine_model()
            if res is None:
                return "No refinable parameters found"
        except np.linalg.LinAlgError as err:
            return str(err)
        except:
            return "Unknow error during refinement"
        self._set_data_dict_from_rhochi_model()
        self.dataChanged.emit()
        return dict(res)

    @Slot()
    def update_rhochi_model(self):
        #print("update_rhochi_model")
        self._update_rhochi_cell_model()

    # ##############################################
    # QML accessible properties
    # ##############################################

    data = Property('QVariant', _get_data_dict, _set_data_dict, notify=dataChanged)
    fitables_list = Property('QVariant', _get_fitables_list, notify=dataChanged)
    atom_site_list = Property('QVariant', _get_atom_site_list, notify=dataChanged)
    cell_dict = Property('QVariant', _get_cell_dict, notify=dataChanged)
    experimental_data_model = Property('QVariant', _get_experimental_data_model, notify=dataChanged)

########
### MAIN
########

if __name__ == '__main__':
    QCoreApplication.setAttribute(Qt.AA_EnableHighDpiScaling)

    app = QApplication(sys.argv)

    pythonModel = PythonModel()
    #rcif_file_path = os.path.join(os.path.dirname(sys.argv[0]), "Examples", "Fe3O4_0T_powder_1d", "full_2phases.rcif")
    rcif_file_path = os.path.join(os.path.dirname(sys.argv[0]), "Examples", "Fe3O4_0T_powder_1d", "full.rcif")
    pythonModel.load_rhochi_model_and_update_proxy(rcif_file_path)

    engine = QQmlApplicationEngine()
    engine.rootContext().setContextProperty("pythonModel", pythonModel)

    qml_gui_file_path = os.path.join(os.path.dirname(sys.argv[0]), "gui.qml")
    engine.load(QUrl.fromLocalFile(os.path.join(qml_gui_file_path)))

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec_())


import os, sys
import random
import numpy as np

from PySide2.QtCore import QUrl, Qt, QCoreApplication
from PySide2.QtWidgets import QApplication
from PySide2.QtQml import QQmlApplicationEngine

from PySide2.QtCore import QObject, Signal, Slot, Property
from PySide2.QtCore import QAbstractListModel, QAbstractTableModel, QModelIndex, QByteArray

import neupy

class TableModel(QAbstractTableModel):
    HeaderRole = Qt.UserRole + 1
    DataRole = Qt.UserRole + 2

    def __init__(self, parent=None):
        """Class constructor."""
        super().__init__(parent)
        self._header = list()
        self._data = list()

    def _setData(self, data):
        self._data = data

    def _setHeader(self, header):
        self._header = header

    def rowCount(self, parent=QModelIndex()):
        """Number of rows in the model."""
        return len(self._data)

    def columnCount(self, parent=QModelIndex()):
        """Number of columns in the model."""
        try:
            return len(self._data[0])
        except IndexError:
            return len(self._header)

    def roleNames(self):
        """Returns the role names."""
        return {
            TableModel.HeaderRole: b'headerRole',
            TableModel.DataRole: b'dataRole',
            Qt.DisplayRole: b'display', # similar to the 'dataRole'; needed for QML ChartView
        }

    def clear(self):
        """Clear all data in model."""
        self.beginResetModel()
        self._data = list()
        self._header = list()
        self.endResetModel()

    def data(self, index, role):
        """Returns the data stored under the given role for the item referred to by the index."""
        if not index.isValid():
            return None
        if role == TableModel.HeaderRole:
            return self._header[index.column()]
        if role == TableModel.DataRole or role == Qt.DisplayRole:
            return '{:.4f}'.format(self._data[index.row()][index.column()])
        return None

    def setData(self, index, value, role):
        """Set data in model."""
        if not index.isValid():
            return False
        if role == TableModel.HeaderRole:
            self._header[index.column()] = str(value)
            self.dataChanged.emit(index, index)
            return True
        if role == TableModel.DataRole:
            self._data[index.row()][index.column()] = float(value)
            self.dataChanged.emit(index, index)
            return True
        return False

    @Slot(int, result=str)
    def header(self, column):
        return self._header[column]

#########
### MODEL
#########

class PythonModel(QObject):

    def __init__(self, parent=None):
        super().__init__(parent)
        self._main_dict = {}
        self._fitables_list = []
        self._atom_site_list = []
        self._cell_dict = {}
        self._experimental_data_model = AbstractVXYModel()
        #self._simulated_data_model = AbstractVXYModel()
        self._simulated_data_model = TableModel()

    # ##############################################
    # Private methods
    # ##############################################

    def _get_main_dict(self):
        return self._main_dict

    def _set_main_dict(self, data):
        #self._main_dict = data.toVariant() # don't preserve order
        for key, value in data.toVariant().items():
            for subkey, subvalue in value.items():
                self._main_dict[key][subkey] = subvalue
        self.dataChanged.emit()

    def _get_fitables_list(self):
        # clear data
        self._fitables_list.clear()
        # add data
        for key, value in self._main_dict.items():
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
        for key, value in self._main_dict.items():
            try:
                for subkey, subvalue in value['atom_site'].items():
                   self._atom_site_list.append({'datablock': key, 'label': subkey, **subvalue})
            except:
                pass
        return self._atom_site_list

    def _get_cell_dict(self):
        for key, value in self._main_dict.items():
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
        for key, value in self._main_dict.items():
            if 'experimental_data' in value.keys():
                self._experimental_data_model.clearModel()
                tth_title = value['experimental_data']['tth']['title']
                int_u_title = value['experimental_data']['int_u']['title']
                sint_u_title = value['experimental_data']['sint_u']['title']
                int_d_title = value['experimental_data']['int_d']['title']
                sint_d_title = value['experimental_data']['sint_d']['title']
                self._experimental_data_model.setHeaderData([tth_title, int_u_title, sint_u_title, int_d_title, sint_d_title])
                tth_data = value['experimental_data']['tth']['data']
                int_u_data= value['experimental_data']['int_u']['data']
                sint_u_data = value['experimental_data']['sint_u']['data']
                int_d_data = value['experimental_data']['int_d']['data']
                sint_d_data = value['experimental_data']['sint_d']['data']
                for tth, int_u, sint_u, int_d, sint_d in zip(tth_data, int_u_data, sint_u_data, int_d_data, sint_d_data):
                    self._experimental_data_model.appendRow([tth, int_u, sint_u, int_d, sint_d])
                return self._experimental_data_model

    def _get_simulated_data_model(self):
        for key, value in self._main_dict.items():
            if 'simulated_data' in value.keys():
                self._simulated_data_model.clear()
                tth_title = value['simulated_data']['tth']['title']
                int_u_title = value['simulated_data']['int_u']['title']
                int_d_title = value['simulated_data']['int_d']['title']
                self._simulated_data_model.setHeader([tth_title, int_u_title, int_d_title])
                tth_data = value['simulated_data']['tth']['data']
                int_u_data = value['simulated_data']['int_u']['data']
                int_d_data = value['simulated_data']['int_d']['data']
                for tth, int_u, int_d in zip(tth_data, int_u_data, int_d_data):
                    self._simulated_data_model.appendRow([tth, int_u, int_d])
                return self._simulated_data_model

    def _set_fitable_from_rhochi_model(self, obj, name, title, datablock, group="", subgroup=""):
        if datablock not in self._main_dict.keys():
            self._main_dict[datablock] = {}
        if group and subgroup:
            pass
        else:
            if name not in self._main_dict[datablock].keys():
                self._main_dict[datablock][name] = {}
            if isinstance(obj, float) or isinstance(obj, int):
                self._main_dict[datablock][name]['value'] = '{:.4f}'.format(obj)
                self._main_dict[datablock][name]['error'] = ''
                self._main_dict[datablock][name]['refine'] = False
                self._main_dict[datablock][name]['title'] = title
            elif isinstance(obj, neupy.f_common.cl_variable.Variable):
                self._main_dict[datablock][name]['value'] = '{:.4f}'.format(obj.__getitem__(0))
                self._main_dict[datablock][name]['error'] = '{:.4f}'.format(obj.__getitem__(4))
                self._main_dict[datablock][name]['refine'] = obj.__getitem__(1)
                self._main_dict[datablock][name]['title'] = title
            else:
                print("Unknown object type", type(obj))

    def _set_data_list_from_rhochi_model(self, datablock, group, name, title, data):
        if datablock not in self._main_dict.keys():
            self._main_dict[datablock] = {}
        if group not in self._main_dict[datablock].keys():
            self._main_dict[datablock][group] = {}
        if name not in self._main_dict[datablock][group].keys():
            self._main_dict[datablock][group][name] = {}
        self._main_dict[datablock][group][name]['title'] = title
        self._main_dict[datablock][group][name]['data'] = data

    def _set_main_dict_from_rhochi_model(self):
        #print("_set_main_dict_from_rhochi_model")
        self._main_dict.clear()
        for datablock in self._model._list_crystal:
            self._set_fitable_from_rhochi_model(datablock.get_val('cell').get_val('a'), 'cell_length_a', 'a (\u212B)', datablock.get_val('name'))
            self._set_fitable_from_rhochi_model(datablock.get_val('cell').get_val('b'), 'cell_length_b', 'b (\u212B)', datablock.get_val('name'))
            self._set_fitable_from_rhochi_model(datablock.get_val('cell').get_val('c'), 'cell_length_c', 'c (\u212B)', datablock.get_val('name'))
            self._set_fitable_from_rhochi_model(datablock.get_val('cell').get_val('alpha'), 'cell_angle_alpha', 'alpha (\u212B)', datablock.get_val('name'))
            self._set_fitable_from_rhochi_model(datablock.get_val('cell').get_val('beta'), 'cell_angle_beta', 'beta (\u212B)', datablock.get_val('name'))
            self._set_fitable_from_rhochi_model(datablock.get_val('cell').get_val('gamma'), 'cell_angle_gamma', 'gamma (\u212B)', datablock.get_val('name'))
        for datablock in self._model._list_experiment:
            datablock_name = datablock.get_val('name')
            self._set_data_list_from_rhochi_model(datablock_name, 'experimental_data', 'tth',    "2Theta",   datablock.get_val('observed_data').get_val('tth').tolist())
            self._set_data_list_from_rhochi_model(datablock_name, 'experimental_data', 'int_u',  "IntUp",    datablock.get_val('observed_data').get_val('int_u').tolist())
            self._set_data_list_from_rhochi_model(datablock_name, 'experimental_data', 'sint_u', "sIntUp",   datablock.get_val('observed_data').get_val('sint_u').tolist())
            self._set_data_list_from_rhochi_model(datablock_name, 'experimental_data', 'int_d',  "IntDown",  datablock.get_val('observed_data').get_val('int_d').tolist())
            self._set_data_list_from_rhochi_model(datablock_name, 'experimental_data', 'sint_d', "sIntDown", datablock.get_val('observed_data').get_val('sint_d').tolist())
            int_up_calc, int_up_down, _ = datablock.calc_profile(datablock.get_val('observed_data').get_val('tth'), self._model._list_crystal)
            self._set_data_list_from_rhochi_model(datablock_name, 'simulated_data', 'tth',   "2Theta",      datablock.get_val('observed_data').get_val('tth').tolist())
            self._set_data_list_from_rhochi_model(datablock_name, 'simulated_data', 'int_u', "IntUpCalc",   int_up_calc.tolist() )
            self._set_data_list_from_rhochi_model(datablock_name, 'simulated_data', 'int_d', "IntDownCalc", int_up_down.tolist())

    def _update_rhochi_cell_model(self):
        #print("_update_rhochi_cell_model")
        for phase in self._model._list_crystal:
            a = float(self._main_dict[phase.get_val('name')]['cell_length_a']['value'])
            b = float(self._main_dict[phase.get_val('name')]['cell_length_b']['value'])
            c = float(self._main_dict[phase.get_val('name')]['cell_length_c']['value'])
            alpha = float(self._main_dict[phase.get_val('name')]['cell_angle_alpha']['value'])
            beta = float(self._main_dict[phase.get_val('name')]['cell_angle_beta']['value'])
            gamma = float(self._main_dict[phase.get_val('name')]['cell_angle_gamma']['value'])
            #
            if self._main_dict[phase.get_val('name')]['cell_length_a']['refine']:
                a = neupy.f_common.cl_variable.Variable(val = a, ref=True)
            if self._main_dict[phase.get_val('name')]['cell_length_b']['refine']:
                b = neupy.f_common.cl_variable.Variable(val = b, ref=True)
            if self._main_dict[phase.get_val('name')]['cell_length_c']['refine']:
                c = neupy.f_common.cl_variable.Variable(val = c, ref=True)
            if self._main_dict[phase.get_val('name')]['cell_angle_alpha']['refine']:
                alpha = neupy.f_common.cl_variable.Variable(val = alpha, ref=True)
            if self._main_dict[phase.get_val('name')]['cell_angle_beta']['refine']:
                beta = neupy.f_common.cl_variable.Variable(val = beta, ref=True)
            if self._main_dict[phase.get_val('name')]['cell_angle_gamma']['refine']:
                gamma = neupy.f_common.cl_variable.Variable(val = gamma, ref=True)
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
    def random_change_cell_length_a(self):
        phase = self._model._list_crystal[0]
        self._main_dict[phase.get_val('name')]['cell_length_a']['value'] = '{:.4f}'.format(random.random())
        self.dataChanged.emit()

    @Slot(str)
    def load_rhochi_model_and_update_proxy(self, path):
        #print("load_rhochi_model_and_update_proxy: ", path)
        self._rcif_file_absolute_path = path
        self._rcif = neupy.f_rcif.RCif()
        self._rcif.load_from_file(self._rcif_file_absolute_path)
        self._model = neupy.f_api_rcif.api_rcif_model.conv_rcif_to_model(self._rcif)
        self._set_main_dict_from_rhochi_model()
        self._project_opened = True
        self.dataChanged.emit()

    @Slot(result='QVariant')
    def refine_model(self):
        #print("refine_model")
        self.update_rhochi_model()
        try:
            res = self._model.refine_model()
            self._set_main_dict_from_rhochi_model()
            self.dataChanged.emit()
            return res
        except np.linalg.LinAlgError as err:
            return {"refinement_message":str(err)}
        except:
            return {"refinement_message":"Unknow error during refinement"}

    @Slot()
    def update_rhochi_model(self):
        #print("update_rhochi_model")
        self._update_rhochi_cell_model()

    # ##############################################
    # QML accessible properties
    # ##############################################

    main_dict = Property('QVariant', _get_main_dict, _set_main_dict, notify=dataChanged)
    experimental_data_model = Property('QVariant', _get_experimental_data_model, notify=dataChanged)
    simulated_data_model = Property('QVariant', _get_simulated_data_model, notify=dataChanged)
    fitables_list = Property('QVariant', _get_fitables_list, notify=dataChanged)
    atom_site_list = Property('QVariant', _get_atom_site_list, notify=dataChanged)
    cell_dict = Property('QVariant', _get_cell_dict, notify=dataChanged)

########
### MAIN
########
# !!!!!https://stackoverflow.com/questions/15306872/return-an-object-in-a-role-in-python-and-get-a-reference-of-another-object-in-qm

if __name__ == '__main__':
    QCoreApplication.setAttribute(Qt.AA_EnableHighDpiScaling)

    app = QApplication(sys.argv)

    pythonModel = PythonModel()
    rcif_file_path = os.path.join(os.path.dirname(sys.argv[0]), "neupy-master", "examples", "Fe3O4_0T_powder_1d", "full_refine-cell.rcif")
    pythonModel.load_rhochi_model_and_update_proxy(rcif_file_path)

    tableModel = TableModel()
    atomSiteModel = AtomSiteModel()

    vxyModel = AbstractVXYModel()
    vxyModel._data = [[1, 2, 3]]

    engine = QQmlApplicationEngine()
    engine.rootContext().setContextProperty("pythonModel", pythonModel)
    engine.rootContext().setContextProperty("tableModel", tableModel)
    engine.rootContext().setContextProperty("vxyModel", vxyModel)
    engine.rootContext().setContextProperty("atomSiteModel", atomSiteModel)

    qml_gui_file_path = os.path.join(os.path.dirname(sys.argv[0]), "gui.qml")
    engine.load(QUrl.fromLocalFile(os.path.join(qml_gui_file_path)))

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec_())


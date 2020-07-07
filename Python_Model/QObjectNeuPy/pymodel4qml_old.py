import os, sys
import random
import numpy as np

from PySide2.QtCore import QUrl, Qt, QCoreApplication
from PySide2.QtWidgets import QApplication
from PySide2.QtQml import QQmlApplicationEngine

from PySide2.QtCore import QObject, Signal, Slot, Property
from PySide2.QtCore import QAbstractListModel, QAbstractTableModel, QModelIndex, QByteArray

import neupy


#https://stackoverflow.com/questions/55787138/update-qml-tableview-after-button-click-via-c
#https://stackoverflow.com/questions/57316457/how-to-add-headers-to-qml-tableview-from-tablemodel

class TableModel3(QAbstractTableModel):
    tableDataRole = Qt.UserRole + 1
    tableHeadingRole = Qt.UserRole + 2

    def __init__(self, parent=None):
        super().__init__(parent)
        self._data = [[i, random.randrange(1000), 0.1] for i in range(10)]

    def rowCount(self, parent=QModelIndex()):
        return len(self._data)

    def columnCount(self, parent=QModelIndex()):
        return len(self._header)

    def roleNames(self):
        return {
            TableModel2.label_role: b'label',
            TableModel2.fract_x_role: b'x',
            TableModel2.fract_y_role: b'y',
            TableModel2.fract_z_role: b'z',
            TableModel2.refine_role: b'refine'
        }

    def data(self, index, role=Qt.DisplayRole):
        row = index.row()
        if role == AtomSiteModel.atom_site_label_role:
            return self.atom_sites[row]['label']
        if role == AtomSiteModel.atom_site_fract_x_role:
            return self.atom_sites[row]['x']
        if role == AtomSiteModel.atom_site_fract_y_role:
            return self.atom_sites[row]['y']
        if role == AtomSiteModel.atom_site_fract_z_role:
            return self.atom_sites[row]['z']
        if role == AtomSiteModel.refine_role:
            return self.atom_sites[row]['refine']

    # Methods accessible from qml via @Slot

    @Slot(str, float, float, float, bool)
    def append(self, label, x, y, z, refine):
        self.beginInsertRows(QModelIndex(), self.rowCount(), self.rowCount())
        self.atom_sites.append({'label':label, 'x':x, 'y':y, 'z':z, 'refine':refine})
        self.endInsertRows()

    @Slot(int, str, float, float, float, bool)
    def modify(self, row, label, x, y, z, refine):
        ix = self.index(row, 0)
        self.atom_sites[row] = {'label':label, 'x':x, 'y':y, 'z':z, 'refine':refine}
        self.dataChanged.emit(ix, ix, self.roleNames())
        ##self.dataChanged.emit(QModelIndex(), QModelIndex(), self.roleNames()) # update all

    @Slot(int)
    def remove(self, row):
        if row >= 0:
            self.beginRemoveColumns(QModelIndex(), row, row)
            del self.atom_sites[row]
            self.endRemoveRows()

    @Slot()
    def modifyAtomSiteNo2(self):
        self.modify(1, 'Tb', random.random(), random.random(), random.random(), True)








# C++ - https://doc-snapshots.qt.io/qt5-5.12/qml-qtquick-tableview.html
# Qt.CheckStateRole - https://forum.qt.io/topic/26422/how-to-make-qabstracttablemodel-s-data-checkable/3
# Qt.CheckStateRole - https://issue.life/questions/48873244
# Qt.ForegroundRole - https://stackoverflow.com/questions/51510968/change-text-color-of-qstandarditem-in-model-view
# https://stackoverflow.com/questions/25943153/how-to-access-data-stored-in-qmodelindex
class TableModel(QAbstractTableModel):
    def __init__(self, parent=None):
        super().__init__(parent)
        self._header = ["Xobs", "Yobs", "sYobs", "Ycalc"] # self._header = {0: "X", 1: "Y", 2: "sY"}
        self._data = [[i, random.randrange(1000), 0.1, random.randrange(1000)] for i in range(500)]

    def rowCount(self, parent=QModelIndex()):
        return len(self._data)

    def columnCount(self, parent=QModelIndex()):
        return len(self._header)

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


    @Slot(result='QVariant')
    def refine_model(self):
        #print("refine_model")
        self._data = [[i, random.randrange(1000), 0.1, random.randrange(1000)] for i in range(500)]








class TableModel2(QAbstractTableModel):
    def __init__(self, parent=None):
        super().__init__(parent)
        self._header = {0: "X", 1: "Y", 2: "Z"}
        self._data = [
            {'X': 13, 'Y': 17, 'Z': 21},
            {'X': 45, 'Y': 18, 'Z': 31},
            {'X': 74, 'Y': 15, 'Z': 41},
            {'X': 12, 'Y': 16, 'Z': 51}
            #[13, 17, 21],
            #[45, 18, 31],
            #[74, 15, 41],
            #[12, 16, 51]
        ]

    def columnCount(self, parent=QModelIndex()):
        return 3

    def rowCount(self, parent=QModelIndex()):
        return len(self._data)

    def data(self, index, role=Qt.DisplayRole):
        i = index.row()
        #j = index.column()
        if role == Qt.DisplayRole:
            #return "{}".format(self._data[i][j])
            return "{}".format(self._data[i][j])

    @Slot(int, Qt.Orientation, result="QVariant")
    def headerData(self, section, orientation, role=Qt.DisplayRole):
        if role == Qt.DisplayRole:
            if orientation == Qt.Horizontal:
                return self._header[section]
            else:
                return str(section)







#########
### ?????
#########

class AbstractTableModel(QAbstractTableModel):
    def __init__(self, parent=None):
        super().__init__(parent)
        #self._header = []
        #self._data = []
        self._header = ["Xobs", "Yobs", "sYobs", "Ycalc"] # self._header = {0: "X", 1: "Y", 2: "sY"}
        #self._data = [[i, random.randrange(1000), 0.1, random.randrange(1000)] for i in range(500)]
        self._data = []
        m = 3
        self._data.append([i for i in range(m)])
        self._data.append([random.randrange(1000) for i in range(m)])
        self._data.append([0.1 for i in range(m)])
        self._data.append([random.randrange(1000) for i in range(m)])

    def rowCount(self, parent=QModelIndex()):
        return len(self._data)

    def columnCount(self, parent=QModelIndex()):
        #return len(self._header)
        return len(self._data[0])

    def appendColumn(self, list):
        self._data.append(list)

    def clearData(self):
        self._data = []

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

























#
class AtomSiteModel(QAbstractListModel):
    atom_site_label_role = Qt.UserRole + 1
    atom_site_fract_x_role = Qt.UserRole + 2
    atom_site_fract_y_role = Qt.UserRole + 3
    atom_site_fract_z_role = Qt.UserRole + 4
    refine_role = Qt.UserRole + 5

    def __init__(self, parent=None):
        super().__init__(parent)
        self.atom_sites = [
            {'label': 'Fe3A', 'x': 0.125,   'y': 0.125,   'z': 0.125,   'refine': False},
            {'label': 'Fe3B', 'x': 0.5,     'y': 0.5,     'z': 0.5,     'refine': False},
            {'label': 'O1',   'x': 0.25521, 'y': 0.25521, 'z': 0.25521, 'refine': True},
        ]

    def rowCount(self, parent=QModelIndex()):
        return len(self.atom_sites)

    def roleNames(self):
        return {
            AtomSiteModel.atom_site_label_role: b'label',
            AtomSiteModel.atom_site_fract_x_role: b'x',
            AtomSiteModel.atom_site_fract_y_role: b'y',
            AtomSiteModel.atom_site_fract_z_role: b'z',
            AtomSiteModel.refine_role: b'refine'
        }

    def data(self, index, role=Qt.DisplayRole):
        row = index.row()
        if role == AtomSiteModel.atom_site_label_role:
            return self.atom_sites[row]['label']
        if role == AtomSiteModel.atom_site_fract_x_role:
            return self.atom_sites[row]['x']
        if role == AtomSiteModel.atom_site_fract_y_role:
            return self.atom_sites[row]['y']
        if role == AtomSiteModel.atom_site_fract_z_role:
            return self.atom_sites[row]['z']
        if role == AtomSiteModel.refine_role:
            return self.atom_sites[row]['refine']

    # Methods accessible from qml via @Slot

    @Slot(str, float, float, float, bool)
    def append(self, label, x, y, z, refine):
        self.beginInsertRows(QModelIndex(), self.rowCount(), self.rowCount())
        self.atom_sites.append({'label':label, 'x':x, 'y':y, 'z':z, 'refine':refine})
        self.endInsertRows()

    @Slot(int, str, float, float, float, bool)
    def modify(self, row, label, x, y, z, refine):
        ix = self.index(row, 0)
        self.atom_sites[row] = {'label':label, 'x':x, 'y':y, 'z':z, 'refine':refine}
        self.dataChanged.emit(ix, ix, self.roleNames())
        ##self.dataChanged.emit(QModelIndex(), QModelIndex(), self.roleNames()) # update all

    @Slot(int)
    def remove(self, row):
        if row >= 0:
            self.beginRemoveColumns(QModelIndex(), row, row)
            del self.atom_sites[row]
            self.endRemoveRows()

    @Slot()
    def modifyAtomSiteNo2(self):
        self.modify(1, 'Tb', random.random(), random.random(), random.random(), True)




#
############
### VXYModel
############

class AbstractVXYModel(QAbstractTableModel):
    def __init__(self, parent=None):
        super().__init__(parent)
        self._header = []
        self._data = []
        print(self.roleNames())

    # reimplementation
    def rowCount(self, parent=QModelIndex()):
        return len(self._data)

    # reimplementation
    def columnCount(self, parent=QModelIndex()):
        #return len(self._header)
        return len(self._data[0])



    def appendRow(self, row):
        #for item in row:
            #print (item, type(item))
        self._data.append(row)
        first_column_index = 0
        last_column_index = self.columnCount() - 1
        last_row_index = self.rowCount() - 1
        top_left = self.index(last_row_index, first_column_index)
        bottom_right = self.index(last_row_index, last_column_index)
        self.dataChanged.emit(top_left, bottom_right, self.roleNames())

    def clearModel(self):
        self._data = []
        self._header = []

    # reimplementation
    def data(self, index, role=Qt.DisplayRole):
        if not index.isValid():
            return
        if role == Qt.DisplayRole:
            return '{:.4f}'.format(self._data[index.row()][index.column()])
        return None

    # reimplementation
    @Slot('QModelIndex', str, int, result=bool)
    def setData(self, index, value, role=Qt.EditRole):
        if not index.isValid():
            return False
        if self._data[index.row()][index.column()] != float(value):
            self._data[index.row()][index.column()] = float(value)
            self.dataChanged.emit(index, index)
            return True
        return False

    # reimplementation
    # https://github.com/eyllanesc/stackoverflow/blob/master/questions/55610163/main.qml
    @Slot(int, Qt.Orientation, result="QVariant")
    def headerData(self, section, orientation, role=Qt.DisplayRole):
        if role == Qt.DisplayRole:
            if orientation == Qt.Horizontal:
                return self._header[section]
            else:
                return str(section)
        return None

    # reimplementation
    def setHeaderData(self, header):
        if self._header != header:
            self._header = header



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
        self._simulated_data_model = AbstractVXYModel()

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
                self._simulated_data_model.clearModel()
                tth_title = value['simulated_data']['tth']['title']
                int_u_title = value['simulated_data']['int_u']['title']
                int_d_title = value['simulated_data']['int_d']['title']
                self._simulated_data_model.setHeaderData([tth_title, int_u_title, int_d_title])
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


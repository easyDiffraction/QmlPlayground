import os, sys
import random
import pprint
import numpy as np

from PySide2.QtCore import QUrl, Qt, QCoreApplication
from PySide2.QtWidgets import QApplication
from PySide2.QtQml import QQmlApplicationEngine

from PySide2.QtCore import QObject, Signal, Slot, Property
from PySide2.QtCore import QAbstractListModel, QAbstractTableModel, QModelIndex, QByteArray

import cryspy

################################################
### TABLE MODEL
################################################
class TableModel(QAbstractTableModel):
    HeaderRole = Qt.UserRole + 1
    DataRole = Qt.UserRole + 2

    def __init__(self, parent=None):
        """Class constructor."""
        super().__init__(parent)
        self._header = list()
        self._data = list()

    def rowCount(self, parent=QModelIndex()):
        """Number of rows in the model."""
        return len(self._data)

    def columnCount(self, parent=QModelIndex()):
        """Number of columns in the model."""
        return len(self._header)
        try:
            return len(self._data[0])
        except IndexError:
            return len(self._header)

    def roleNames(self):
        #result = QAbstractTableModel.roleNames(self)
        #result[TableModel.HeaderRole] = b'headerRole'
        #result[TableModel.DataRole] = b'dataRole'
        #return result
        return {
            TableModel.HeaderRole: b'headerRole',
            TableModel.DataRole: b'dataRole',
            Qt.DisplayRole: b'display', # similar to the 'dataRole'; needed for QML ChartView
        }

    def data(self, index, role):
        """
        Returns the data stored under the given role for the item referred to by the index.
        """
        if not index.isValid():
            return None
        if role == TableModel.HeaderRole:
            return self._header[index.column()]
        if role == TableModel.DataRole or role == Qt.DisplayRole:
            return '{:.4f}'.format(self._data[index.row()][index.column()])
        return None

    def setData(self, index, value, role):
        """
        Reimplementation.
        Set data in model.
        :param index: QModelIndex
        :param value: QVariant
        :param role: int
        :return: bool
        """
        if not index.isValid():
            return False
        if role == TableModel.HeaderRole:
            self._header[index.column()] = str(value)
            self.dataChanged.emit(index, index, [role])
            return True
        if role == TableModel.DataRole:
            self._data[index.row()][index.column()] = float(value)
            self.dataChanged.emit(index, index, [role])
            return True
        return False

    def clear(self):
        """Clear all data in model."""
        self.beginResetModel()
        self._data = list()
        self._header = list()
        self.endResetModel()

    def insertRow(self, row):
        """..."""
        if not self.hasIndex(row, 0):
            self._data.append( [ None for i in range(self.columnCount()) ] )
            return True
        return False

    def insertColumn(self, column):
        """..."""
        if not self.hasIndex(0, column):
            self._header.append(None)
            return True
        return False

    def entireData(self):
        """..."""
        return self._data

    def setEntireData(self, data):
        """..."""
        self._data = data

    def setEntireHeader(self, header):
        """..."""
        self._header = header

    def entireHeader(self):
        """..."""
        return self._header

    @Slot(int, result=str)
    def header(self, column):
        """..."""
        return self._header[column]

################################################
### FITABLES MODEL
################################################
class FitablesModel(QAbstractListModel):
    DatablockRole = Qt.UserRole + 1
    NameRole = Qt.UserRole + 2
    HeaderRole = Qt.UserRole + 3
    ValueRole = Qt.UserRole + 4
    ErrorRole = Qt.UserRole + 5
    RefineRole = Qt.UserRole + 6

    def __init__(self, parent=None):
        """Class constructor."""
        super().__init__(parent)
        self._model = []

    def rowCount(self, parent=QModelIndex()):
        """Number of rows in the model."""
        return len(self._model)

    def roleNames(self):
        """..."""
        return {
            FitablesModel.DatablockRole: b'datablockRole',
            FitablesModel.NameRole: b'nameRole',
            FitablesModel.HeaderRole: b'headerRole',
            FitablesModel.ValueRole: b'valueRole',
            FitablesModel.ErrorRole: b'errorRole',
            FitablesModel.RefineRole: b'refineRole',
        }

    def data(self, index, role):
        """
        Returns the data stored under the given role for the item referred to by the index.
        """
        if not index.isValid():
            return None
        if role == FitablesModel.DatablockRole:
            return self._model[index.row()]['datablock']
        if role == FitablesModel.NameRole:
            return self._model[index.row()]['name']
        if role == FitablesModel.HeaderRole:
            return self._model[index.row()]['header']
        if role == FitablesModel.ValueRole:
            return self._model[index.row()]['value']
        if role == FitablesModel.ErrorRole:
            return self._model[index.row()]['error']
        if role == FitablesModel.RefineRole:
            return self._model[index.row()]['refine']
        return None

    def setData(self, index, value, role):
        """
        Reimplementation.
        Set data in model.
        :param index: QModelIndex
        :param value: QVariant
        :param role: int
        :return: bool
        """
        if not index.isValid():
            return False
        if role == FitablesModel.DatablockRole:
            self._model[index.row()]['datablock'] = str(value)
            self.dataChanged.emit(index, index, [role])
            return True
        if role == FitablesModel.NameRole:
            self._model[index.row()]['name'] = str(value)
            self.dataChanged.emit(index, index, [role])
            return True
        if role == FitablesModel.HeaderRole:
            self._model[index.row()]['header'] = str(value)
            self.dataChanged.emit(index, index, [role])
            return True
        if role == FitablesModel.ValueRole:
            self._model[index.row()]['value'] = float(value)
            self.dataChanged.emit(index, index, [role])
            return True
        if role == FitablesModel.ErrorRole:
            self._model[index.row()]['error'] = str(value)
            self.dataChanged.emit(index, index, [role])
            return True
        if role == FitablesModel.RefineRole:
            self._model[index.row()]['refine'] = bool(value)
            self.dataChanged.emit(index, index, [role])
            return True
        return False

    def insertRow(self, row):
        """..."""
        if not self.hasIndex(row, 0):
            self._model.append({})
            return True
        return False

    def row(self, index):
        """..."""
        if not index.isValid():
            return None
        return self._model[index.row()]

    def clear(self):
        """Clear all data in model."""
        self.beginResetModel()
        self._model = []
        self.endResetModel()

################################################
### PROXY
################################################
class Proxy(QObject):

    def __init__(self, mainRcifPath, parent=None):
        super().__init__(parent)
        # CrysPy
        self._model = cryspy.rhochi_read_file(mainRcifPath)
        # Proxy
        self._fitables = FitablesModel()
        self._experimentalData = TableModel()
        self._simulatedData = TableModel()
        self._project = {}
        # Init
        self.setProxyFromModel()

    def setProxyFitableFromModel(self, phaseLabel, fitableName, tableHeader, fitable):
        # Create '_project' dict skeleton
        if phaseLabel not in self._project.keys():
            self._project[phaseLabel] = {}
        if fitableName not in self._project[phaseLabel].keys():
            self._project[phaseLabel][fitableName] = {}
        # Set '_fitables' list
        row = (list(self._project).index(phaseLabel) + 1) * (list(self._project[phaseLabel]).index(fitableName) + 1) - 1
        self._fitables.insertRow(row)
        index = self._fitables.index(row)
        self._fitables.setData(index, phaseLabel,         FitablesModel.DatablockRole)
        self._fitables.setData(index, fitableName,        FitablesModel.NameRole)
        self._fitables.setData(index, tableHeader,        FitablesModel.HeaderRole)
        self._fitables.setData(index, fitable.value,      FitablesModel.ValueRole)
        self._fitables.setData(index, fitable.sigma,      FitablesModel.ErrorRole)
        self._fitables.setData(index, fitable.refinement, FitablesModel.RefineRole)
        # Bind '_project' dict item to '_fitables' list item
        self._project[phaseLabel][fitableName] = self._fitables.row(index)

    def setProxyFromModel(self):
        for phase in self._model.crystals:
            self.setProxyFitableFromModel(phase.label, 'cell_length_a',    'a (\u212B)',     phase.cell.a)
            self.setProxyFitableFromModel(phase.label, 'cell_length_b',    'b (\u212B)',     phase.cell.b)
            self.setProxyFitableFromModel(phase.label, 'cell_length_c',    'c (\u212B)',     phase.cell.c)
            self.setProxyFitableFromModel(phase.label, 'cell_angle_alpha', 'alpha (\u212B)', phase.cell.alpha)
            self.setProxyFitableFromModel(phase.label, 'cell_angle_beta',  'beta (\u212B)',  phase.cell.beta)
            self.setProxyFitableFromModel(phase.label, 'cell_angle_gamma', 'gamma (\u212B)', phase.cell.gamma)
            #for atomSite in phase.atom_site.label:
                #


        for experiment in self._model.experiments:
            headerList = ['ttheta', 'up', 'up_sigma', 'down', 'down_sigma']
            for column in range(len(headerList)):
                self._experimentalData.insertColumn(column)
            for row in range(len(experiment.meas.ttheta)):
                self._experimentalData.insertRow(row)
                self._experimentalData.setData(self._experimentalData.index(row, 0), experiment.meas.ttheta[row],     TableModel.DataRole)
                self._experimentalData.setData(self._experimentalData.index(row, 1), experiment.meas.up[row],         TableModel.DataRole)
                self._experimentalData.setData(self._experimentalData.index(row, 2), experiment.meas.up_sigma[row],   TableModel.DataRole)
                self._experimentalData.setData(self._experimentalData.index(row, 3), experiment.meas.down[row],       TableModel.DataRole)
                self._experimentalData.setData(self._experimentalData.index(row, 4), experiment.meas.down_sigma[row], TableModel.DataRole)
            for column in range(len(headerList)):
                self._experimentalData.setData(self._experimentalData.index(0, column), headerList[column], TableModel.HeaderRole)
        pprint.pprint(self._project)

        #for datablock in self._model._list_experiment:
        #    tthArray = datablock.get_val('observed_data').get_val('tth')
        #    IntyUpCalcArray, IntyDownCalcArray, _ = datablock.calc_profile(datablock.get_val('observed_data').get_val('tth'), self._model._list_crystal)
        #    headerList = ['2Theta', 'IntUpCalc', 'IntDownCalc']
        #    for column in range(len(headerList)):
        #        self._simulatedData.insertColumn(column)
        #    for row in range(len(tthArray)):
        #        self._simulatedData.insertRow(row)
        #        self._simulatedData.setData(self._simulatedData.index(row, 0), tthArray[row], TableModel.DataRole)
        #        self._simulatedData.setData(self._simulatedData.index(row, 1), IntyUpCalcArray[row], TableModel.DataRole)
        #        self._simulatedData.setData(self._simulatedData.index(row, 2), IntyDownCalcArray[row], TableModel.DataRole)
        #    for column in range(len(headerList)):
        #        self._simulatedData.setData(self._simulatedData.index(0, column), headerList[column], TableModel.HeaderRole)

    def setModelFitableFromProxy(self, phaseLabel, fitableName, fitable):
        fitable.value = self._project[phaseLabel][fitableName]['value']
        fitable.refinement = self._project[phaseLabel][fitableName]['refine']

    def setModelFromProxy(self):
        for phase in self._model.crystals:
            self.setModelFitableFromProxy(phase.label, 'cell_length_a',    phase.cell.a)
            self.setModelFitableFromProxy(phase.label, 'cell_length_b',    phase.cell.b)
            self.setModelFitableFromProxy(phase.label, 'cell_length_c',    phase.cell.c)
            self.setModelFitableFromProxy(phase.label, 'cell_angle_alpha', phase.cell.alpha)
            self.setModelFitableFromProxy(phase.label, 'cell_angle_beta',  phase.cell.beta)
            self.setModelFitableFromProxy(phase.label, 'cell_angle_gamma', phase.cell.gamma)

    def _getFitables(self):
        return self._fitables

    def _getExperimentalData(self):
        return self._experimentalData

    def _getSimulatedData(self):
        return self._simulatedData

    dataChanged = Signal()

    fitables = Property('QVariant', _getFitables, notify=dataChanged)
    experimentalData = Property('QVariant', _getExperimentalData, notify=dataChanged)
    simulatedData = Property('QVariant', _getSimulatedData, notify=dataChanged)

    @Slot(result='QVariant')
    def refine(self):
        pass
        #self._fitables.clear()
        self.setProxyFromModel()
        self.setModelFromProxy()
        #self._model.refine_model()
        #self.setProxyFromModel()

################################################
### MAIN
################################################
# !!!!!https://stackoverflow.com/questions/15306872/return-an-object-in-a-role-in-python-and-get-a-reference-of-another-object-in-qm

if __name__ == '__main__':
    QCoreApplication.setAttribute(Qt.AA_EnableHighDpiScaling)

    app = QApplication(sys.argv)

    currentDir = os.path.dirname(sys.argv[0])
    qmlGuiPath = os.path.join(currentDir, "gui.qml")
    mainRcifPath = os.path.join(currentDir, "cryspy-master", "examples", "Fe3O4_0T_powder_1d_cell", "main.rcif")

    proxy = Proxy(mainRcifPath)

    engine = QQmlApplicationEngine()
    engine.rootContext().setContextProperty("proxy", proxy)
    engine.load(QUrl.fromLocalFile(qmlGuiPath))

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec_())


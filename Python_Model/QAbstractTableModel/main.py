import os, sys
import random, string
import numpy as np

from PySide2.QtCore import QUrl, Qt, QCoreApplication
from PySide2.QtWidgets import QApplication
from PySide2.QtQml import QQmlApplicationEngine

from PySide2.QtCore import QObject, Signal, Slot, Property
from PySide2.QtCore import QAbstractItemModel, QAbstractListModel, QAbstractTableModel
from PySide2.QtCore import QModelIndex, QByteArray

#########
### MODEL
#########

# Qt Help:
# Models can be created directly in QML using ListModel, XmlListModel or ObjectModel,
# or provided by C++ model classes. If a C++ model class is used, it must be a subclass
# of QAbstractItemModel or a simple list.

# EXAMPLES:
# https://spine-toolbox.readthedocs.io/en/dev/_modules/models.html
# https://github.com/eyllanesc/stackoverflow/blob/master/questions/55610163/main.qml
# https://github.com/blikoon/QmlTableViewDemo

class TableModel(QAbstractTableModel):
    HeaderRole = Qt.UserRole + 1
    DataRole = Qt.UserRole + 2

    def __init__(self, parent=None):
        """Class constructor."""
        super().__init__(parent)
        #self._header = list()
        #self._data = list()
        self._header = ["Xobs", "Yobs", "sYobs"]
        self._data = [[i, random.randrange(1000), random.randrange(1000)] for i in range(10)]

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
        #result = QAbstractTableModel.roleNames(self)
        #result[TableModel.HeaderRole] = b'headerRole'
        #result[TableModel.DataRole] = b'dataRole'
        #return result
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

    def entireData(self):
        return self._data

    def entireHeader(self):
        return self._header

    @Slot(int, result=str)
    def header(self, column):
        return self._header[column]

    @Slot()
    def setModelRandomly(self):
        """Random change of header and data in columns 1 and 2."""
        for column in range(self.columnCount()):
            self.setData(self.index(0, column), random.choice(string.ascii_letters), TableModel.HeaderRole)
        for row in range(self.rowCount()):
            self.setData(self.index(row, 1), random.randrange(1000), TableModel.DataRole)
            self.setData(self.index(row, 2), random.randrange(1000), TableModel.DataRole)


#
class FitablesModel(QAbstractListModel):
    NameRole = Qt.UserRole + 1
    ValueRole = Qt.UserRole + 2
    ErrorRole = Qt.UserRole + 3
    RefineRole = Qt.UserRole + 4

    def __init__(self, parent=None):
        """Class constructor."""
        super().__init__(parent)
        #self._fitables = list()
        self._fitables = [
            {'name': 'a', 'value': 3.932, 'error': 0.120, 'refine': True},
            {'name': 'b', 'value': 12.021, 'error': 0, 'refine': False},
            {'name': 'c', 'value': 7.243, 'error': 0, 'refine': False},
        ]

    def rowCount(self, parent=QModelIndex()):
        """Number of rows in the model."""
        return len(self._fitables)

    def roleNames(self):
        return {
            FitablesModel.NameRole: b'nameRole',
            FitablesModel.ValueRole: b'valueRole',
            FitablesModel.ErrorRole: b'errorRole',
            FitablesModel.RefineRole: b'refineRole',
        }

    def clear(self):
        """Clear all data in model."""
        self.beginResetModel()
        self._fitables = list()
        self.endResetModel()

    def data(self, index, role):
        """
        Returns the data stored under the given role for the item referred to by the index.
        """
        if not index.isValid():
            return None
        if role == FitablesModel.NameRole:
            return self._fitables[index.row()]['name']
        if role == FitablesModel.ValueRole:
            return self._fitables[index.row()]['value']
        if role == FitablesModel.ErrorRole:
            return self._fitables[index.row()]['error']
        if role == FitablesModel.RefineRole:
            return self._fitables[index.row()]['refine']
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
        if role == FitablesModel.NameRole:
            self._fitables[index.row()]['name'] = str(value)
            self.dataChanged.emit(index, index, [role])
            return True
        if role == FitablesModel.ValueRole:
            self._fitables[index.row()]['value'] = float(value)
            self.dataChanged.emit(index, index, [role])
            return True
        if role == FitablesModel.ErrorRole:
            self._fitables[index.row()]['error'] = float(value)
            self.dataChanged.emit(index, index, [role])
            return True
        if role == FitablesModel.RefineRole:
            self._fitables[index.row()]['refine'] = bool(value)
            self.dataChanged.emit(index, index, [role])
            return True
        return False

    def entireData(self):
        return self._fitables

    @Slot()
    def setModelRandomly(self):
        for row in range(self.rowCount()):
            self.setData(self.index(row, 0), random.choice(string.ascii_letters), FitablesModel.NameRole)
            self.setData(self.index(row, 0), random.randrange(1000), FitablesModel.ValueRole)
            self.setData(self.index(row, 0), random.random(), FitablesModel.ErrorRole)
            self.setData(self.index(row, 0), bool(random.randrange(2)), FitablesModel.RefineRole)


#########
### MODEL
#########

class PythonModel(QObject):

    def __init__(self, parent=None):
        super().__init__(parent)
        self._experimentalData = TableModel()
        self._fitables = FitablesModel()
        self._project = {}
        self._project["experimental_data"] = {}
        self._project["experimental_data"]["header"] = self._experimentalData.entireHeader()
        self._project["experimental_data"]["data"] = self._experimentalData.entireData()
        self._project["fitables"] = self._fitables.entireData()

    def _getExperimentalData(self):
        return self._experimentalData

    def _getFitables(self):
        return self._fitables

    dataChanged = Signal()

    experimentalData = Property('QVariant', _getExperimentalData, notify=dataChanged)
    fitables = Property('QVariant', _getFitables, notify=dataChanged)

    @Slot(result='QVariant')
    def refine(self):
        self._experimentalData.setModelRandomly()
        self._fitables.setModelRandomly()
        print(self._project)

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

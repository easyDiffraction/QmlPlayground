import os, sys
import random
import numpy as np

from PySide2.QtCore import QUrl, Qt, QCoreApplication
from PySide2.QtWidgets import QApplication
from PySide2.QtQml import QQmlApplicationEngine

from PySide2.QtCore import QObject, Signal, Slot, Property
from PySide2.QtCore import QAbstractListModel, QAbstractTableModel, QModelIndex, QByteArray

from PySide2.QtGui import QStandardItem, QStandardItemModel

from ListModel import *
from TableModel import *

# https://stackoverflow.com/questions/57742024/custom-object-referencing-in-qml-python
# https://stackoverflow.com/questions/44335782/better-way-to-handle-two-way-binding-in-pyqt
# https://bugreports.qt.io/browse/PYSIDE-900
# ! https://pyblish.gitbooks.io/developer-guide/content/qml_and_python_interoperability.html
# ! https://stackoverflow.com/questions/14692690/access-nested-dictionary-items-via-a-list-of-keys







class Proxy(QObject):

    def __init__(self, parent=None):
        super().__init__(parent)
        self._pyString = "initial"

        self._pyListOfInt = [1, 2, 3]
        self._qTable = TableModel()
        #self._pyListOfInt2d = PyListOfInt2d()

        self._pyDict = { "a":1, "b":2, "c": {"x":3, "y":4}, "d": [5, 6, 7] }
        self._qAbstractList = ListModel()




        # !!!
        def createModelFromPyListOfDict88888(listOfDict, parent=None):
            rowCount = len(listOfDict)
            columnCount = len(listOfDict[0])
            model = QStandardItemModel(rowCount, columnCount, parent)
            model.setItemRoleNames({
                Qt.DisplayRole: b'display',
                Qt.EditRole: b'edit',
                Qt.UserRole + 1: b'displayBool'
            })
            #print(model.roleNames())
            for row, item in enumerate(listOfDict):
                for key, value in item.items():
                    column = list(item.keys()).index(key)
                    index = model.index(row, column)
                    role = Qt.DisplayRole
                    #if isinstance(value, bool):
                    #    role = Qt.UserRole + 1
                    model.setData(index, value, role)
                    #model.setHorizontalHeaderItem(column, QStandardItem(key))
                    model.setHorizontalHeaderLabels(["A", "B", "C"])
            return model
        self._pyListOfDict = [
            { "a":1, "b":12.2, "c":True },
            { "a":4, "b":56.6, "c":False },
            { "a":7, "b":81.0, "c":True },
        ]
        #self._qStandardItemModel = createModelFromPyListOfDict(self._pyListOfDict, self)


        # ####################################################################
        # qStandardItemModelFromPyListOfDict
        self._pyListOfDict = [
            { "value":1, "error":12.2, "refine":True },
            { "value":4, "error":56.6, "refine":False },
            { "value":7, "error":81.0, "refine":True },
        ]
        def createModelFromPyListOfDict(listOfDict, parent=None):
            rowCount = len(listOfDict)
            columnCount = len(listOfDict[0])
            model = QStandardItemModel(rowCount, columnCount, parent)
            roleNames = {}
            for key, _ in listOfDict[0].items():
                column = list(listOfDict[0].keys()).index(key)
                roleNames[Qt.UserRole + 1 + column] = key.encode()
            model.setItemRoleNames(roleNames)
            for row, item in enumerate(listOfDict):
                for key, value in item.items():
                    column = list(item.keys()).index(key)
                    index = model.index(row, 0)
                    role = Qt.UserRole + 1 + column
                    model.setData(index, value, role)
            return model
        self._qStandardItemModelFromPyListOfDict = createModelFromPyListOfDict(self._pyListOfDict, self)
        # qStandardItemModelFromPyListOfDict
        # ####################################################################

        # ####################################################################
        # qStandardItemModelFromPyListOfInt2d
        self._pyListOfInt2dHeader = [["2Theta", "Obs", "sObs"]]
        self._pyListOfInt2d = [
            [11, 12, 13],
            [14, 45, 16],
            [17, 18, 19],
        ]
        def createModelFromPyListOfInt2d(array2d, parent=None):
            rowCount = len(array2d)
            columnCount = len(array2d[0])
            model = QStandardItemModel(rowCount, columnCount, parent)
            for row in range(rowCount):
                for column in range(columnCount):
                    index = model.index(row, column)
                    value = array2d[row][column]
                    role = Qt.DisplayRole
                    model.setData(index, value, role)
            return model
        self._qStandardItemModelFromPyListOfInt2d = createModelFromPyListOfInt2d(self._pyListOfInt2d, self)
        self._qStandardItemModelFromPyListOfInt2dHeader = createModelFromPyListOfInt2d(self._pyListOfInt2dHeader, self)
        # qStandardItemModelFromPyListOfInt2d
        # ####################################################################

    # ####################################################################
    # qStandardItemModelFromPyListOfDict
    qStandardItemModelFromPyListOfDictChanged = Signal()
    def getQStandardItemModelFromPyListOfDict(self):
        return self._qStandardItemModelFromPyListOfDict
    qStandardItemModelFromPyListOfDict = Property('QVariant', getQStandardItemModelFromPyListOfDict, notify=qStandardItemModelFromPyListOfDictChanged)
    # qStandardItemModelFromPyListOfDict
    # ####################################################################

    # ####################################################################
    # qStandardItemModelFromPyListOfInt2d
    qStandardItemModelFromPyListOfInt2dChanged = Signal()
    def getQStandardItemModelFromPyListOfInt2d(self):
        return self._qStandardItemModelFromPyListOfInt2d
    qStandardItemModelFromPyListOfInt2d = Property('QVariant', getQStandardItemModelFromPyListOfInt2d, notify=qStandardItemModelFromPyListOfInt2dChanged)
    # qStandardItemModelFromPyListOfInt2d
    # qStandardItemModelFromPyListOfInt2dHeader
    qStandardItemModelFromPyListOfInt2dHeaderChanged = Signal()
    def getQStandardItemModelFromPyListOfInt2dHeader(self):
        return self._qStandardItemModelFromPyListOfInt2dHeader
    qStandardItemModelFromPyListOfInt2dHeader = Property('QVariant', getQStandardItemModelFromPyListOfInt2dHeader, notify=qStandardItemModelFromPyListOfInt2dHeaderChanged)
    # qStandardItemModelFromPyListOfInt2dHeader
    # pyListOfInt2dHeader
    pyListOfInt2dHeaderChanged = Signal()
    def getPyListOfInt2dHeader(self):
        return self._pyListOfInt2dHeader[0]
    pyListOfInt2dHeader = Property('QVariant', getPyListOfInt2dHeader, notify=pyListOfInt2dHeaderChanged)
    # pyListOfInt2dHeader
    # ####################################################################





    #
    # self._qTable
    qStandardItemModelChanged = Signal()
    def getQStandardItemModel(self):
        return self._qStandardItemModel
    qStandardItemModel = Property('QVariant', getQStandardItemModel, notify=qStandardItemModelChanged)




    # self._pyString
    pyStringChanged = Signal()
    def getPyString(self):
        return self._pyString
    def setPyString(self, value):
        self._pyString = value
        self.pyStringChanged.emit()
    pyString = Property(str, fget=getPyString, fset=setPyString, notify=pyStringChanged)

    # self._pyListOfInt
    pyListOfIntChanged = Signal()
    def getPyListOfInt(self):
        return self._pyListOfInt
    def setPyListOfInt(self, data):
        value = float(data.toVariant()[0])
        row = data.toVariant()[1]
        self._pyListOfInt[row] = value
        self.pyListOfIntChanged.emit()
    pyListOfInt = Property('QVariant', getPyListOfInt, setPyListOfInt, notify=pyListOfIntChanged)

    # self._pyDict
    pyDictChanged = Signal()
    def getPyDict(self):
        return self._pyDict
    def setPyDict(self, value):
        self._pyDict = value
        self.pyDictChanged.emit()
    pyDict = Property('QVariant', getPyDict, setPyDict, notify=pyDictChanged)

    # self._qTable
    qTableChanged = Signal()
    def getQAbstractTable(self):
        return self._qTable
    qTable = Property('QVariant', getQAbstractTable, notify=qTableChanged)

    # self._getAbstractList
    qAbstractListChanged = Signal()
    def getQAbstractList(self):
        return self._qAbstractList
    qAbstractList = Property('QVariant', getQAbstractList, notify=qAbstractListChanged)


    # self._pyListOfInt2d
    pyListOfInt2dChanged = Signal()
    def getPyListOfInt2d(self):
        return self._pyListOfInt2d
    def setPyListOfInt2d(self, value):
        self._pyListOfInt2d = value
        self.pyListOfInt2dChanged.emit()
    pyListOfInt2d = Property('QVariant', getPyListOfInt2d, setPyListOfInt2d, notify=pyListOfInt2dChanged)

    # self._pyListOfDict
    pyListOfDictChanged = Signal()
    def getPyListOfDict(self):
        return self._pyListOfDict
    def setPyListOfInt(self, obj):
        self._pyListOfDict = value
        self.pyListOfDictChanged.emit()
    pyListOfDict = Property('QVariant', getPyListOfDict, setPyListOfInt, notify=pyListOfDictChanged)

    # randomChange
    @Slot(result='QVariant')
    def randomChange(self):
        self._qAbstractList.updateModelRandomly()
        self._qTable.updateModelRandomly()


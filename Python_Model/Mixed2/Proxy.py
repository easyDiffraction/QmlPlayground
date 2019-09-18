import os, sys
import random
import numpy as np

from PySide2.QtCore import QUrl, Qt, QCoreApplication
from PySide2.QtWidgets import QApplication
from PySide2.QtQml import QQmlApplicationEngine

from PySide2.QtCore import QObject, Signal, Slot, Property
from PySide2.QtCore import QAbstractListModel, QAbstractTableModel, QModelIndex, QByteArray

from ListModel import *
from TableModel import *

# https://stackoverflow.com/questions/57742024/custom-object-referencing-in-qml-python
# https://stackoverflow.com/questions/44335782/better-way-to-handle-two-way-binding-in-pyqt
# https://bugreports.qt.io/browse/PYSIDE-900
# ! https://pyblish.gitbooks.io/developer-guide/content/qml_and_python_interoperability.html

class Proxy(QObject):

    def __init__(self, parent=None):
        super().__init__(parent)
        self._pyString = "initial"

        self._pyListOfInt = [1, 2, 3]
        self._qAbstractTable = TableModel()
        self._pyListOfInt2d = [
            [11, 12, 13],
            [14, 15, 16],
            [17, 18, 19],
        ]

        self._pyDict = { "a":1, "b":2, "c": {"x":3, "y":4}, "d": [5, 6, 7] }
        self._qAbstractList = ListModel()

        self._pyListOfDict = [
            { "a":1, "b":12.0, "c":True },
            { "a":4, "b":556.2, "c":False },
            { "a":7, "b":81.0, "c":True },
        ]

    # self._pyString
    pyStringChanged = Signal()
    def getPyString(self):
        return self._pyString
    def setPyString(self, value):
        self._pyString = value
        self.pyStringChanged.emit()
    pyString = Property(str, fget=getPyString, fset=setPyString, notify=pyStringChanged)

    # self._pyDict
    pyDictChanged = Signal()
    def getPyDict(self):
        return self._pyDict
    def setPyDict(self, value):
        self._pyDict = value
        self.pyDictChanged.emit()
    pyDict = Property('QVariant', getPyDict, setPyDict, notify=pyDictChanged)

    # self._qAbstractTable
    qAbstractTableChanged = Signal()
    def getQAbstractTable(self):
        return self._qAbstractTable
    qAbstractTable = Property('QVariant', getQAbstractTable, notify=qAbstractTableChanged)

    # self._getAbstractList
    qAbstractListChanged = Signal()
    def getQAbstractList(self):
        return self._qAbstractList
    qAbstractList = Property('QVariant', getQAbstractList, notify=qAbstractListChanged)

    # self._pyListOfInt
    pyListOfIntChanged = Signal()
    def getPyListOfInt(self):
        return self._pyListOfInt
    def setPyListOfInt(self, value):
        self._pyListOfInt = value
        self.pyListOfIntChanged.emit()
    pyListOfInt = Property('QVariant', getPyListOfInt, setPyListOfInt, notify=pyListOfIntChanged)

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
        self._qAbstractTable.updateModelRandomly()


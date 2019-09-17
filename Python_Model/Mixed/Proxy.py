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

class Proxy(QObject):

    def __init__(self, parent=None):
        super().__init__(parent)
        self._list = ListModel()
        self._table = TableModel()

    def _getList(self):
        return self._list

    def _getTable(self):
        return self._table

    dataChanged = Signal()

    list = Property('QVariant', _getList, notify=dataChanged)
    table = Property('QVariant', _getTable, notify=dataChanged)

    @Slot(result='QVariant')
    def randomChange(self):
        self._list.updateModelRandomly()
        self._table.updateModelRandomly()


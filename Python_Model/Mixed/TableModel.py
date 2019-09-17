import os, sys
import random
import numpy as np
import string

from PySide2.QtCore import QUrl, Qt, QCoreApplication
from PySide2.QtWidgets import QApplication
from PySide2.QtQml import QQmlApplicationEngine

from PySide2.QtCore import QObject, Signal, Slot, Property
from PySide2.QtCore import QAbstractListModel, QAbstractTableModel, QModelIndex, QByteArray

class TableModel(QAbstractTableModel):
    HeaderRole = Qt.UserRole + 1
    DataRole = Qt.UserRole + 2

    def __init__(self, parent=None):
        """Class constructor."""
        super().__init__(parent)
        self._header = ["Xobs", "Yobs", "Ycalc"]
        self._data = [[i, random.randrange(100), random.randrange(100)] for i in range(20)]

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
            Qt.DisplayRole: b'display', # returns the same as 'dataRole'; needed for QML ChartView
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

    @Slot(int, result=str)
    def header(self, column):
        """..."""
        return self._header[column]

    @Slot()
    def updateModelRandomly(self):
        """Random change of header and data in columns 1 and 2."""
        for column in range(self.columnCount()):
            self.setData(self.index(0, column), random.choice(string.ascii_letters), TableModel.HeaderRole)
        for row in range(self.rowCount()):
            self.setData(self.index(row, 1), random.randrange(100), TableModel.DataRole)
            self.setData(self.index(row, 2), random.randrange(100), TableModel.DataRole)

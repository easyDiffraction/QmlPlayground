import os, sys
import random
import numpy as np
import string

from PySide2.QtCore import QUrl, Qt, QCoreApplication
from PySide2.QtWidgets import QApplication
from PySide2.QtQml import QQmlApplicationEngine

from PySide2.QtCore import QObject, Signal, Slot, Property
from PySide2.QtCore import QAbstractListModel, QAbstractTableModel, QModelIndex, QByteArray

class ListModel(QAbstractListModel):
    NameRole = Qt.UserRole + 1
    ValueRole = Qt.UserRole + 2
    ErrorRole = Qt.UserRole + 3
    RefineRole = Qt.UserRole + 4

    def __init__(self, parent=None):
        """Class constructor."""
        super().__init__(parent)
        self._list = [
            {'name': 'a', 'value': 3.932,  'error': 0.120, 'refine': True},
            {'name': 'b', 'value': 12.021, 'error': 0,     'refine': False},
            {'name': 'c', 'value': 7.243,  'error': 0,     'refine': False},
        ]

    def rowCount(self, parent=QModelIndex()):
        """Number of rows in the model."""
        return len(self._list)

    def roleNames(self):
        """..."""
        return {
            ListModel.NameRole: b'nameRole',
            ListModel.ValueRole: b'valueRole',
            ListModel.ErrorRole: b'errorRole',
            ListModel.RefineRole: b'refineRole',
        }

    def data(self, index, role):
        """
        Returns the data stored under the given role for the item referred to by the index.
        """
        if not index.isValid():
            return None
        if role == ListModel.NameRole:
            return self._list[index.row()]['name']
        if role == ListModel.ValueRole:
            return self._list[index.row()]['value']
        if role == ListModel.ErrorRole:
            return self._list[index.row()]['error']
        if role == ListModel.RefineRole:
            return self._list[index.row()]['refine']
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
        if role == ListModel.NameRole:
            self._list[index.row()]['name'] = str(value)
            self.dataChanged.emit(index, index, [role])
            return True
        if role == ListModel.ValueRole:
            self._list[index.row()]['value'] = float(value)
            self.dataChanged.emit(index, index, [role])
            return True
        if role == ListModel.ErrorRole:
            self._list[index.row()]['error'] = float(value)
            self.dataChanged.emit(index, index, [role])
            return True
        if role == ListModel.RefineRole:
            self._list[index.row()]['refine'] = bool(value)
            self.dataChanged.emit(index, index, [role])
            return True
        return False

    @Slot(result='QVariant')
    def entireData(self):
        """..."""
        return self._list

    @Slot()
    def updateModelRandomly(self):
        """..."""
        for row in range(self.rowCount()):
            self.setData(self.index(row), random.choice(string.ascii_letters), ListModel.NameRole)
            self.setData(self.index(row), random.randrange(1000), ListModel.ValueRole)
            self.setData(self.index(row), random.random(), ListModel.ErrorRole)
            self.setData(self.index(row), bool(random.randrange(2)), ListModel.RefineRole)


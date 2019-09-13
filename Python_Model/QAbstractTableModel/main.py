import os, sys
import random, string
import numpy as np

from PySide2.QtCore import QUrl, Qt, QCoreApplication
from PySide2.QtWidgets import QApplication
from PySide2.QtQml import QQmlApplicationEngine

from PySide2.QtCore import QObject, Signal, Slot, Property
from PySide2.QtCore import QAbstractListModel, QAbstractTableModel, QModelIndex, QByteArray

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

class ExperimentalDataModel(QAbstractTableModel):

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
        try:
            return len(self._data[0])
        except IndexError:
            return len(self._header)

    def clear(self):
        """Clear all data in model."""
        self.beginResetModel()
        self._data = list()
        self._header = list()
        self.endResetModel()

    def data(self, index, role=Qt.DisplayRole):
        """Returns the data stored under the given role for the item referred to by the index.
        """
        if not index.isValid() or not role == Qt.DisplayRole:
            return None
        try:
            return '{:.4f}'.format(self._data[index.row()][index.column()])
        except IndexError:
            #print("Cannot access model data at index %s", index)
            return None
        except:
            return None

    #@Slot('QModelIndex', str, int, result=bool)
    def setData(self, index, value, role=Qt.EditRole):
        """Set data in model."""
        if not index.isValid() or not role == Qt.EditRole:
            return False
        try:
            self._data[index.row()][index.column()] = float(value)
            self.dataChanged.emit(index, index)
            return True
        except IndexError:
            #print("Cannot access model data at index %s", index)
            return False
        except:
            return False

    @Slot(int, Qt.Orientation, result='QVariant')
    def headerData(self, section, orientation=Qt.Horizontal, role=Qt.DisplayRole):
        """Get headers."""
        if role != Qt.DisplayRole:
            return None
        if orientation == Qt.Horizontal:
            try:
                return self._header[section]
            except IndexError:
                return None
        if orientation == Qt.Vertical:
            return str(section + 1)
        return None

    @Slot(int, Qt.Orientation, 'QVariant', int, result=bool)
    def setHeaderData(self, section, orientation, value, role=Qt.EditRole):
        """Sets the data for the given role and section in the header
        with the specified orientation to the value supplied.
        """
        if orientation != Qt.Horizontal or role != Qt.EditRole :
            return False
        try:
            self._header[section] = str(value)
            self.headerDataChanged.emit(orientation, section, section)
            return True
        except IndexError:
            return False

    @Slot()
    def setModelRandomly(self):
        """Random change of header and data in column=1."""
        for column in range(self.columnCount()):
            self.setHeaderData(column, Qt.Horizontal, random.choice(string.ascii_letters))
        for row in range(self.rowCount()):
            self.setData(self.index(row, 1), random.randrange(1000))

    #def appendRow(self, row):
    #    #for item in row:
    #        #print (item, type(item))
    #    self._data.append(row)
    #    first_column_index = 0
    #    last_column_index = self.columnCount() - 1
    #    last_row_index = self.rowCount() - 1
    #    top_left = self.index(last_row_index, first_column_index)
    #    bottom_right = self.index(last_row_index, last_column_index)
    #    self.dataChanged.emit(top_left, bottom_right, self.roleNames())

    def appendRow(self, row):
        self._data.append(row)

    def setHeaderRow(self, row):
        self._header = row

########
### MAIN
########

if __name__ == '__main__':
    QCoreApplication.setAttribute(Qt.AA_EnableHighDpiScaling)

    app = QApplication(sys.argv)

    experimentalDataModel = ExperimentalDataModel()
    experimentalDataModel.setHeaderRow(["Xobs", "Yobs", "sYobs"])
    for i in range(10):
        experimentalDataModel.appendRow([i, random.randrange(1000), 0.01])

    engine = QQmlApplicationEngine()
    engine.rootContext().setContextProperty("experimentalDataModel", experimentalDataModel)
    engine.load(QUrl.fromLocalFile(os.path.join(os.path.dirname(sys.argv[0]), "gui.qml")))

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec_())

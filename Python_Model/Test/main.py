import os, sys
import random

from PySide2.QtCore import QUrl, Qt, QCoreApplication
from PySide2.QtWidgets import QApplication
from PySide2.QtQml import QQmlApplicationEngine

from PySide2.QtCore import QObject, Signal, Slot, Property
from PySide2.QtCore import QAbstractListModel, QModelIndex, QByteArray

#https://wiki.qt.io/Selectable-list-of-Python-objects-in-QML
#https://wiki.qt.io/Multi-selection-lists-in-Python-with-QML

#########
### MODEL
#########

class FitablesModel(QAbstractListModel):

    def __init__(self, parent=None):
        super().__init__(parent)
        self.fitables = {
            'atom_site_fract_a': {'label': 'a', 'value': 5.125, 'error': 0.274, 'refine': True},
            'atom_site_fract_b': {'label': 'b', 'value': 7.125, 'error': 0.521, 'refine': False},
            'atom_site_fract_c': {'label': 'c', 'value': 4.925, 'error': 0.301, 'refine': False},
        }

    def rowCount(self, parent=None):
        return len(self.fitables)

    #def rowLabel(self, row):
    #    return str(self.fitables[row])

    def data(self, index, role): #role=Qt.DisplayRole
        #if not index.isValid():
        #    return None
        #if role == Qt.DisplayRole or role == Qt.EditRole:
        #    return self.rowLabel(index.row())
        #if role == Qt.UserRole:
        #    return self.fitables[index.row()]
        return self.fitables[index.row()]

#    # Methods accessible from qml via @Slot
#
#    @Slot(str, float, float, float, bool)
#    def append(self, label, x, y, z, refine):
#        self.beginInsertRows(QModelIndex(), self.rowCount(), self.rowCount())
#        self.atom_sites.append({'label':label, 'x':x, 'y':y, 'z':z, 'refine':refine})
#        self.endInsertRows()
#
#    @Slot(int, str, float, float, float, bool)
#    def modify(self, row, label, x, y, z, refine):
#        ix = self.index(row, 0)
#        self.atom_sites[row] = {'label':label, 'x':x, 'y':y, 'z':z, 'refine':refine}
#        self.dataChanged.emit(ix, ix, self.roleNames())
#
#    @Slot(int)
#    def remove(self, row):
#        if row >= 0:
#            self.beginRemoveColumns(QModelIndex(), row, row)
#            del self.atom_sites[row]
#            self.endRemoveRows()
#
#    @Slot()
#    def modifyAtomSiteNo2(self):
#        self.modify(1, 'Tb', random.random(), random.random(), random.random(), True)


# https://github.com/amon-ra/pyside-qml-examples/blob/master/MultiListAnim.py

# TRYT https://github.com/Ultimaker/Uranium/blob/master/UM/Qt/ListModel.py
# AND ? https://stackoverflow.com/questions/48391012/cannot-get-a-qabstractlistmodel-subclass-working-on-pyside2-without-a-hack

class ZenWrapper(QObject):
    def __init__(self, zenItem):
        QObject.__init__(self)
        self._zenItem = zenItem
        self._checked = False

    def _name(self):
        return self._zenItem

    def is_checked(self):
        return self._checked

    def toggle_checked(self):
        self._checked = not self._checked
        self.changed.emit()
        return self._checked

    changed = Signal()

    #name = Property(unicode, _name, notify=changed)
    name = Property(str, _name, notify=changed)
    checked = Property(bool, is_checked, notify=changed)


class ZenListModel(QAbstractListModel):
    def __init__(self, zenItems):
        QAbstractListModel.__init__(self)
        self._zenItems = zenItems
        self._role_names = {0: 'zenItem'}

    #
    def roleNames(self):
        return self._role_names

    def rowCount(self, parent=QModelIndex()):
        return len(self._zenItems)

    def checked(self):
        return [x for x in self._zenItems if x.checked]

    def data(self, index, role):
        if index.isValid() and role == 0:
            return self._zenItems[index.row()]

########
### MAIN
########

if __name__ == '__main__':
    QCoreApplication.setAttribute(Qt.AA_EnableHighDpiScaling)

    app = QApplication(sys.argv)

    fitablesModel = FitablesModel()
    zenItems = [ZenWrapper(zenItem.rstrip()) for zenItem in open(__file__) if zenItem.strip() and not zenItem.startswith(' ')]
    zenItemList = ZenListModel(zenItems)

    engine = QQmlApplicationEngine()
    engine.rootContext().setContextProperty("fitablesModel", fitablesModel)
    engine.rootContext().setContextProperty("pythonListModel", zenItemList)
    engine.load(QUrl.fromLocalFile(os.path.join(os.path.dirname(sys.argv[0]), "gui.qml")))

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec_())

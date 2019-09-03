import os, sys
import random

from PySide2.QtCore import QUrl, Qt, QCoreApplication
from PySide2.QtWidgets import QApplication
from PySide2.QtQml import QQmlApplicationEngine

from PySide2.QtCore import QObject, Signal, Slot
from PySide2.QtCore import QAbstractListModel, QModelIndex, QByteArray

#########
### MODEL
#########

# Qt Help:
# Models can be created directly in QML using ListModel, XmlListModel or ObjectModel,
# or provided by C++ model classes. If a C++ model class is used, it must be a subclass
# of QAbstractItemModel or a simple list.

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

    @Slot(int)
    def remove(self, row):
        if row >= 0:
            self.beginRemoveColumns(QModelIndex(), row, row)
            del self.atom_sites[row]
            self.endRemoveRows()

    @Slot()
    def modifyAtomSiteNo2(self):
        self.modify(1, 'Tb', random.random(), random.random(), random.random(), True)

########
### MAIN
########

if __name__ == '__main__':
    QCoreApplication.setAttribute(Qt.AA_EnableHighDpiScaling)

    app = QApplication(sys.argv)

    atomSiteModel = AtomSiteModel()

    engine = QQmlApplicationEngine()
    engine.rootContext().setContextProperty("atomSiteModel", atomSiteModel)
    engine.load(QUrl.fromLocalFile(os.path.join(os.path.dirname(sys.argv[0]), "gui.qml")))

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec_())

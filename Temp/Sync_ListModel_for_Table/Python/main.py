import os, sys

from PySide2.QtCore import QUrl, Qt, QCoreApplication
from PySide2.QtWidgets import QApplication
from PySide2.QtQml import QQmlApplicationEngine

from PySide2.QtCore import QObject, Signal, Slot
from PySide2.QtCore import QAbstractListModel, QModelIndex, QByteArray



class CellModel (QAbstractListModel):
    a = Qt.UserRole + 1
    b = Qt.UserRole + 2
    c = Qt.UserRole + 3
    alpha = Qt.UserRole + 4
    beta = Qt.UserRole + 5
    gamma = Qt.UserRole + 6

    def __init__(self, parent = None):
        QAbstractListModel.__init__(self, parent)
        self._data = []

    def roleNames(self):
        return {
            CellModel.a : QByteArray(b'a'),
            CellModel.b : QByteArray(b'b'),
            CellModel.c : QByteArray(b'c'),
            CellModel.alpha : QByteArray(b'alpha'),
            CellModel.beta : QByteArray(b'beta'),
            CellModel.gamma : QByteArray(b'gamma'),
        }

    def rowCount(self, index):
        return len(self._data)

    def data(self, index, role):
        d = self._data[index.row()]

        if role == CellModel.a:
            return d['a']
        elif role == CellModel.b:
            return d['b']
        elif role == CellModel.c:
            return d['c']
        elif role == CellModel.alpha:
            return d['alpha']
        elif role == CellModel.beta:
            return d['beta']
        elif role == CellModel.gamma:
            return d['gamma']
        return None

    def append(self, row):
        self._data.append(row)

    @Slot()
    def refine(self):
        print(self._data)
        self._data[0]['b'] = '99.99'
        print(self._data)
        #self.dataChanged.emit(index, index, self._roles)
        #self.dataChanged.emit(0, 1, self._roles)





#


if __name__ == '__main__':
    QCoreApplication.setAttribute(Qt.AA_EnableHighDpiScaling)

    app = QApplication(sys.argv)

    engine = QQmlApplicationEngine()
    engine.addImportPath(os.path.join(os.path.dirname(sys.argv[0]), "..", "Qml", "Imports"))

    cellModel = CellModel()
    #cellModel.populate()
    cellModel.append({ 'a':'12.11', 'b':'3.11', 'c':'6.11', 'alpha':'90.11', 'beta':'72.11', 'gamma':'112.11' })
    engine.rootContext().setContextProperty("cellModel", cellModel)

    engine.load(QUrl.fromLocalFile(os.path.join(os.path.dirname(sys.argv[0]), "..", "Qml", "main.qml")))

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec_())

import os, sys

from PySide2.QtCore import QUrl, Qt, QCoreApplication
from PySide2.QtWidgets import QApplication
from PySide2.QtQml import QQmlApplicationEngine

from PySide2.QtCore import QObject, Signal, Slot
from PySide2.QtCore import QAbstractListModel, QModelIndex, QByteArray




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
            PersonModel.atom_site_label_role: b'label',
            PersonModel.atom_site_fract_x_role: b'x',
            PersonModel.atom_site_fract_y_role: b'y',
            PersonModel.atom_site_fract_z_role: b'z',
            PersonModel.refine_role: b'refine'
        }

    def data(self, index, role=Qt.DisplayRole):
        row = index.row()
        if role == PersonModel.atom_site_label_role:
            return self.atom_sites[row]['label']
        if role == PersonModel.atom_site_fract_x_role:
            return self.atom_sites[row]['x']
        if role == PersonModel.atom_site_fract_y_role:
            return self.atom_sites[row]['y']
        if role == PersonModel.atom_site_fract_z_role:
            return self.atom_sites[row]['z']
        if role == PersonModel.refine_role:
            return self.atom_sites[row]['refine']

    @Slot(str, float, float, float, bool)
    def addPerson(self, label='H', x=0.0, y=0.0, z=0.0, refine=False):
        self.beginInsertRows(QModelIndex(), self.rowCount(), self.rowCount())
        self.atom_sites.append({'label':label, 'x':x, 'y':y, 'z':z, 'refine':refine})
        self.endInsertRows()

    @Slot(int, str, int, bool)
    def editPerson(self, row, label, x, y, z, refine):
        ix = self.index(row, 0)
        self.atom_sites[row] = {'label':label, 'x':x, 'y':y, 'z':z, 'refine':refine}
        self.dataChanged.emit(ix, ix, self.roleNames())

    @Slot(int)
    def deletePerson(self, row):
        if row >= 0:
            self.beginRemoveColumns(QModelIndex(), row, row)
            del self.atom_sites[row]
            self.endRemoveRows()

    #
    @Slot()
    def refineIt(self):
        self.editPerson(1, "NAME", 100, True)






# !!! https://www.riverbankcomputing.com/static/Docs/PyQt5/qml.html




# !!! https://stackoverflow.com/questions/46814961/how-to-insert-edit-qabstractlistmodel-in-python-and-qml-updates-automatically
# !! https://stackoverflow.com/questions/54687953/declaring-a-qabstractlistmodel-as-a-property-in-pyside2
# If you want to filter data, the simplest and most recommendable is to use a QSortFilterProxyModel
# https://stackoverflow.com/questions/50609986/how-to-connect-python-and-qml-with-pyside2


class PersonModel(QAbstractListModel):

    NameRole = Qt.UserRole + 1
    AgeRole = Qt.UserRole + 2
    RefineRole = Qt.UserRole + 3

    ###personChanged = Signal()

    def __init__(self, parent=None):
        super().__init__(parent)
        self.persons = [
            #{'name': 'Name', 'age': 'Age', 'refine': 'Fit'},
            {'name': 'jon', 'age': 20, 'refine': True},
            {'name': 'jane', 'age': 25, 'refine': False}
        ]

    def data(self, index, role=Qt.DisplayRole):
        row = index.row()
        if role == PersonModel.NameRole:
            return self.persons[row]["name"]
        if role == PersonModel.AgeRole:
            return self.persons[row]["age"]
        if role == PersonModel.RefineRole:
            return self.persons[row]["refine"]

    def rowCount(self, parent=QModelIndex()):
        return len(self.persons)

    def roleNames(self):
        return {
            PersonModel.NameRole: b'name',
            PersonModel.AgeRole: b'age',
            PersonModel.RefineRole: b'refine'
        }

    @Slot(str, int, bool)
    def addPerson(self, name, age, refine):
        self.beginInsertRows(QModelIndex(), self.rowCount(), self.rowCount())
        self.persons.append({'name': name, 'age': age, 'refine': refine})
        self.endInsertRows()

    @Slot(int, str, int, bool)
    def editPerson(self, row, name, age, refine):
        ix = self.index(row, 0)
        self.persons[row] = {'name': name, 'age': age, 'refine': refine}
        self.dataChanged.emit(ix, ix, self.roleNames())

    @Slot(int)
    def deletePerson(self, row):
        if row >= 0:
            self.beginRemoveColumns(QModelIndex(), row, row)
            del self.persons[row]
            self.endRemoveRows()

    #
    @Slot()
    def refineIt(self):
        self.editPerson(1, "NAME", 100, True)











class MyModel (QAbstractListModel):
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



## http://docs.glueviz.org/en/v0.7.2/_modules/glue/utils/qt/python_list_model.html
## https://github.com/glue-viz/glue/blob/master/glue/utils/qt/python_list_model.py
## !!!! https://github.com/glue-viz/glue/
class PythonListModel(QAbstractListModel):

    """
    A Qt Model that wraps a python list, and exposes a list-like interface

    This can be connected directly to multiple QListViews, which will
    stay in sync with the state of the container.
    """

    def __init__(self, items, parent=None):
        """
        Create a new model

        Parameters
        ----------
        items : list
            The initial list to wrap
        parent : QObject
            The model parent
        """
        QAbstractListModel.__init__(self, parent)
        self.items = items
        print("!!!", len(self.items))


    def rowCount(self, parent=None):
        """Number of rows"""
        return len(self.items)

    def headerData(self, section, orientation, role):
        """Column labels"""
        if role != Qt.DisplayRole:
            return None
        return "%i" % section

    def row_label(self, row):
        """ The textual label for the row"""
        return str(self.items[row])

    def data(self, index, role):
        """Retrieve data at each index"""
        if not index.isValid():
            return None
        if role == Qt.DisplayRole or role == Qt.EditRole:
            return self.row_label(index.row())
        if role == Qt.UserRole:
            return self.items[index.row()]

    def setData(self, index, value, role):
        """
        Update the data in-place

        Parameters
        ----------
        index : QModelIndex
            The location of the change
        value : object
            The new value
        role : QEditRole
            Which aspect of the model to update
        """
        if not index.isValid():
            return False

        if role == Qt.UserRole:
            row = index.row()
            self.items[row] = value
            self.dataChanged.emit(index, index)
            return True

        return QAbstractListModel.setDdata(index, value, role)






#####################################
#https://forum.qt.io/topic/102667/ui-doesn-t-update-when-python-qabstractlistmodel-changes-from-a-thread
#https://forum.qt.io/topic/42020/solved-qabstractlistmodel-update-data-in-table-view-linux
#https://stackoverflow.com/questions/43792138/qlistview-refuses-to-show-subclassed-qabstractlistmodel/43797479#43797479
#https://stackoverflow.com/questions/6444783/pyqt-and-listmodel

#https://wiki.python.org/moin/PyQt/A%20custom%20Python%20class-based%201D%20model

#https://stackoverflow.com/questions/33579403/qabstractitemmodel-set-check-state-automatically
#http://rowinggolfer.blogspot.com/2010/05/qtreeview-and-qabractitemmodel-example.html

#!? https://github.com/divan/ankiqml/blob/master/ankiqml





class CellModel (QAbstractListModel):
    aRole = Qt.UserRole + 1
    bRole = Qt.UserRole + 2
    cRole = Qt.UserRole + 3
    alphaRole = Qt.UserRole + 4
    betaRole = Qt.UserRole + 5
    gammaRole = Qt.UserRole + 6

    def __init__(self, parent = None):
        QAbstractListModel.__init__(self, parent)
        self._data = []

    def roleNames(self):
        return {
            #Qt.DisplayRole : QByteArray(b'display')
            CellModel.aRole : QByteArray(b'a'),
            CellModel.bRole : QByteArray(b'b'),
            CellModel.cRole : QByteArray(b'c'),
            CellModel.alphaRole : QByteArray(b'alpha'),
            CellModel.betaRole : QByteArray(b'beta'),
            CellModel.gammaRole : QByteArray(b'gamma'),
        }

    #????
    def rowCount(self, parent): #parent=QModelIndex()
        return len(self._data)

    def data(self, index, role):
        d = self._data[index.row()]

        #if role == Qt.DisplayRole:
        #    return d['name']
        if role == CellModel.aRole:
            return d['a']
        elif role == CellModel.bRole:
            return d['b']
        elif role == CellModel.cRole:
            return d['c']
        elif role == CellModel.alphaRole:
            return d['alpha']
        elif role == CellModel.betaRole:
            return d['beta']
        elif role == CellModel.gammaRole:
            return d['gamma']
        return None

    #@Slot(int, str, float)
    def setData(self, index, role, value):
        print(self._data)
        print(index.row(), index.column(), role, type(role))

        #self._data[index][role] = value
        #self._data[index.row()][role] = value
        #self._data[index][role] = value
        #self.dataChanged.emit(index, index)
        self._data[index.row()][index.column()] = value
        self.dataChanged.emit(index, index, [role])
        ###self.dataChanged.emit()
        ###self._data[index][role] = value
        print(self._data)
        return True


        #if role == CellModel.a:
        #    self._data[index.row()] = value
        #    self.dataChanged.emit(index, index)
        #    print("1", self._data)
        #    return True

        #print("0", self._data)
        #return False


    #    if role == CellModel.a:
    #        return d['a']
    #    elif role == CellModel.b:
    #        return d['b']

    def append(self, row):
        self._data.append(row)

    #????
    #def appendRow

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

    pythonListModel = PythonListModel({ 'x':20, 'y':30, 'z':40  })
    engine.rootContext().setContextProperty("pythonListModel", pythonListModel)

    #print(pythonListModel.x)
#    print(pythonListModel.rowCount())
#    print(pythonListModel.data(0, 0))


    personModel = PersonModel()
    engine.rootContext().setContextProperty("personModel", personModel)
    #print("1", personModel.data(0))



    cellModel = CellModel()
    #cellModel.populate()
    cellModel.append({ 'a':'12.11', 'b':'3.11', 'c':'6.11', 'alpha':'90.11', 'beta':'72.11', 'gamma':'112.11' })
    engine.rootContext().setContextProperty("cellModel", cellModel)

    engine.load(QUrl.fromLocalFile(os.path.join(os.path.dirname(sys.argv[0]), "..", "Qml", "main.qml")))

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec_())

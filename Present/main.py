import os, sys, random
from PySide2.QtCore import Qt, QUrl, QObject, Signal, Slot
from PySide2.QtGui import QStandardItem, QStandardItemModel
from PySide2.QtQml import QQmlApplicationEngine
from PySide2.QtWidgets import QApplication, QUndoStack, QUndoCommand

# https://stackoverflow.com/questions/55257134/how-can-i-change-all-the-points-in-an-xyseries-in-qml-or-pyside2/55258085

class AppendCommand(QUndoCommand):
    def __init__(self, dictionary, key, value):
        QUndoCommand.__init__(self)
        print(dictionary)
        self._dictionary = dictionary
        print(self._dictionary)
        self._key = key
        self._value = value

    def undo(self):
        self.setText("     undo command {} - {}:{} = ".format(self._dictionary, self._key, self._value))
        print(self._dictionary)
        del self._dictionary[self._key]

    def redo(self):
        self.setText("  do/redo command {} + {}:{} = ".format(self._dictionary, self._key, self._value))
        print(self._dictionary)
        self._dictionary[self._key] = self._value


class ModifyCommand(QUndoCommand):
    def __init__(self, dictionary, key, value):
        QUndoCommand.__init__(self)
        self._dictionary = dictionary
        self._key = key
        self._old_value = dictionary[key]
        self._new_value = value
        self.setText("   modify command")

    def undo(self):
        #self.setText("     undo command {} - {}:{} = ".format(self._dictionary, self._key, self._value))
        self._dictionary[self._key] = self._old_value

    def redo(self):
        #self.setText("  do/redo command {} + {}:{} = ".format(self._dictionary, self._key, self._value))
        self._dictionary[self._key] = self._new_value


class ModifyCommand2(QUndoCommand):
    def __init__(self, dictionary, key, value):
        QUndoCommand.__init__(self)
        self._key = key
        self._old_value = dictionary[key]
        self._new_value = value
        self.setText("   modify command")

    def undo(self, dictionary):
        #self.setText("     undo command {} - {}:{} = ".format(self._dictionary, self._key, self._value))
        dictionary[self._key] = self._old_value

    def redo(self, dictionary):
        #self.setText("  do/redo command {} + {}:{} = ".format(self._dictionary, self._key, self._value))
        dictionary[self._key] = self._new_value


if __name__ == '__main__!!!':

    undo_stack = QUndoStack()

    dictionary = {"a": "AAA", "b": "BBB"}
    print('* initial dict', dictionary)

    undo_stack.push(AppendCommand(dictionary, "c", "CCC"))
    print(undo_stack.undoText(), dictionary)

    undo_stack.push(AppendCommand(dictionary, "d", "DDD"))
    print(undo_stack.undoText(), dictionary)

    undo_stack.undo()
    print(undo_stack.redoText(), dictionary)

    undo_stack.undo()
    print(undo_stack.redoText(), dictionary)

    undo_stack.redo()
    print(undo_stack.undoText(), dictionary)

    undo_stack.push(ModifyCommand(dictionary, "a", "---"))
    print(undo_stack.undoText(), dictionary)

    undo_stack.undo()
    print(undo_stack.redoText(), dictionary)

    undo_stack.redo()
    print(undo_stack.undoText(), dictionary)

    undo_stack.push(ModifyCommand2(dictionary, "b", "---"))
    print(undo_stack.undoText(), dictionary)

    undo_stack.undo(dictionary)
    print(undo_stack.redoText(), dictionary)

    undo_stack.redo(dictionary)
    print(undo_stack.undoText(), dictionary)


class XyArrayModel(QStandardItemModel):
    def __init__(self, parent=None):
        super().__init__(parent)
        self.column_count = 2
        self.row_count = 25
        self.setRowCount(self.row_count)
        self.setColumnCount(self.column_count)
        self.setX()
        self.setY()

    def setX(self):
        for i in range(self.rowCount()):
            x = i
            item = QStandardItem()
            item.setData(x, Qt.DisplayRole)
            self.setItem(i, 0, item)

    @Slot()
    def setY(self):
        a = 3
        b = -5
        c = 100
        for i in range(self.rowCount()):
            y = a * i ** 2 + b * i + c * random.random() * (-1)**i
            item = QStandardItem()
            item.setData(y, Qt.DisplayRole)
            self.setItem(i, 1, item)


if __name__ == '__main__':
    app = QApplication(sys.argv)

    engine = QQmlApplicationEngine()

    dict = {"quadratic": {"a": 3, "b": -5, "c": 100}}
    engine.rootContext().setContextProperty("pyDict", dict)

    model = XyArrayModel()
    engine.rootContext().setContextProperty("pyModel", model)

    qml_local_file = os.path.join(os.path.dirname(sys.argv[0]), "main.qml")
    engine.load(QUrl.fromLocalFile(qml_local_file))

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec_())

import os, sys
import random
import numpy as np

from PySide2.QtCore import QUrl, Qt, QCoreApplication
from PySide2.QtWidgets import QApplication
from PySide2.QtQml import QQmlApplicationEngine

from PySide2.QtCore import QObject, Signal, Slot, Property
from PySide2.QtCore import QAbstractListModel, QAbstractTableModel, QModelIndex, QByteArray

from Proxy import *

if __name__ == '__main__':
    QCoreApplication.setAttribute(Qt.AA_EnableHighDpiScaling)

    app = QApplication(sys.argv)

    proxy = Proxy()

    engine = QQmlApplicationEngine()
    engine.rootContext().setContextProperty("proxy", proxy)
    engine.load(QUrl.fromLocalFile(os.path.join(os.path.dirname(sys.argv[0]), "Gui.qml")))

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec_())


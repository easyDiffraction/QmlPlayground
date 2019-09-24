import os, sys

from PySide2.QtCore import QUrl, Qt, QCoreApplication
from PySide2.QtWidgets import QApplication
from PySide2.QtQml import QQmlApplicationEngine

from Python.Proxy import *

if __name__ == '__main__':
    QCoreApplication.setAttribute(Qt.AA_EnableHighDpiScaling)

    app = QApplication(sys.argv)

    current_dir = os.path.dirname(sys.argv[0])
    qml_gui_path = os.path.join(current_dir, "Gui.qml")
    main_rcif_path = os.path.join(current_dir, "cryspy-master", "examples", "Fe3O4_0T_powder_1d_cell", "main.rcif")

    proxy = Proxy(main_rcif_path)

    engine = QQmlApplicationEngine()
    engine.rootContext().setContextProperty("proxy", proxy)
    engine.load(QUrl.fromLocalFile(qml_gui_path))

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec_())


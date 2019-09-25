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
    main_rcif_path = os.path.join(current_dir, "cryspy-master", "examples", "Fe3O4_0T_powder_1d", "main.rcif")

    # --- modify rcif ---
    main_rcif_content = ""
    with open(main_rcif_path, 'r') as f:
        for line in f.readlines():
            if '_cell_length_a' in line:
                line = '_cell_length_a 8.7' + '\r\n' # 8.6 very long. 8.7 ok. 8.5621 fitted.
            if 'Fe3A cani' in line:
                line = 'Fe3A cani  -2.2 -3.46822 -3.46822 0.0 0.0 0.0' + '\r\n'
            if 'Fe3B cani' in line:
                line = 'Fe3B cani   1.1  3.041    3.041   0.0 0.0 0.0' + '\r\n'
            main_rcif_content += line
    with open(main_rcif_path, 'w') as f:
        f.write(main_rcif_content)
    # --- modify rcif ---

    proxy = Proxy(main_rcif_path)

    engine = QQmlApplicationEngine()
    engine.rootContext().setContextProperty("proxy", proxy)
    engine.load(QUrl.fromLocalFile(qml_gui_path))

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec_())


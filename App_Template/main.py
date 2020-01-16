import os
import sys
import random
from PySide2.QtCore import QUrl, QObject, Slot
from PySide2.QtQml import QQmlApplicationEngine
from PySide2.QtWidgets import QApplication


if __name__ == '__main__':
    current_dir_path = os.path.dirname(sys.argv[0])
    qml_local_file = os.path.join(current_dir_path, "Gui", "main.qml")
    qml_imports_dir_path = str(QUrl.fromLocalFile(current_dir_path).toString())

    app = QApplication(sys.argv)

    engine = QQmlApplicationEngine()
    engine.addImportPath(qml_imports_dir_path)
    engine.load(QUrl.fromLocalFile(qml_local_file))

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec_())

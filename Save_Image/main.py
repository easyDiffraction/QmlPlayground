import os, sys

from PySide2.QtCore import QUrl, Qt, QCoreApplication
from PySide2.QtWidgets import QApplication
from PySide2.QtQml import QQmlApplicationEngine

if __name__ == '__main__':
    QCoreApplication.setAttribute(Qt.AA_EnableHighDpiScaling)

    app = QApplication(sys.argv)

    current_dir = os.path.dirname(sys.argv[0])
    image_fpath = os.path.join(current_dir, "test.png")
    qml_fpath = os.path.join(current_dir, "gui.qml")

    engine = QQmlApplicationEngine()
    engine.rootContext().setContextProperty("imageFilePath", image_fpath)

    engine.load(QUrl.fromLocalFile(qml_fpath))

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec_())

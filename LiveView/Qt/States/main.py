import os
import sys
import random
from PySide2.QtCore import QUrl, QObject, Slot
from PySide2.QtQml import QQmlApplicationEngine
from PySide2.QtWidgets import QApplication


class HelloMessage(QObject):
    def __init__(self):
        QObject.__init__(self)
        self.hello = ["Hello World", "Hallo Welt", "Hei maailma", "Hola Mundo"]

    @Slot(result=str)
    def randomHello(self):
        return random.choice(self.hello)


if __name__ == '__main__':
    app = QApplication(sys.argv)

    qml_local_file = os.path.join(os.path.dirname(sys.argv[0]), "window.qml")

    engine = QQmlApplicationEngine()
    engine.load(QUrl.fromLocalFile(qml_local_file))

    msg = HelloMessage()
    engine.rootContext().setContextProperty("helloMessage", msg)

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec_())

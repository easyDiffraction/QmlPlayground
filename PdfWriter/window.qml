import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Window 2.0

Window {
    property var hello: ["Hello World", "Hallo Welt", "Hei maailma", "Hola Mundo"]

    visible: true
    width: 200
    height: 200

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20

        Label { id: label; text: "Initial label text" }

        Button {
            text: "Click me"
            onClicked: label.text = hello[Math.floor(Math.random() * hello.length)]
        }
    }

    void MainWindow::writePdf()
    {
    const QString filename("D://Programme/QT/MeineProjekte/Projekt/test.pdf");

    QString testData = "test";
    QPdfWriter pdfwriter(filename);
    pdfwriter.setPageSize(QPageSize(QPageSize::A4));
    QPainter painter(&pdfwriter);
    painter.drawText(0,0, testData);
    }
}

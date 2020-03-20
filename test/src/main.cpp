#include <QApplication>
#include <QIcon>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    qputenv("QT_QUICK_CONTROLS_STYLE", "Material");
    qputenv("QT_QUICK_CONTROLS_MATERIAL_VARIANT", "Dense");

    QApplication app(argc, argv);
    app.setApplicationName("Covid19");
    app.setOrganizationName("sazonov.org");
    app.setOrganizationDomain("sazonov.org");
    app.setWindowIcon(QIcon(":/qml/AsQuick/Resources/Icon/App.png"));

    QQmlApplicationEngine appEngine;
    appEngine.addImportPath(":/qml");
    appEngine.load("qrc:/qml/main.qml");

    return app.exec();
}

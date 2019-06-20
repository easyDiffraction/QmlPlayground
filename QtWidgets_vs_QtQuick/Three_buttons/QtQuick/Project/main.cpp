#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.load("qrc:/window.qml");

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}



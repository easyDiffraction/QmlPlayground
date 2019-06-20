// https://doc.qt.io/qt-5/qtqml-cppintegration-contextproperties.html
// https://doc.qt.io/qt-5/qtqml-cppintegration-topic.html
// https://forum.qt.io/topic/58897/solved-q_invokable-vs-q_property-qml-hanging

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "HelloMessage.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.load("qrc:/window.qml");

    HelloMessage msg;
    engine.rootContext()->setContextProperty("helloMessage", &msg);

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}

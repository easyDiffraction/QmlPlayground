TEMPLATE = app

# Application name
TARGET = covid19

CONFIG += c++14

# Makes compiler emit warnings if deprecated feature is used
DEFINES += QT_DEPRECATED_WARNINGS

QT += widgets qml charts

SOURCES += logic/main.cpp

RESOURCES += resources.qrc

# To resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH += gui

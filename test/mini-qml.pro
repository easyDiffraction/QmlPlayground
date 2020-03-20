TEMPLATE = app
TARGET = mini-qml

CONFIG += \
    c++14

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

#QT += gui qml widgets charts
#QT += qml quick quickcontrols2 charts
#QT += gui widgets qml quick quickcontrols2 charts
QT += widgets qml charts

# HEADERS +=

SOURCES += \
    src/main.cpp

RESOURCES += \
    resources.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH += \
    qml

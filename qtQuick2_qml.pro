QT += qml quick core gui

CONFIG += c++11

SOURCES += cpp\main.cpp \
    cpp\datastorage.cpp \
    cpp\PlayerTank.cpp

RESOURCES += qrc\qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    cpp\datastorage.h \
    cpp\PlayerTank.h

DISTFILES += \
    qml\Bullet.qml

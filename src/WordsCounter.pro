QT += qml quick charts

CONFIG += c++17
CONFIG += qtquickcompiler

CONFIG(release, debug|release) {
    CONFIG += optimize_full
}

TARGET = WordsCounter

VERSION = 1.0.0

win32-msvc* {
    QMAKE_CFLAGS += /MP
    QMAKE_CXXFLAGS += /MP
    QMAKE_CXXFLAGS += /utf-8
}

QMAKE_TARGET = $${TARGET}
QMAKE_TARGET_PRODUCT = $${TARGET}
QMAKE_TARGET_COMPANY = "Lukin Alexey"
QMAKE_TARGET_DESCRIPTION = "WordsCounter"
QMAKE_TARGET_COPYRIGHT = "Copyright (c) 2022 Lukin Alexey"

DEFINES += QT_DEPRECATED_WARNINGS
DEFINES += APP_PRODUCT=\\\"$$QMAKE_TARGET_PRODUCT\\\"
DEFINES += APP_VERSION=\\\"$$VERSION\\\"

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

SOURCES += main.cpp \
    core.cpp \
    utils.cpp \
    worker.cpp

HEADERS += \
    core.h \
    utils.h \
    worker.h

RESOURCES += \
    resources.qrc

DESTDIR = bin
MOC_DIR = moc
OBJECTS_DIR = obj
RCC_DIR = rcc
UI_DIR = ui

win32-msvc* {
    QMAKE_EXTRA_TARGETS += before_build makefilehook
    makefilehook.target = $(MAKEFILE)
    makefilehook.depends = .beforebuild
    PRE_TARGETDEPS += .beforebuild
    before_build.target = .beforebuild
    before_build.depends = FORCE
    before_build.commands = chcp 1251
}

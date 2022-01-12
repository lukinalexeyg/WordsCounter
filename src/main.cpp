#include "core.h"

#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQml>



int main(int argc, char *argv[])
{
    qApp->setApplicationName(APP_PRODUCT);
    qApp->setApplicationVersion(APP_VERSION);
    qApp->setOrganizationName(QStringLiteral("Alexey Lukin"));
    qApp->setOrganizationDomain(QString());
    qApp->setAttribute(Qt::AA_EnableHighDpiScaling);

    QApplication app(argc, argv);

    Core core;

    QQmlApplicationEngine engine;
    QQmlContext *qmlContext = engine.rootContext();

    qmlContext->setContextProperty(QStringLiteral("Core"), &core);
    qmlContext->setContextProperty(QStringLiteral("qtVersion"), qVersion());
    qmlRegisterSingletonType(QUrl(QStringLiteral("qrc:/qml/themes/Theme.qml")), "Theme", 1, 0, "Theme");

    engine.addImportPath(QStringLiteral("qrc:/qml"));
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "main.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    // This loads Main.qml from the videoLusor module
    engine.addImportPath(":/");
    engine.loadFromModule("simplePlayer", "Main");

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
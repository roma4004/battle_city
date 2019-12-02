#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>
#include "logics.h"
#include <ctime>
int main(int argc, char *argv[]){
    srand(static_cast <unsigned int>(time(0) ) );
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QQmlContext *context = engine.rootContext();

    logics gameLogics;
    context->setContextProperty("Cpp", &gameLogics);

    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml") ) );
  //engine.load(QUrl(QLatin1String ("qrc:/qml/Main.qml") ) );
  // engine.load(QUrl::fromLocalFile("main.qml"));

    return app.exec();
}

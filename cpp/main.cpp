#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>
#include "datastorage.h"
#include "PlayerTank.h"
#include <ctime>
int main(int argc, char *argv[]){
    srand(time(NULL) );
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QQmlContext *context = engine.rootContext();

    DataStorage ds;
    context->setContextProperty("Cpp", &ds);

  //PlayerTank tankP1;
  //context->setContextProperty("P1", &tankP1);

    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml") ) );
  //engine.load(QUrl(QLatin1String("qrc:/qml/main.qml") ) );


    QObject *rof = engine.rootObjects().first();
    QVariant firstArg("arg++");
    QVariant retValue;
    QMetaObject::invokeMethod(rof,
                              "functionInJavascript",
                              Q_RETURN_ARG(QVariant, retValue),
                              Q_ARG(QVariant, firstArg) );
    qDebug() << "Return value from javascript :" << retValue.toString();

    return app.exec();
}

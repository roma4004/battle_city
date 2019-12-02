#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>
#include <ctime>
#include "bcthread.h"

int main(int argc, char *argv[]){
    srand(static_cast <unsigned int>(time(0) ) );
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QQmlContext *context = engine.rootContext();

    BCThread gameLogicsForEn1;
    context->setContextProperty("ThreadE1", &gameLogicsForEn1);
    QThread *thread1 = new QThread;
    gameLogicsForEn1.moveToThread(thread1);
    thread1->start();    

    BCThread gameLogicsForEn2;
    context->setContextProperty("ThreadE2", &gameLogicsForEn2);
    QThread *thread2 = new QThread;
    gameLogicsForEn2.moveToThread(thread2);
    thread2->start();    

    BCThread gameLogicsForPn;
    context->setContextProperty("ThreadP", &gameLogicsForPn);
    QThread *thread3 = new QThread;
    gameLogicsForPn.moveToThread(thread3);
    thread3->start();

    //Logics gameLogics;
    //context->setContextProperty("Cpp", &gameLogics);

    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml") ) );
  //engine.load(QUrl(QLatin1String ("qrc:/qml/Main.qml") ) );
  // engine.load(QUrl::fromLocalFile("main.qml"));

    return app.exec();
}

#ifndef BCTHREAD_H
#define BCTHREAD_H

#include <QThread>
#include <QQuickItem>
#include <QObject>
#include <QSet>

class BCThread : public QThread
{
    Q_OBJECT
public:
    explicit BCThread();
    void run();

public slots:
    QString getRandomFrom         (QVector<QString> &variants);
    QSet<QQuickItem*> findColInLine(QQuickItem *field, QString lineType, float lineEnd, float startX, float startY, int step);
    void getBulletColliders        (const QVariant &Field, const QVariant &object, const QVariant &whoShotObj);
    void takeDamage                (QQuickItem *field,  QQuickItem *hitObj, int minDamage, int maxDamage, QQuickItem *whoShotObj);
    void checkForBonus             (QQuickItem *field,  QQuickItem *obj, QSet<QQuickItem *> &colliders);
    bool checkObjectByDirection    (QQuickItem *target, QQuickItem *obj, QString setDirection);
    bool isCanMove                 (const QVariant &Field, const QVariant &object, QString setDirr, float maxWidth,       float maxHeight);
    void makeBonus                 (const QVariant &Field, const QVariant &object, QString imgName = "none", float setX = 0, float setY = 0);
    void moveObj                   (const QVariant &Field, const QVariant &object, QString setDirr, float maxWidth,       float maxHeight);
    bool mayShootAI                (const QVariant &Field, const QVariant &object,                  float maxWidth,       float maxHeight);
    void setRandomDirectionAI      (const QVariant &Field, const QVariant &object,                  float maxWidth,       float maxHeight);
    void setRandomXY               (const QVariant &Field, const QVariant &object,                  float    Width = 0.0, float    Height = 0.0);
    void makeShoot                 (const QVariant &whoShotObj, const QVariant &bulletObj);
    int getRandomInt(int min, int max);

};
#endif // BCTHREAD_H

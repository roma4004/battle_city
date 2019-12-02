#ifndef logics_H
#define logics_H
#include <QQuickItem>
#include <QObject>
#include <QSet>
class logics : public QObject{
    Q_OBJECT

public:
    explicit logics(QObject *parent = 0);

signals:

public slots:
    QString getRandomFrom         (std::vector<QString> variants);
    QSet<QQuickItem*> getColInLine(QQuickItem *field, QString lineType, float lineEnd, float startX, float startY, int step);
    void takeDamage               (QQuickItem *field, QQuickItem *hitObj, int bulletMinDamage, int bulletMaxDamage, QQuickItem *whoShotObj);
    void checkForBonus            (QQuickItem *field, QQuickItem *obj, QSet<QQuickItem*> colliders);
    bool checkObjectByDirection   (QQuickItem *target, QQuickItem *obj, QString setDirection);
    bool isCanMoveAI              (const QVariant &Field, const QVariant &object, QString setDirr, float maxWidth,       float maxHeight);
    void moveObj                  (const QVariant &Field, const QVariant &object, QString setDirr, float maxWidth,       float maxHeight);
    bool mayShootAI               (const QVariant &Field, const QVariant &object,                  float maxWidth,       float maxHeight);
    void setRandomDirectionAI     (const QVariant &Field, const QVariant &object,                  float maxWidth,       float maxHeight);
    void setRandomXY              (const QVariant &Field, const QVariant &object,                  float    Width = 0.0, float    Height = 0.0);
    void makeShoot                (const QVariant &whoShotObj, const QVariant &bulletObj);
    int getRandomInt(int min, int max);

private:

};
#endif // logics_H

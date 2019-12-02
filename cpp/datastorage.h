#ifndef DATASTORAGE_H
#define DATASTORAGE_H
#include <QQuickItem>
#include <QObject>
#include <QSet>
class DataStorage : public QObject{
    Q_OBJECT
    Q_PROPERTY(QString  message
               READ  getMessage
               WRITE setMessage
               NOTIFY   messageChanged)
public:
    explicit DataStorage(QObject *parent = 0);
    QString getMessage(){return msg;}
    void    setMessage(QString str);
    Q_INVOKABLE int qInvokeExample(QString str);

signals:
    //void increaseOne(QString ms);
    void messageChanged();

public slots:
    void callMeFromQML();    

    QString getRandomFrom         (std::vector<QString> variants);
    QSet<QQuickItem*> getColInLine(QQuickItem *field, QString lineType, float lineEnd, float startX, float startY, int step);
    void takeDamage               (QQuickItem *field, QQuickItem *hitObj, int bulletMinDamage, int bulletMaxDamage, QQuickItem *whoShotObj);
    void checkForBonus            (QQuickItem *field, QQuickItem *obj, QSet<QQuickItem*> colliders);
    bool isCanMoveAI              (const QVariant &globalParent, const QVariant &object, QString setDirr, float maxWidth,       float maxHeight);
    void moveObj                  (const QVariant &globalParent, const QVariant &object, QString setDirr, float maxWidth,       float maxHeight);
    bool mayShootAI               (const QVariant &globalParent, const QVariant &object,                  float maxWidth,       float maxHeight);
    void setRandomdirectionAI     (const QVariant &globalParent, const QVariant &object,                  float maxWidth,       float maxHeight);
    void setRandomXY              (const QVariant &globalParent, const QVariant &object,                  float    Width = 0.0, float   Height = 0.0);
    void makeShoot                (const QVariant &whoShotObj,   const QVariant &bulletObj);
    int getRandomInt(int min, int max);

private:
    int count;
    QString msg;
};
#endif // DATASTORAGE_H

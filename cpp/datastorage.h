#ifndef DATASTORAGE_H
#define DATASTORAGE_H

#include <QObject>

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

private:
    int count;
    QString msg;
};
#endif // DATASTORAGE_H

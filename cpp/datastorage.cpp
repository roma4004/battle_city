#include "datastorage.h"
#include <QDebug>

DataStorage::DataStorage(QObject *parent)
                        :QObject (parent),
                         count(0),
                         msg("0 Hits"){
    msg.arg(count);
}
void DataStorage::setMessage(QString str){
    msg = str;
    emit messageChanged();
}
int DataStorage::qInvokeExample(QString str){
    qDebug(str.toLatin1() );
    return count;
}
void DataStorage::callMeFromQML(){
    qDebug("Inside CallMeFromQML");
    count++;
    setMessage(QString("%1 hits").arg(count) );
    //emit increaseOne(msg.arg(count) );
}

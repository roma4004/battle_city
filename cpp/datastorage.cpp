#include <QQuickItem>
#include <QQuickView>
#include <QQmlComponent>
#include <QQmlEngine>
#include "datastorage.h"
#include <QDebug>
#include <vector>
#include <QSet>
DataStorage::DataStorage(QObject *parent)
                        :QObject (parent)//,
                       //  count(0),
                       //  msg("0 Hits")
{
  //  msg.arg(count);
}
void DataStorage::setMessage(QString str){
    //msg = str;
    //emit messageChanged();
}
int DataStorage::qInvokeExample(QString str){
    //qDebug(str.toLatin1() );
    //return count;
}
void DataStorage::callMeFromQML(){
    //qDebug("Inside CallMeFromQML");
    //count++;
    //setMessage(QString("%1 hits").arg(count) );
    //emit increaseOne(msg.arg(count) );
}

///
/// \brief DataStorage::getRandomFrom  - get random selected variant
/// \param variants                    - vector of string varianst for random choise
/// \return                            - random selected variant
///
QString DataStorage::getRandomFrom(std::vector<QString> variants){
    return variants[getRandomInt(0, variants.size() - 1 )];
}
///
/// \brief DataStorage::getColInLine - detected coliders on said line
/// \param field                     - globalParent in QML id: "battlefield"
/// \param lineType                  - line type "H" - Horizontal, "V" - Vertical
/// \param lineEnd                   -   end point     of line (usually width or height of object)
/// \param startX                    - start point for x coord (usually x               of object)
/// \param startY                    - start point for y coord (usually y               of object)
/// \param step                      - number of points in line for detect colliders (a greater number gives high accuracy checks)
/// \return                          - collider objects without duplicates
///
QSet<QQuickItem*> DataStorage::getColInLine(QQuickItem *field, QString lineType, float lineEnd, float startX, float startY, int step){
    QSet<QQuickItem*> colidersInLine; //std::vector<QString> colidersInLine();
    for(int steps = 0; steps <= lineEnd; steps += lineEnd / step){
        QQuickItem *collider = (lineType == "H") ? field->childAt(startX + steps, startY         )
                                                 : field->childAt(startX        , startY + steps );
        if(collider && !collider->property("isPassObsticle").toBool() ) colidersInLine.insert(collider);            
    }
    return colidersInLine;
}
///
/// \brief DataStorage::takeDamage - deals random damage to the collider object
/// \param globalParent            - globalParent in QML id: "battlefield"
/// \param hitObj                  - object that will suffer damage
/// \param bulletMinDamage         - minimal deals damage
/// \param bulletMaxDamage         - maximum deals damage
/// \param whoShotObj              - object that will cause damage
///
void DataStorage::takeDamage(QQuickItem *field, QQuickItem *hitObj, int bulletMinDamage, int bulletMaxDamage, QQuickItem *whoShotObj){
    qDebug() <<"takeDamage: whoShotObj.tag: " << whoShotObj->property("tag"           ).toString();
    qDebug() <<               " hitObj.tag: " <<     hitObj->property("tag"           ).toString();
    qDebug() <<            " hitObj.health: " <<     hitObj->property("health"        ).toInt();
    qDebug() <<    " hitObj.isDestructible: " <<     hitObj->property("isDestructible").toBool();
    qDebug() <<           " hitObj.imgName: " <<     hitObj->property("imgName"       ).toString();
    qDebug() <<          " hitObj.fraction: " <<     hitObj->property("fraction"      ).toString();

    if(hitObj->property("isHelmetBonusAct").toBool()
    ||!hitObj->property("isDestructible").toBool() ) return;
    if(hitObj->property("imgName").toString() == "base"){
        hitObj->setProperty("imgName", "baseFlag");
        hitObj->setProperty("isDestructible", false);
        hitObj->setProperty("fraction", "none");
        field->setProperty("isDestroyedHQ", true);
        return;
    }
    if(hitObj->property("imgName").toString() == "baseFlag") return;
    if(hitObj->property("health").toInt() > 0) {
        hitObj->setProperty("health", -getRandomInt(bulletMinDamage, bulletMaxDamage) );
        if(hitObj->property("tag").toString() == "bullet" ){
            whoShotObj->setProperty("counterBulletHits", whoShotObj->property("counterBulletHits").toInt()+1);
        }else
            if( hitObj->property("tag").toString() == "obsticleWall"){
            whoShotObj->setProperty("counterBrickHits", whoShotObj->property("counterBrickHits").toInt()+1);
        }else
            whoShotObj->setProperty("counterTagetHits", whoShotObj->property("counterTagetHits").toInt()+1);
    }
}
///
/// \brief DataStorage::checkForBonus - check for bonuses before moving to direction forward and apply them
/// \param field                      - globalParent in QML id: "battlefield"
/// \param obj                        - object which is moving (this)
/// \param colliderArray              - detected coliders
///
void DataStorage::checkForBonus(QQuickItem *field, QQuickItem *obj, QSet<QQuickItem*> colliders){
    QSetIterator<QQuickItem*> ITcheck(colliders);
    while (ITcheck.hasNext()){
    QQuickItem* check = ITcheck.next();
        if(check->property("imgName").toString() == "Helmet"){
            obj->setProperty("isHelmetBonusAct", true);
            takeDamage(field, check, 100, 100, obj);
        }else if(check->property("imgName").toString() == "Timer"){
            if(obj->property("fraction").toString() == "Players") field->setProperty("isTimerBonusActEn", true);
            else                                                  field->setProperty("isTimerBonusActPl", true);
            takeDamage(field, check, 100, 100, obj);
        }else if(check->property("imgName").toString() == "Tank"){
            obj->setProperty("isTankBonusAct", true);
            takeDamage(field, check, 100, 100, obj);
        }
        if (obj->property("isTankBonusAct").toBool() ){
            float x      = obj->property("x"     ).toFloat();
            float y      = obj->property("y"     ).toFloat();
            float height = obj->property("height").toFloat();
            float width  = obj->property("width" ).toFloat();
            float speed  = obj->property("speed" ).toFloat();
            QSet<QQuickItem*> coliders;
            QSet<QQuickItem*> colidersFinded;

            coliders = getColInLine(field, "H", width , x                    , y              - speed, 6);
            QSetIterator<QQuickItem*> ITtopHoriz(coliders);
            while (ITtopHoriz.hasNext() ) colidersFinded.insert(ITtopHoriz.next() );

            coliders = getColInLine(field, "H", width , x                    , y + height / 2        , 6);
            QSetIterator<QQuickItem*> ITcenterHoriz(coliders);
            while (ITcenterHoriz.hasNext() ) colidersFinded.insert(ITcenterHoriz.next() );

            coliders = getColInLine(field, "H", width , x                    , y + height     + speed, 6);
            QSetIterator<QQuickItem*> ITbottomHoriz(coliders);
            while (ITbottomHoriz.hasNext() ) colidersFinded.insert(ITbottomHoriz.next() );

            coliders = getColInLine(field, "V", height, x             - speed, y                     , 6);
            QSetIterator<QQuickItem*> ITleftVertic(coliders);
            while (ITleftVertic.hasNext() ) colidersFinded.insert(ITleftVertic.next() );

            coliders = getColInLine(field, "V", height, x + width / 2        , y                     , 6);
            QSetIterator<QQuickItem*> ITcenterVertic(coliders);
            while (ITcenterVertic.hasNext() ) colidersFinded.insert(ITcenterVertic.next() );

            coliders = getColInLine(field, "V", height, x + width     + speed, y                     , 6);
            QSetIterator<QQuickItem*> ITrightVertic(coliders);
            while (ITrightVertic.hasNext() ) colidersFinded.insert(ITrightVertic.next() );

            QSetIterator<QQuickItem*> ITcol(colidersFinded);
            while (ITcol.hasNext()){
                QQuickItem* col = ITcol.next();
                if(obj->property("tag").toString()
                != col->property("tag").toString() ) {
                    takeDamage(field, col, 100, 100, obj);
                }
            }
        }
    }
}
///
/// \brief DataStorage::isCanMoveAI - check whether the path is free before moveObj; AI - artificial intelligence
/// \param field                    - globalParent in QML id: "battlefield"
/// \param obj                      - object which is cheking (this)
/// \param setDirr                  - given direction
/// \param maxWidth                 - maximum window width - sidebar width
/// \param maxHeight                - maximum window height
/// \return                         - true - way clear; false - movement blocked
///
bool DataStorage::isCanMoveAI(const QVariant &globalParent, const QVariant &object, QString setDirr, float maxWidth, float maxHeight){
    //get all prperty from received obj OR from directly received values
    QQuickItem *field = qobject_cast<QQuickItem*>(globalParent.value<QObject*>() );
    QQuickItem *obj   = qobject_cast<QQuickItem*>(      object.value<QObject*>() );
    float x      = obj->property("x"     ).toFloat();
    float y      = obj->property("y"     ).toFloat();
    float height = obj->property("height").toFloat();
    float width  = obj->property("width" ).toFloat();
    float speed  = obj->property("speed" ).toFloat();
    QString dir = (setDirr == "none") ? obj->property("direction").toString() : setDirr;

    if(dir == "U" && y          - speed < 0        ) return false;
    if(dir == "L" && x          - speed < 0        ) return false;
    if(dir == "D" && y + height + speed > maxHeight) return false;
    if(dir == "R" && x + width  + speed > maxWidth ) return false;

    if(obj->property("isTankBonusAct").toBool() ) return true;
                   //getColInLine(lineType, lineEnd, x, y, step){
    if(dir == "U" && getColInLine(field, "H", width , x                , y          - speed, 6).size() > 0) return false;
    if(dir == "L" && getColInLine(field, "V", height, x         - speed, y                 , 6).size() > 0) return false;
    if(dir == "D" && getColInLine(field, "H", width , x                , y + height + speed, 6).size() > 0) return false;
    if(dir == "R" && getColInLine(field, "V", height, x + width + speed, y                 , 6).size() > 0) return false;

    return true;
}
///
/// \brief DataStorage::moveObj - moving object to direction on one step=speed
/// \param globalParent         - globalParent in QML id: "battlefield"
/// \param object               - object which is moving (this)
/// \param setDirr              - given direction
/// \param maxWidth             - maximum window width - sidebar width
/// \param maxHeight            - maximum window height
///
void DataStorage::moveObj(const QVariant &globalParent, const QVariant &object, QString setDirr, float maxWidth, float maxHeight){
    ////// maxHeight = mainWindow.height
    ////// maxWidth = mainWindow.width - sideBar.width
    QQuickItem *field = qobject_cast<QQuickItem*>(globalParent.value<QObject*>() );
    QQuickItem *obj   = qobject_cast<QQuickItem*>(      object.value<QObject*>() );
    float x      = obj->property("x"     ).toFloat();
    float y      = obj->property("y"     ).toFloat();
    float width  = obj->property("width" ).toFloat();
    float height = obj->property("height").toFloat();
    float speed  = obj->property("speed" ).toFloat();
    QSet<QQuickItem*> checkArr; // qDebug() << "moveObj cpp: setdirection:" << setDirr;
    if (setDirr == "U" && y - speed > 0){
        checkArr = getColInLine(field, "H", width , x                    , y              - speed, 6);
        checkForBonus(field, obj, checkArr);
        if(checkArr.size() == 0)
            obj->setProperty("y", y - speed);
    }else
        if (setDirr == "L" && x - speed > 0){
        checkArr = getColInLine(field, "V", height, x             - speed, y                     , 6);
        checkForBonus(field, obj, checkArr);
        if(checkArr.size() == 0)
            obj->setProperty("x", x - speed);
    }else
        if (setDirr == "D" && y + height + speed < maxHeight){
        checkArr = getColInLine(field, "H", width , x                    , y + height     + speed, 6);
        checkForBonus(field, obj, checkArr);
        if(checkArr.size() == 0)
            obj->setProperty("y", y + speed);
    }else
        if (setDirr == "R" && x + width + speed < maxWidth ){
        checkArr = getColInLine(field, "V", height, x + width     + speed, y                     , 6);
        checkForBonus(field, obj, checkArr);
        if(checkArr.size() == 0)
            obj->setProperty("x", x + speed);
    }
    obj->setProperty("direction", setDirr);
}
///
/// \brief DataStorage::mayShootAI - check players on each side and shoot them if find
///                                  OR random deside shoot or not on the obsticle, only for actual direction side
///                                  OR set direction to bonuses if find them on each side; AI - artificial intelligence
/// \param globalParent            - globalParent in QML id: "battlefield"
/// \param object                  - object which is deside (this)
/// \param maxWidth                - maximum window width - sidebar width
/// \param maxHeight               - maximum window height
/// \return                        - true - shoot; false - do not shoot
///
bool DataStorage::mayShootAI(const QVariant &globalParent, const QVariant &object, float maxWidth, float maxHeight){
    QQuickItem *field = qobject_cast<QQuickItem*>(globalParent.value<QObject*>() );
    QQuickItem *obj   = qobject_cast<QQuickItem*>(      object.value<QObject*>() );
    QQuickItem *target;
    int i;
    float x      = obj->property("x"     ).toFloat();
    float y      = obj->property("y"     ).toFloat();
    float width  = obj->property("width" ).toFloat();
    float height = obj->property("height").toFloat();

    for(i = y - height - 1; i > 0; i -= height){
        target = field->childAt(x + width / 2, i);
        if(target){
            if(target->property("fraction").toString() == "bonuses")
                obj->setProperty("direction", "U");
            if(target->property("fraction").toString() == "Players"){
                obj->setProperty("direction", "U");
                return true;
            }
            if(target->property("fraction"  ).toString() == "neitral"
            &&    obj->property("direction").toString() == "U")
                return getRandomInt(0, 1);
            break;
        }
    }
    for(i = x + width + 1; i < maxWidth; i += width){
        target = field->childAt(i, y + height / 2 );
        if(target){
            if(target->property("fraction").toString() == "bonuses")
                obj->setProperty("direction", "R");
            if(target->property("fraction").toString() == "Players"){
                obj->setProperty("direction", "R");
                return true;
            }
            if(target->property("fraction"  ).toString() == "neitral"
            &&    obj->property("direction").toString() == "R")
                return getRandomInt(0, 1);
            break;
        }
    }
    for(i = y + height + 1; i < maxHeight; i += height){
        target = field->childAt(x + width / 2, i );
        if(target){
            if(target->property("fraction").toString() == "bonuses")
                obj->setProperty("direction", "D");
            if(target->property("fraction").toString() == "Players"){
                obj->setProperty("direction", "D");
                return true;
            }
            if(target->property("fraction"  ).toString() == "neitral"
            &&    obj->property("direction").toString() == "D")
                return getRandomInt(0, 1);
            break;
        }
    }
    for(i = x - width - 1; i > 0; i -= width){
        target = field->childAt(i, y + height / 2 );
        if(target){
            if(target->property("fraction").toString() == "bonuses")
                obj->setProperty("direction", "L");
            if(target->property("fraction").toString() == "Players"){
                obj->setProperty("direction", "L");
                return true;
            }
            if(target->property("fraction"  ).toString() == "neitral"
            &&    obj->property("direction").toString() == "L")
                return getRandomInt(0, 1);
            break;
        }
    }
    return false;
}
///
/// \brief DataStorage::setRandomdirectionAI - get random dirrection and apply it to object
/// \param globalParent                      - globalParent in QML id: "battlefield"
/// \param object                            - object that gives direction
/// \param maxWidth                          - maximum window width - sidebar width
/// \param maxHeight                         - maximum window height
///
void DataStorage::setRandomdirectionAI(const QVariant &globalParent, const QVariant &object, float maxWidth, float maxHeight){
    std::vector<QString> randVariants(0);
    QQuickItem *obj   = qobject_cast<QQuickItem*>(      object.value<QObject*>() );
    if(isCanMoveAI(globalParent, object, "U", maxWidth, maxHeight) ) randVariants.push_back("U");
    if(isCanMoveAI(globalParent, object, "R", maxWidth, maxHeight) ) randVariants.push_back("R");
    if(isCanMoveAI(globalParent, object, "D", maxWidth, maxHeight) ) randVariants.push_back("D");
    if(isCanMoveAI(globalParent, object, "L", maxWidth, maxHeight) ) randVariants.push_back("L");
    if(randVariants.size() > 0) obj->setProperty("direction", getRandomFrom(randVariants) );
}
///
/// \brief DataStorage::setRandomXY - setting random clear position
/// \param globalParent             - globalParent in QML id: "battlefield"
/// \param object                   - object for setting position
/// \param Width                    - width  offset
/// \param Height                   - height offset
///
void DataStorage::setRandomXY(const QVariant &globalParent, const QVariant &object, float Width, float Height){
    QQuickItem *field = qobject_cast<QQuickItem*>(globalParent.value<QObject*>() );
    QQuickItem *obj   = qobject_cast<QQuickItem*>(      object.value<QObject*>() );
    qDebug() << "setRandomXY: cast ";
    float width  = (Width  == 0.0) ? obj->property("height").toFloat() : Height;
    float height = (Height == 0.0) ? obj->property("width" ).toFloat() : Width;
    bool isCanPutObj = false;
    int x, y;
    while(isCanPutObj == false){
        int spawnPosMinX = obj->property("spawnPosMinX").toInt();
        int spawnPosMinY = obj->property("spawnPosMinY").toInt();
        int spawnPosMaxX = obj->property("spawnPosMaxX").toInt();
        int spawnPosMaxY = obj->property("spawnPosMaxY").toInt();
        int x = getRandomInt(spawnPosMinX, spawnPosMaxX);
        int y = getRandomInt(spawnPosMinY, spawnPosMaxY);
        qDebug() << "setRandomXY: after rand ";
        if( (getColInLine(field, "H", width , x             , y              , 6).size() > 0) //     "topHoriz"
         || (getColInLine(field, "H", width , x             , y + height / 2 , 6).size() > 0) //  "centerHoriz"
         || (getColInLine(field, "H", width , x             , y + height     , 6).size() > 0) //  "bottomHoriz"
       //|| (getColInLine(field, "V", height, x             , y              , 6).size() > 0) //   "leftVertic"
       //|| (getColInLine(field, "V", height, x + width / 2 , y              , 6).size() > 0) // "centerVertic"
       //|| (getColInLine(field, "V", height, x + width     , y              , 6).size() > 0) //  "rightVertic"
            ){
            isCanPutObj = false;
        }else{
         isCanPutObj = true;
        }
    }
    qDebug() << "func setRandomXY: obj " << obj << " new objX " << x << " new objY " << y;
    obj->setProperty("x", x);
    obj->setProperty("y", y);
}
///
/// \brief DataStorage::makeShoot - setting (make) bullet
/// \param whoShotObj             - object who shoot this bullet
/// \param bulletObj              - Previously created bullet object
///
void DataStorage::makeShoot(const QVariant &whoShotObj, const QVariant &bulletObj){
    //// Using QQmlComponent
    //QQmlEngine engine;
    //QQmlComponent component(&engine, QUrl("qrc:/qml/Bullet.qml") );qDebug() <<" component(&engine, QUrl ";
    //qDebug() <<"component status" << component.status();
    //QObject *newObject = component.create();
    //QObject *bullet = qobject_cast<QQuickItem*>(newObject);
    //QQuickItem *bullet = qobject_cast<QQuickItem*>(newObject);
    //bullet->setParent(field);

    // Using QQuickView
    //QQuickView view;
    //view.setSource(QUrl::fromLocalFile("qrc:/qml/Bullet.qml") );
    //view.show();
    //QObject *newObject = view.rootObject();
    //QQuickItem *bullet = qobject_cast<QQuickItem*>(newObject);

    QQuickItem *whoShot = qobject_cast<QQuickItem*>(  whoShotObj.value<QObject*>() );
    QQuickItem *bullet  = qobject_cast<QQuickItem*>(   bulletObj.value<QObject*>() );
    bullet->setProperty("whoShotObj"     , whoShotObj                                      );
    bullet->setProperty("fraction"       , whoShot->property("fraction"       ).toString() );
    bullet->setProperty("speed"          , whoShot->property("bulletSpeed"    ).toInt()    );
    bullet->setProperty("bulletMinDamage", whoShot->property("bulletMinDamage").toInt()    );
    bullet->setProperty("bulletMaxDamage", whoShot->property("bulletMaxDamage").toInt()    );

    if(whoShot->property("isTankBonusAct").toBool() ) bullet->setProperty("width" , bullet->property("width" ).toFloat() * 1.5);
    if(whoShot->property("isTankBonusAct").toBool() ) bullet->setProperty("height", bullet->property("height").toFloat() * 1.5);

    float bulletWidth        =  bullet->property("width"    ).toFloat();
    float bulletHeight       =  bullet->property("height"   ).toFloat();
    float whoShotX           = whoShot->property("x"        ).toFloat();
    float whoShotY           = whoShot->property("y"        ).toFloat();
    float whoShotWidth       = whoShot->property("width"    ).toFloat();
    float whoShotHeight      = whoShot->property("height"   ).toFloat();
    float whoShotSpeed       = whoShot->property("speed"    ).toFloat();
    QString whoShotDirection = whoShot->property("direction").toString();

    if(whoShotDirection == "U"){
      //bullet->setProperty("rotation", 0);
        bullet->setProperty("x", whoShotX + whoShotWidth  / 2 - bulletWidth  / 2                                  );
        bullet->setProperty("y", whoShotY                     - bulletHeight / 2 - bulletHeight - whoShotSpeed - 1);
    }else if(whoShotDirection == "R"){
        bullet->setProperty("rotation", 90);
        bullet->setProperty("x", whoShotX + whoShotWidth      + bulletHeight / 2                + whoShotSpeed + 1);
        bullet->setProperty("y", whoShotY + whoShotHeight / 2 - bulletWidth  / 2                                  );
    }else if(whoShotDirection == "D"){
        bullet->setProperty("rotation", 180);
        bullet->setProperty("x", whoShotX + whoShotWidth  / 2 - bulletWidth  / 2                                  );
        bullet->setProperty("y", whoShotY + whoShotHeight     + bulletHeight / 2                + whoShotSpeed + 1);
    }else if(whoShotDirection == "L"){
        bullet->setProperty("rotation", 270);
        bullet->setProperty("x", whoShotX                     - bulletHeight / 2 - bulletHeight - whoShotSpeed - 1);
        bullet->setProperty("y", whoShotY + whoShotHeight / 2 - bulletWidth  / 2                                  );
    }
    whoShot->setProperty("counterShoots", whoShot->property("counterShoots").toInt() + 1);
}
int DataStorage::getRandomInt(int min, int max){
    return rand() % max + min;
}

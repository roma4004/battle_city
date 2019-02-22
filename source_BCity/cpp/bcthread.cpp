#include "bcthread.h"
#include <QQuickItem>
#include <QQuickView>
#include <QQmlComponent>
#include <QQmlEngine>
#include <QQmlProperty>
#include <QStringListModel>
#include <QDebug>
#include <vector>
#include <QSet>

BCThread::BCThread(){

}
void BCThread::run(){
    //exec();
}

///
/// \brief BCThread::getRandomFrom  - get random from received selected variant
/// \param variants               - vector of string varianst for random choise
/// \return                       - random selected variant
///
QString BCThread::getRandomFrom(QVector<QString> &variants){
    return variants[getRandomInt(0, variants.size() - 1 )];
}

///
/// \brief BCThread::getRandomInt  - get random in range from min to max inclusive
/// \param min                   - minimum random value inclusive
/// \param min                   - maximum random value inclusive
/// \return                      - random int
///
int BCThread::getRandomInt(int min, int max){
    return rand() % (max - min + 1) + min;
}
///
/// \brief BCThread::findColInLine - detected coliders on said line
/// \param field                 - globalParent in QML id: "battlefield"
/// \param lineType              - line type "H" - Horizontal, "V" - Vertical
/// \param lineEnd               - end   point of line
///                                (usually width or height of object)
/// \param startX                - start point for x coord (usually object.x)
/// \param startY                - start point for y coord (usually object.y)
/// \param step                  - number of points in line for detect colliders
///                                (a greater number gives high accuracy checks)
/// \return                      - collider objects without duplicates
///
QSet<QQuickItem*> BCThread::findColInLine(QQuickItem *field, QString lineType,
                                          float lineEnd, float startX,
                                          float startY, int step){
    //qDebug() << "*field, lineType, lineEnd, startX, startY, step";
    //qDebug() << field << lineType << lineEnd << startX << startY << step;
    QSet<QQuickItem*> colidersInLine;
    for(int steps = 0; steps <= lineEnd; steps += lineEnd / step){
        QQuickItem *collider = (lineType == "H")
                             ? field->childAt(startX + steps, startY        )
                             : field->childAt(startX,         startY + steps);
        if(collider && !collider->property("isPassObsticle").toBool() )
            colidersInLine.insert(collider);
    }
    return colidersInLine;
}
void BCThread::getBulletColliders(const QVariant &Field, const QVariant &object, const QVariant &whoShotObj){
    QQuickItem *field   = qobject_cast<QQuickItem*>(     Field.value<QObject*>() );
    QQuickItem *obj     = qobject_cast<QQuickItem*>(    object.value<QObject*>() );
    QQuickItem *whoShot = qobject_cast<QQuickItem*>(whoShotObj.value<QObject*>() );
    float minDmg = obj->property("minDamage").toFloat();
    float maxDmg = obj->property("maxDamage").toFloat();
    float x      = obj->property("x"        ).toFloat();
    float y      = obj->property("y"        ).toFloat();
    float s      = obj->property("speed"    ).toFloat();
    float w = 0;
    float h = 0;

    switch (obj->property("rotation").toInt() ) {
    case   0:
    case 180: w = obj->property("width" ).toFloat();
              h = obj->property("height").toFloat(); break;
    case  90:
    case 270: w = obj->property("height").toFloat();
              h = obj->property("width" ).toFloat(); break;
    }

    QSet<QQuickItem*> cols;
    cols.unite(findColInLine(field, "H", w, x        , y     - s, 6) ); //    "topHorizLine"
    cols.unite(findColInLine(field, "H", w, x        , y + h / 2, 6) ); // "centerHorizLine"
    cols.unite(findColInLine(field, "H", w, x        , y + h + s, 6) ); // "bottomHorizLine"
    cols.unite(findColInLine(field, "V", h, x     - s, y,         6) ); //  "leftVerticLine"
    cols.unite(findColInLine(field, "V", h, x + w / 2, y,         6) ); // centerVerticLine"
    cols.unite(findColInLine(field, "V", h, x + w + s, y,         6) ); // "rightVerticLine"

    QSetIterator<QQuickItem*> ITcol(cols);
    while (ITcol.hasNext()){
        QQuickItem* col = ITcol.next();
        if(col != whoShot
        && col != obj    ){
           takeDamage(field, col, minDmg, maxDmg, whoShot);
           obj->setProperty("isNeedExplode", true);
        }
    }
}
///
/// \brief BCThread::takeDamage - deals random damage to the collider object
/// \param field              - globalParent in QML id: "battlefield"
/// \param hitObj             - object that will suffer damage
/// \param minDamage    - minimal deals damage
/// \param maxDamage    - maximum deals damage
/// \param whoShotObj         - object that will cause damage
///
void BCThread::takeDamage(QQuickItem *field, QQuickItem *hitObj,
                          int minDamage, int maxDamage, QQuickItem *whoShotObj){
 /* qDebug() << "takeDamage:";
    qDebug() << "  whoShotObj.tag: "
             <<    whoShotObj->property("tag"       ).toString();
    qDebug() << "  hitObj.tag: "
             <<    hitObj->property("tag"           ).toString();
    qDebug() << "  hitObj.health: "
             <<    hitObj->property("health"        ).toInt();
    qDebug() << "  hitObj.isDestructible: "
             <<    hitObj->property("isDestructible").toBool();
    qDebug() << "  hitObj.imgName: "
             <<    hitObj->property("imgName"       ).toString();
    qDebug() << "  hitObj.fraction: "
             <<    hitObj->property("fraction"      ).toString();
 */
    if(hitObj->property("isHelmetBonusAct").toBool()
    ||!hitObj->property("isDestructible").toBool() ) return;
    if(hitObj->property("imgName").toString() == "base"){
        hitObj->setProperty("imgName", "baseFlag");
        hitObj->setProperty("isDestructible", false);
        hitObj->setProperty("fraction", "unDestructible");
        field->setProperty("isDestroyedHQ", true);
        return;
    }
    if(hitObj->property("imgName").toString() == "baseFlag") return;
    if(hitObj->property("health").toInt() > 0) {
        int dmg = getRandomInt(minDamage, maxDamage);

        hitObj->setProperty("health", hitObj->property("health").toInt() - dmg);
        if(hitObj->property("tag").toString() == "bullet" ){
            whoShotObj->setProperty("bulletHits",
                                    whoShotObj->property("bulletHits").toInt()
                                    + 1);
        }else if( hitObj->property("tag").toString() == "obsticleWall"){
            whoShotObj->setProperty("brickHits",
                                    whoShotObj->property("brickHits").toInt()
                                    + 1);
        }else {
            whoShotObj->setProperty("tagetHits",
                                    whoShotObj->property("tagetHits").toInt()
                                        + 1);
          //qDebug() << whoShotObj->property("tag").toString() + ".tagetHits: "
          //         << whoShotObj->property("tagetHits").toInt();

            if(hitObj->property("health").toInt() < 1) {
                whoShotObj->setProperty("tankKils",
                                        whoShotObj->property("tankKils").toInt()
                                        + 1 );
                //qDebug() << whoShotObj->property("tag").toString() + ".tankKils: "
                //<< whoShotObj->property("tankKils").toInt();
            }
        }
    }
}
///
/// \brief BCThread::checkForBonus - check for bonuses before moving
///                                   to direction forward and apply them
/// \param Field                      - globalParent in QML id: "battlefield"
/// \param obj                        - object which is moving (this)
/// \param colliderArray              - detected coliders
///
void BCThread::checkForBonus(QQuickItem *field, QQuickItem *obj,
                             QSet<QQuickItem*> &colliders){
    QSetIterator<QQuickItem*> ITcheck(colliders);
    while (ITcheck.hasNext()){
        QQuickItem* check = ITcheck.next();
       // qDebug() << "   tag" << check->property("tag").toString();
        if(check->property("tag").toString() == "bonus"){

            if(check->property("imgName").toString() == "Helmet"){
                obj->setProperty("isHelmetBonusAct", true);
                takeDamage(field, check, 100, 100, obj);
            }else if(check->property("imgName").toString() == "Timer"){
                if(obj->property("fraction").toString() == "Players")
                    field->setProperty("isTimerBonusActEn", true);
                else
                    field->setProperty("isTimerBonusActPl", true);
                takeDamage(field, check, 100, 100, obj);
            }else if(check->property("imgName").toString() == "Tank"){
                obj->setProperty("isTankBonusAct", true);
                takeDamage(field, check, 100, 100, obj);
            }
            QQuickItem* checkDel = ITcheck.peekPrevious() ;//need to delete current elem
            colliders.remove(checkDel);
        }
        if (obj->property("isTankBonusAct").toBool() ){
            float x = obj->property("x"     ).toFloat();
            float y = obj->property("y"     ).toFloat();
            float h = obj->property("height").toFloat();
            float w = obj->property("width" ).toFloat();
            float s = obj->property("speed" ).toFloat();
            //qDebug() << "isTankBonusAct active";
            QSet<QQuickItem*> cols;

            cols.unite(findColInLine(field, "H", w, x        , y     - s, 6) );
            cols.unite(findColInLine(field, "H", w, x        , y + h / 2, 6) );
            cols.unite(findColInLine(field, "H", w, x        , y + h + s, 6) );
            cols.unite(findColInLine(field, "V", h, x     - s, y,         6) );
            cols.unite(findColInLine(field, "V", h, x + w / 2, y,         6) );
            cols.unite(findColInLine(field, "V", h, x + w + s, y,         6) );

            QSetIterator<QQuickItem*> ITcol(cols);
            while (ITcol.hasNext()){
                QQuickItem* col = ITcol.next();
                if(obj->property("tag").toString()
                != col->property("tag").toString() ) {
                    //qDebug() << "isTankBonusAct active take damage";
                    takeDamage(field, col, 100, 100, obj);
                }
            }
        }
    }
}
///
/// \brief BCThread::isCanMove      - check whether the path is free,
///                                 before moveObj; AI - artificial intelligence
/// \param field                    - globalParent in QML id: "battlefield"
/// \param obj                      - object which is cheking (this)
/// \param setDirr                  - given direction
/// \param maxWidth                 - maximum window width - sidebar width
/// \param maxHeight                - maximum window height
/// \return                         - true - way clear; false - movement blocked
///
bool BCThread::isCanMove(const QVariant &Field, const QVariant &object,
                         QString setDirr, float maxWidth, float maxHeight){
    //get all prperty from received obj OR from directly received values
    QQuickItem *field = qobject_cast<QQuickItem*>( Field.value<QObject*>() );
    QQuickItem *obj   = qobject_cast<QQuickItem*>(object.value<QObject*>() );
    float x = obj->property("x"     ).toFloat();
    float y = obj->property("y"     ).toFloat();
    float h = obj->property("height").toFloat();
    float w = obj->property("width" ).toFloat();
    float s = obj->property("speed" ).toFloat();
    QString dir = (setDirr == "none") ? obj->property("direction").toString()
                                      : setDirr;

    if     (dir == "U" && y     - s < 0        ) return false;
    else if(dir == "L" && x     - s < 0        ) return false;
    else if(dir == "D" && y + h + s > maxHeight) return false;
    else if(dir == "R" && x + w + s > maxWidth ) return false;

    QSet<QQuickItem*> foundCol;
    if     (dir == "U")
        foundCol = findColInLine(field, "H", w, x        , y     - s, 6);

    else if(dir == "L")
        foundCol = findColInLine(field, "V", h, x     - s, y        , 6);

    else if(dir == "D")
        foundCol = findColInLine(field, "H", w, x        , y + h + s, 6);

    else if(dir == "R")
        foundCol = findColInLine(field, "V", h, x + w + s, y        , 6);

    checkForBonus(field, obj, foundCol);
    QSetIterator<QQuickItem*> ITcheck(foundCol);
    while(ITcheck.hasNext() ){
        QQuickItem* check = ITcheck.next();
        //qDebug() << " isCanMove: " << check;
        if(check->property("fraction").toString() == "unDestructible")
            return false;
    }
    if(obj->property("isTankBonusAct").toBool() ) return true;
    if(foundCol.size() > 0) return false;
    return true;
}
///
/// \brief BCThread::moveObj - moving object to direction on one step=speed
/// \param Field                - globalParent in QML id: "battlefield"
/// \param object               - object which is moving (this)
/// \param setDirr              - given direction
/// \param maxWidth             - maximum window width - sidebar width
/// \param maxHeight            - maximum window height
///
void BCThread::moveObj(const QVariant &Field, const QVariant &object,
                       QString setDirr, float maxWidth, float maxHeight){
    QQuickItem *obj = qobject_cast<QQuickItem*>(object.value<QObject*>() );
    //qDebug() << "dirBefore" << obj->property("direction" ).toString();
    obj->setProperty("direction", setDirr);
    //qDebug() << "dirAfter" << obj->property("direction" ).toString();
    //qDebug()<<"moveObj: isCanMove result" << isCanMove(Field, object, setDirr, maxWidth, maxHeight);
    if(!isCanMove(Field, object, setDirr, maxWidth, maxHeight) ) return;

    float x = obj->property("x"     ).toFloat();
    float y = obj->property("y"     ).toFloat();
    float s = obj->property("speed" ).toFloat();

         if(setDirr == "U") obj->setProperty("y", y - s);
    else if(setDirr == "L") obj->setProperty("x", x - s);
    else if(setDirr == "D") obj->setProperty("y", y + s);
    else if(setDirr == "R") obj->setProperty("x", x + s);
}
///
/// \brief BCThread::mayShootAI - check players on each side
///                                  and shoot them if find
///                                  OR random decides to shoot or not on an
///                                  obstacle, only for actual direction side
///                                  OR set direction to bonuses if find them
///                                  on each side; AI - artificial intelligence
/// \param globalParent            - globalParent in QML id: "battlefield"
/// \param object                  - object which is deside (this)
/// \param maxWidth                - maximum window width - sidebar width
/// \param maxHeight               - maximum window height
/// \return                        - true - shoot; false - do not shoot
///
bool BCThread::mayShootAI(const QVariant &Field, const QVariant &object,
                          float maxWidth, float maxHeight) // should_AI_shot
{
    QQuickItem *field = qobject_cast<QQuickItem*>( Field.value<QObject*>() );
    QQuickItem *obj   = qobject_cast<QQuickItem*>(object.value<QObject*>() );
    QQuickItem *target;
    int i;
    float x      = obj->property("x"     ).toFloat();
    float y      = obj->property("y"     ).toFloat();
    float width  = obj->property("width" ).toFloat();
    float height = obj->property("height").toFloat();

    for(i = y - height - 1; i > 0; i -= height){
        target = field->childAt(x + width / 2, i);
        if(target){
            if(checkObjectByDirection(target, obj, "U") ) return true;
            break;
        }
    }
    for(i = x + width + 1; i < maxWidth; i += width){
        target = field->childAt(i, y + height / 2);
        if(target){
            if(checkObjectByDirection(target, obj, "R") ) return true;
            break;
        }
    }
    for(i = y + height + 1; i < maxHeight; i += height){
        target = field->childAt(x + width / 2, i);
        if(target){
            if(checkObjectByDirection(target, obj, "D") ) return true;
            break;
        }
    }
    for(i = x - width - 1; i > 0; i -= width){
        target = field->childAt(i, y + height / 2);
        if(target){
            if(checkObjectByDirection(target, obj, "L") ) return true;
            break;
        }
    }
    return false;
}

///
/// \brief BCThread::checkObjectByDirection - identify object in the way and reacts
/// \param targetFraction                 - fraction of target that been found
/// \param selfDirection                  - direction of object which makes test
/// \param setDirection                   - direction which will be set if need
/// \return                               - true, need shoot; false, do not shoot
///
bool BCThread::checkObjectByDirection(QQuickItem *target, QQuickItem *obj,
                                    QString setDirection){
    QString targetFraction = target->property("fraction" ).toString();
    QString selfFraction   =    obj->property("fraction" ).toString();
    QString selfDirection  =    obj->property("direction").toString();

    if(targetFraction == "bonuses") obj->setProperty("direction", setDirection);
    if(targetFraction != selfFraction
    && targetFraction != "unDestructible"
    && targetFraction != "bonuses"
    && targetFraction != "neitral"){
        qDebug() << "Cpp.checkObjectByDirection";
        qDebug() << "targetFraction" << targetFraction;
        qDebug() << "selfDirection" << selfDirection;
        qDebug() << "selfFraction" << selfFraction;
        obj->setProperty("direction", setDirection);
        return true;
    }
    if((targetFraction == "neitral") && (selfDirection == setDirection))
        return getRandomInt(0, 1);
    return false;
}

///
/// \brief BCThread::setRandomDirectionAI - assign a random direction to an object
/// \param globalParent                 - globalParent in QML id: "battlefield"
/// \param object                       - object that gives direction
/// \param maxWidth                     - maximum window width - sidebar width
/// \param maxHeight                    - maximum window height
///
void BCThread::setRandomDirectionAI(const QVariant &Field, const QVariant &object,
                                  float maxWidth, float maxHeight){
    QVector<QString> randVariants;
    randVariants.reserve(4);
    QQuickItem *obj = qobject_cast<QQuickItem*>(object.value<QObject*>() );
    if(isCanMove(Field, object, "U", maxWidth, maxHeight) )
        randVariants.push_back("U");
    if(isCanMove(Field, object, "R", maxWidth, maxHeight) )
        randVariants.push_back("R");
    if(isCanMove(Field, object, "D", maxWidth, maxHeight) )
        randVariants.push_back("D");
    if(isCanMove(Field, object, "L", maxWidth, maxHeight) )
        randVariants.push_back("L");
    if(randVariants.size() > 0)
        obj->setProperty("direction", getRandomFrom(randVariants) );
}
///
/// \brief BCThread::setRandomXY - setting random clear position
/// \param globalParent             - globalParent in QML id: "battlefield"
/// \param object                   - object for setting position
/// \param Width                    - width  offset
/// \param Height                   - height offset
///
void BCThread::setRandomXY(const QVariant &Field, const QVariant &object,
                         float Width, float Height){
    QQuickItem *field = qobject_cast<QQuickItem*>( Field.value<QObject*>() );
    QQuickItem *obj   = qobject_cast<QQuickItem*>(object.value<QObject*>() );

    float w = (Width  == 0.0) ? obj->property("height").toFloat() : Height;
    float h = (Height == 0.0) ? obj->property("width" ).toFloat() : Width;
    bool isCanPutObj = false;
    int x, y;
    while(isCanPutObj == false){
        int MinPosX = obj->property("spawnPosMinX").toInt();
        int MinPosY = obj->property("spawnPosMinY").toInt();
        int MaxPosX = obj->property("spawnPosMaxX").toInt();
        int MaxPosY = obj->property("spawnPosMaxY").toInt();
        (MinPosX != MaxPosX) ? x = getRandomInt(MinPosX, MaxPosX)
                             : x = MinPosX;
        (MinPosY != MaxPosY) ? y = getRandomInt(MinPosY, MaxPosY)
                             : y = MinPosY;
        if( (findColInLine(field, "H", w, x         , y         , 6).size() > 0) //     "topHoriz"
         || (findColInLine(field, "H", w, x         , y + h / 2 , 6).size() > 0) //  "centerHoriz"
         || (findColInLine(field, "H", w, x         , y + h     , 6).size() > 0) //  "bottomHoriz"
       //|| (findColInLine(field, "V", h, x         , y         , 6).size() > 0) //   "leftVertic"
       //|| (findColInLine(field, "V", h, x + w / 2 , y         , 6).size() > 0) // "centerVertic"
       //|| (findColInLine(field, "V", h, x + w     , y         , 6).size() > 0) //  "rightVertic"
            ){
            isCanPutObj = false;
        }else{
         isCanPutObj = true;
        }
    }
    //qDebug() << "func setRandomXY: obj " << obj
    //         << " new objX " << x
    //         << " new objY " << y;
    obj->setProperty("x", x);
    obj->setProperty("y", y);
}
///
/// \brief BCThread::makeBonus - setting (make) bullet
/// \param globalParent        - globalParent in QML id: "battlefield"
/// \param object              - object for setting position
/// \param imgName = randomVal - bonus type can be specified for new bonus
/// \param setX    = randomVal - x coord    can be specified for new bonus
/// \param setY    = randomVal - y coord    can be specified for new bonus
///
void BCThread::makeBonus(const QVariant &Field, const QVariant &object,
                         QString imgName, float setX, float setY){
    //bonusObj = createQmlObj("Bonuses");
    QQuickItem *obj = qobject_cast<QQuickItem*>(object.value<QObject*>() );
    QVector<QString> randVariants;
    randVariants.reserve(3);
    randVariants.push_back("Helmet");
    randVariants.push_back("Timer" );
    randVariants.push_back("Tank"  );   //console.log("makeBonus: before getRandomFrom " )

    if(imgName != "none"){
        obj->setProperty("imgName", imgName);
    }else{
        obj->setProperty("imgName", getRandomFrom(randVariants) );
    }                                        //console.log("makeBonus: after getRandomFrom " + bonus.imgName )

    if(setX == 0 || setY == 0){              //console.log("makeBonus: before setRandomXY " )
        setRandomXY(Field, object,
                    obj->property("width" ).toFloat(),
                    obj->property("height").toFloat() );  //console.log("makeBonus: after setRandomXY " + bonus.imgName )
    }
}
///
/// \brief BCThread::makeShoot - setting (make) bullet
/// \param whoShotObj             - object who shoot this bullet
/// \param bulletObj              - Previously created bullet object
///
void BCThread::makeShoot(const QVariant &whoShotObj, const QVariant &bulletObj){
    QQuickItem *whoShot = qobject_cast<QQuickItem*>(whoShotObj.value<QObject*>() );
    QQuickItem *bullet  = qobject_cast<QQuickItem*>( bulletObj.value<QObject*>() );

    bullet->setProperty("whoShotObj", whoShotObj                                  );
    bullet->setProperty("fraction"  , whoShot->property("fraction"   ).toString() );
    bullet->setProperty("speed"     , whoShot->property("bulletSpeed").toInt()    );
    bullet->setProperty("minDamage" , whoShot->property("minDamage"  ).toInt()    );
    bullet->setProperty("maxDamage" , whoShot->property("maxDamage"  ).toInt()    );

    if(whoShot->property("isTankBonusAct").toBool() ){
        bullet->setProperty("width" , bullet->property("width" ).toFloat() * 1.5);
        bullet->setProperty("height", bullet->property("height").toFloat() * 1.5);
    }

    float w     =  bullet->property("width"    ).toFloat();
    float h     =  bullet->property("height"   ).toFloat();
    float x     = whoShot->property("x"        ).toFloat();
    float y     = whoShot->property("y"        ).toFloat();
    float tankW = whoShot->property("width"    ).toFloat();
    float tankH = whoShot->property("height"   ).toFloat();
    float speed = whoShot->property("speed"    ).toFloat();
    QString whoShotDirection = whoShot->property("direction").toString();

    if(whoShotDirection == "U"){
      //bullet->setProperty("rotation", 0);
        bullet->setProperty("x", x + tankW  / 2 - w / 2                );
        bullet->setProperty("y", y              - h / 2 - h - speed - 1);
    }else if(whoShotDirection == "R"){
        bullet->setProperty("rotation", 90);
        bullet->setProperty("x", x + tankW     + h / 2      + speed + 1);
        bullet->setProperty("y", y + tankH / 2 - w / 2                 );
    }else if(whoShotDirection == "D"){
        bullet->setProperty("rotation", 180);
        bullet->setProperty("x", x + tankW / 2 - w / 2                 );
        bullet->setProperty("y", y + tankH     + h / 2      + speed + 1);
    }else if(whoShotDirection == "L"){
        bullet->setProperty("rotation", 270);
        bullet->setProperty("x", x             - h / 2 - h  - speed - 1);
        bullet->setProperty("y", y + tankH / 2 - w / 2                 );
    }
    whoShot->setProperty("shoots", whoShot->property("shoots").toInt() + 1);
}

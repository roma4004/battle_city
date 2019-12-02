//function functionInJavascript(arg){
//        console.log(arg);
//        return "ReturnValueFromJS"
//    }

function moveObj(obj, direction){
    var checkArr = []
    if(direction) obj.direction = direction
    switch (obj.direction){
        case "U":
            if(obj.y - obj.speed < 0) break
            checkArr = getLineOfColliders(obj, "topHoriz")
            checkForBonus(obj, checkArr)
            if(checkArr && checkArr.length > 0) break
            obj.y = obj.y - obj.speed;
        break
        case "L":
            if(obj.x - obj.speed < 0) break
            checkArr = getLineOfColliders(obj, "leftVertic")
            checkForBonus(obj, checkArr)
            if(checkArr && checkArr.length > 0) break
            obj.x = obj.x - obj.speed
        break
        case "D":
            if(obj.y + obj.height + obj.speed > mainWindow.height) break
            checkArr = getLineOfColliders(obj, "bottomHoriz")
            checkForBonus(obj, checkArr)
            if(checkArr && checkArr.length > 0) break
            obj.y = obj.y + obj.speed
        break
        case "R":
            if(obj.x + obj.width  + obj.speed > mainWindow.width - sideBar.width ) break
            checkArr = getLineOfColliders(obj, "rightVertic")
            checkForBonus(obj, checkArr)
            if(checkArr && checkArr.length > 0) break
            obj.x = obj.x + obj.speed
        break
    }
}

function isCanMoveAI(obj, direction){
    var dir = (direction === undefined) ? obj.direction : direction    
    var checkArr = []
    switch(dir){
        case "U" : if(obj.y              - obj.speed < 0                               ) return false; break
        case "L" : if(obj.x              - obj.speed < 0                               ) return false; break
        case "D" : if(obj.y + obj.height + obj.speed > mainWindow.height               ) return false; break
        case "R" : if(obj.x + obj.width  + obj.speed > mainWindow.width - sideBar.width) return false; break
    }
    if(obj.isTankBonusAct) return true
    switch(dir){
        case "U" : checkArr = getLineOfColliders(obj, "topHoriz"   ); break
        case "L" : checkArr = getLineOfColliders(obj, "leftVertic" ); break
        case "D" : checkArr = getLineOfColliders(obj, "bottomHoriz"); break
        case "R" : checkArr = getLineOfColliders(obj, "rightVertic"); break
    }
    if(checkArr && checkArr.length > 0) return false
    return true;
}

function getLineOfColliders(obj, collidePointLine, setX, setY, setWidth, setHeight, setSpeed){
    //get all prperty from received obj OR from directly received values
    var X      = (obj      !== undefined) ? obj.x     : setX
    var Y      = (obj      !== undefined) ? obj.y     : setY
    var Width  = (obj      !== undefined) ? obj.width : setWidth
    var Height = (obj      !== undefined) ? obj.height: setHeight
    var Speed  = (obj      !== undefined) ? obj.speed :
                 (setSpeed !== undefined) ? setSpeed  : 0

    switch(collidePointLine){     //getColInLine(lineType, lineEnd, x, y, step){
        case     "topHoriz": return getColInLine("H", Width , X                    , Y              - Speed, 6)
        case  "centerHoriz": return getColInLine("H", Width , X                    , Y + Height / 2        , 6)
        case  "bottomHoriz": return getColInLine("H", Width , X                    , Y + Height     + Speed, 6)

        case   "leftVertic": return getColInLine("V", Height, X             - Speed, Y                     , 6)
        case "centerVertic": return getColInLine("V", Height, X + Width / 2        , Y                     , 6)
        case  "rightVertic": return getColInLine("V", Height, X + Width     + Speed, Y                     , 6)
    }
}
function getColInLine(lineType, lineEnd, startX, startY, step){
    var colidersInLine = [];
    for(var steps = 0; steps <= lineEnd; steps += lineEnd / step){
        var collider = (lineType === "H") ? battlefield.childAt(startX + steps, startY         )
                                          : battlefield.childAt(startX        , startY + steps )
        if(collider
        &&!collider.isPassObsticle
        && colidersInLine.indexOf(collider) === -1)
            colidersInLine.push(collider)
    }
    return colidersInLine
}
function mayShootAI(obj){
    var target, i;    
    for(i = obj.y - obj.height - 1; i > 0; i -= obj.height){
        target = battlefield.childAt(obj.x + obj.width / 2, i)
        if(target){
            if(target.fraction === "bonuses") obj.direction = "U"
            if(target.fraction === "Players"){
                obj.direction = "U";
                return true
            }
            if(target.fraction === "neitral" && obj.direction === "U" ) return getRandomInt(0, 1)
            break
        }
    }
    for(i = obj.x + obj.width + 1; i < mainWindow.width - sideBar.width; i += obj.width){
        target = battlefield.childAt(i, obj.y + obj.height / 2 );
        if(target){
            if(target.fraction === "bonuses") obj.direction = "R"
            if(target.fraction === "Players"){
                obj.direction = "R";
                return true
            }
            if(target.fraction === "neitral" && obj.direction === "R") return getRandomInt(0, 1)
            break
        }
    }
    for(i = obj.y + obj.height + 1; i < mainWindow.height; i += obj.height){
        target = battlefield.childAt(obj.x + obj.width / 2, i );
        if(target){
            if(target.fraction === "bonuses") obj.direction = "D"
            if(target.fraction === "Players"){
                obj.direction = "D"
                return true
            }
            if(target.fraction === "neitral" && obj.direction === "D") return getRandomInt(0, 1)
            break
        }
    }
    for(i = obj.x - obj.width - 1; i > 0; i -= obj.width){
        target = battlefield.childAt(i, obj.y + obj.height / 2 );
        if(target){
            if(target.fraction === "bonuses") obj.direction = "L"
            if(target.fraction === "Players"){
                obj.direction = "L"
                return true
            }
            if(target.fraction === "neitral" && obj.direction === "L") return getRandomInt(0, 1)
            break
        }
    }
    return false
}

function makeShoot(whoShotObj){
    var component = Qt.createComponent("qrc:/qml/Bullet.qml")
    if (component.status === Component.Ready){
        var bullet = component.createObject(battlefield)
        bullet.whoShotObj      = whoShotObj        
        bullet.fraction        = whoShotObj.fraction
        bullet.speed           = whoShotObj.bulletSpeed
        bullet.bulletMinDamage = whoShotObj.bulletMinDamage
        bullet.bulletMaxDamage = whoShotObj.bulletMaxDamage
        bullet.width          *= whoShotObj.isTankBonusAct ? 1.5 : 1
        bullet.height         *= whoShotObj.isTankBonusAct ? 1.5 : 1

        switch (whoShotObj.direction){
            case "U":
              //bullet.rotation = 0
                bullet.x = whoShotObj.x + whoShotObj.width  / 2 - bullet.width  / 2
                bullet.y = whoShotObj.y                         - bullet.height / 2  - bullet.height - whoShotObj.speed - 1
            break
            case "R":
                bullet.rotation = 90
                bullet.x = whoShotObj.x + whoShotObj.width      + bullet.height / 2                  + whoShotObj.speed + 1
                bullet.y = whoShotObj.y + whoShotObj.height / 2 - bullet.width  / 2
            break
            case "D":
                bullet.rotation = 180
                bullet.x = whoShotObj.x + whoShotObj.width  / 2 - bullet.width  / 2
                bullet.y = whoShotObj.y + whoShotObj.height     + bullet.height / 2                  + whoShotObj.speed + 1
            break
            case "L":
                bullet.rotation = 270
                bullet.x = whoShotObj.x                         - bullet.height / 2 - bullet.height  - whoShotObj.speed - 1
                bullet.y = whoShotObj.y + whoShotObj.height / 2 - bullet.width  / 2
            break
        }
        whoShotObj.counterShoots++
    }
}

function makeObsticle(blockWidth, blockHeight, x, y, parrentObj, imgName ){
    var component = Qt.createComponent("qrc:/qml/Brick.qml");
    if (component.status === Component.Ready){
        var block = component.createObject(parrentObj);
        block.imgName        =  imgName
        block.width          = (imgName === "base"      ) ? blockWidth  * 4  : blockWidth
        block.height         = (imgName === "base"      ) ? blockHeight * 4  : blockHeight
        block.fraction       = (imgName === "base"      ) ? "Players"        :
                               (imgName === "brickWhite") ? "unDestructible" : "neitral"
        block.isDestructible = (imgName === "brickWhite") ? false            : true
        block.x = x * blockWidth
        block.y = y * blockHeight
    }
}

function makeBonus(setX, setY){
    var component = Qt.createComponent("qrc:/qml/Bonuses.qml");
    if (component.status === Component.Ready){
        var bonus = component.createObject(battlefield);
        var randVariants = ["Helmet","Timer","Tank"]
        console.log("makeBonus: before getRandomFrom " )
        bonus.imgName = getRandomFrom(randVariants)
        console.log("makeBonus: after getRandomFrom " + bonus.imgName )
        if(setX === undefined
        || setY === undefined){
            console.log("makeBonus: before setRandomXY " )
            setRandomXY(bonus)
            console.log("makeBonus: after setRandomXY " + bonus.imgName )
        }
    }
}

function checkForBonus(obj, colliderArray){
    for(var check in colliderArray) {
        switch(colliderArray[check].imgName){
            case "Helmet":               // bonusPickUp.play()
                obj.isHelmetBonusAct = true
                takeDamage(colliderArray[check], 100, 100, obj)
            break
            case "Timer":               // bonusPickUp.play()
                if(obj.fraction === "Players") battlefield.isTimerBonusActEn = true
                else                           battlefield.isTimerBonusActPl = true
                takeDamage(colliderArray[check], 100, 100, obj)
            break
            case "Tank":               // bonusPickUp.play()
                obj.isTankBonusAct = true
                takeDamage(colliderArray[check], 100, 100, obj)
            break
        }
        if (obj.isTankBonusAct){
            var coliderLines = [   "topHoriz",   "leftVertic",
                                "centerHoriz", "centerVertic",
                                "bottomHoriz",  "rightVertic" ];
            for (var line in coliderLines ){
                var coliders = getLineOfColliders(obj, coliderLines[line])
                for (var col in coliders ){
                    if(obj.tag !== coliders[col].tag) takeDamage(coliders[col], 100, 100, obj);
                }
            }
        }
    }
}

function takeDamage(hitObj, bulletMinDamage, bulletMaxDamage, whoShotObj){
  console.log("takeDamage: whoShotObj.tag: " + whoShotObj.tag
             +               " hitObj.tag: " + hitObj.tag
             +            " hitObj.health: " + hitObj.health
             +    " hitObj.isDestructible: " + hitObj.isDestructible
             +           " hitObj.imgName: " + hitObj.imgName
             +          " hitObj.fraction: " + hitObj.fraction
             );

    if(hitObj.isHelmetBonusAct || !hitObj.isDestructible) return
    if(hitObj.imgName === "base"){
        hitObj.imgName = "baseFlag"
        hitObj.isDestructible = false
        hitObj.fraction =  "none"
        p1.spawnPoints = 0
        p2.spawnPoints = 0
        battlefield.isDestroyedHQ = true
        return
    }
    if(hitObj.imgName === "baseFlag") return
    if(hitObj.health > 0) {
        hitObj.health -= getRandomInt(bulletMinDamage, bulletMaxDamage);
        switch(hitObj.tag){
            case "bullet":      whoShotObj.counterBulletHits++; break
            case "obsticleWall":whoShotObj.counterBrickHits++;  break
            default:            whoShotObj.counterTagetHits++
        }
    }
}

function setRandomdirectionAI(obj){
    var randVariants = []
    if(isCanMoveAI(obj, "U") ) randVariants.push("U")
    if(isCanMoveAI(obj, "L") ) randVariants.push("L")
    if(isCanMoveAI(obj, "D") ) randVariants.push("D")
    if(isCanMoveAI(obj, "R") ) randVariants.push("R")
    var newDir = getRandomFrom(randVariants)
    if(newDir) obj.direction = newDir
}
function setRandomXY(obj, Width, Height){
    var objWidth  = (Width  !== undefined) ? Height : obj.height
    var objHeight = (Height !== undefined) ? Width  : obj.width
    var isCanPutObj = false;
    var objX, objY
    while(isCanPutObj === false){//переделать на гет рандом из вариантов
        objX = getRandomInt(obj.spawnPosMinX, obj.spawnPosMaxX)
        objY = getRandomInt(obj.spawnPosMinY, obj.spawnPosMaxY)        
        if( (getLineOfColliders(undefined,    "topHoriz", objX, objY, objWidth, objHeight).length > 0)
         || (getLineOfColliders(undefined, "centerHoriz", objX, objY, objWidth, objHeight).length > 0)
         || (getLineOfColliders(undefined, "bottomHoriz", objX, objY, objWidth, objHeight).length > 0)
       //|| (getLineOfColliders(undefined,  "leftVertic", objX, objY, objWidth, objHeight).length > 0)
       //|| (getLineOfColliders(undefined,"centerVertic", objX, objY, objWidth, objHeight).length > 0)
       //|| (getLineOfColliders(undefined, "rightVertic", objX, objY, objWidth, objHeight).length > 0)
                ){
            isCanPutObj = false
        }else{
         isCanPutObj = true
        }
    }
    console.log("func setRandomXY: obj " + obj + " new objX " + objX + " new objY " + objY)
    obj.x = objX;
    obj.y = objY;

}
function getRandomInt(min, max){
    var rand = Math.round(Math.random() * (max - min) + min)
    console.log("func getRandomInt: rand " + rand )
    return rand
}
function getRandomFrom(variantsArray){
    var rand = variantsArray[getRandomInt(0, variantsArray.length - 1)]
    console.log("func getRandomFrom: rand " + rand )
    return rand
}

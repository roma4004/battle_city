function functionInJavascript(arg){
        console.log(arg);
        return "ReturnValueFromJS"
    }
    
    
    
function moveObl(obj, direction){if(!obj) return;
    switch (direction){
        case "U" : if(isCanMove(obj, direction) ) obj.y = obj.y - obj.speed; break;
        case "L" : if(isCanMove(obj, direction) ) obj.x = obj.x - obj.speed; break;
        case "D" : if(isCanMove(obj, direction) ) obj.y = obj.y + obj.speed; break;
        case "R" : if(isCanMove(obj, direction) ) obj.x = obj.x + obj.speed; break;
    }
    obj.state = (obj.state === direction+"1") ? direction+"2" : direction+"1";
}

function isCanMove(obj, dirrection){if(!obj) return; // console.log("checkObsticle dir"+dirrection);
    var check1, check2, check3
    switch(dirrection){
        case "U" : check1 = getCollider(obj, "leftTop"    , dirrection)
                   check2 = getCollider(obj, "centerTop"  , dirrection)
                   check3 = getCollider(obj, "rightTop"   , dirrection)
                                                                        if(obj.y              - obj.speed < 0                ) return false
        break
        case "L" : check1 = getCollider(obj, "leftTop"    , dirrection)
                   check2 = getCollider(obj, "leftCenter" , dirrection)
                   check3 = getCollider(obj, "leftDown"   , dirrection)
                                                                        if(obj.x              - obj.speed < 0                ) return false
        break
        case "D" : check1 = getCollider(obj, "leftDown"   , dirrection)
                   check2 = getCollider(obj, "centerDown" , dirrection)
                   check3 = getCollider(obj, "rightDown"  , dirrection)
                                                                        if(obj.y + obj.height + obj.speed > mainWindow.height) return false
        break
        case "R" : check1 = getCollider(obj, "rightTop"   , dirrection)
                   check2 = getCollider(obj, "rightCenter", dirrection)
                   check3 = getCollider(obj, "rightDown"  , dirrection)
                                                                        if(obj.x + obj.width  + obj.speed > mainWindow.width ) return false
        break
    }

    if( (check1) && (check1.fraction === "passObsticle") ) check1 = false
    if( (check2) && (check2.fraction === "passObsticle") ) check2 = false
    if( (check3) && (check3.fraction === "passObsticle") ) check3 = false  //console.log(check1+""+check2)
    if( (check1)
     || (check2)
     || (check3)) return false
    return true;
}

function getCollider(obj, collidePoint, dirrection, coordX, coordY, width, height){if(!obj) return; //we get all prperty from received obj or from directly received values

    var collider;
    var objX      = (coordX    === undefined)? obj.x      : coordX;
    var objY      = (coordY    === undefined)? obj.y      : coordY;    //console.log(" obj.tag: " + obj.tag + " collidePoint: " + collidePoint + " dirrection: " + dirrection);
    var objWidth  = (objWidth  === undefined)? obj.width  : width;
    var objHeight = (objHeight === undefined)? obj.height : height;

    if(dirrection !== undefined){
        switch(dirrection){
            case "U" : objY -= obj.speed-1; break
            case "L" : objX -= obj.speed-1; break
            case "D" : objY += obj.speed+1; break
            case "R" : objX += obj.speed+1; break
        }
    }
    switch(collidePoint){
        case "leftTop"     : collider = battlefield.childAt(objX               , objY                ); break;
        case "centerTop"   : collider = battlefield.childAt(objX + objWidth / 2, objY                ); break;
        case "rightTop"    : collider = battlefield.childAt(objX + objWidth    , objY                ); break;

        case "leftCenter"  : collider = battlefield.childAt(objX               , objY + objHeight / 2); break;
        case "centerCenter": collider = battlefield.childAt(objX + objWidth / 2, objY + objHeight / 2); break;
        case "rightCenter" : collider = battlefield.childAt(objX + objWidth    , objY + objHeight / 2); break;

        case "leftDown"    : collider = battlefield.childAt(objX               , objY + objHeight    ); break;
        case "centerDown"  : collider = battlefield.childAt(objX + objWidth / 2, objY + objHeight    ); break;
        case "rightDown"   : collider = battlefield.childAt(objX + objWidth    , objY + objHeight    ); break;
    }
    return collider ;
}
function randomChangeDirrection(obj){if(!obj) return;
    //сделать проверку нужно ли разворачиватся в ту сторону
    var min = 1 , max = 5;
    var rand = Math.floor (Math.random() * (max - min) + min);
    switch (rand){
        case 1 : obj.dirrection = "U"; break;
        case 2 : obj.dirrection = "L"; break;
        case 3 : obj.dirrection = "D"; break;
        case 4 : obj.dirrection = "R"; break;
    }
}
function mayShootPayerAI(obj){if(!obj) return; var target, i;
    switch(obj.dirrection) {
        case "U":
            for(i = obj.y - obj.height - 1; i > 0; i -= obj.height){
                target = battlefield.childAt(obj.x + obj.width / 2, i);                //if(target) console.log("p1.fraction" + p1.fraction);
                if ( (target) && (target.fraction === "Players") ) return true         //console.log("i: " + i);         // console.log("true" +obj.x +     i);
            }
        break;
        case "R":
            for(i = obj.x + obj.width + 1; i < mainWindow.width; i += obj.width){
                target = battlefield.childAt(i, obj.y + obj.height / 2 );              //if(target) console.log(target.fraction);
                if ( (target) && (target.fraction === "Players") ) return true         //console.log("true" +    i + obj.y);
            }
        break;
        case "D":
            for(i = obj.y + obj.height + 1; i < mainWindow.height; i += obj.height){
                target = battlefield.childAt(obj.x + obj.width / 2, i );               //if(target) console.log(target.fraction);
                if ( (target) && (target.fraction === "Players") ) return true         //console.log("true" +obj.x +     i);
            }
        break;
        case "L":
            for(i = obj.x - obj.width - 1; i > 0; i -= obj.width){
                target = battlefield.childAt(i, obj.y + obj.height / 2 );              //if(target) console.log(target.fraction);
                if ( (target) && (target.fraction === "Players") ) return true         // console.log("true"+     i + obj.y);
            }
        break;
    }
    return false
}
function makeShoot(obj){if(!obj) return
    var component = Qt.createComponent("qrc:/qml/Bullet.qml");
    if (component.status === Component.Ready){
        var bullet = component.createObject(battlefield);
        bullet.tag = "Bullet_"+obj.tag
        bullet.fraction = obj.fraction
        switch (obj.state){                                  //find coordinate to create bullet
            case "U1" : case "U2" : bullet.rotation = 0  ; bullet.x = obj.x + obj.width   / 2 - bullet.width  / 2    ;
                                                           bullet.y = obj.y                                       - 9; break;
            case "R1" : case "R2" : bullet.rotation = 90 ; bullet.x = obj.x + obj.width                           + 2;
                                                           bullet.y = obj.y + obj.height / 2  - bullet.width  / 2 - 1; break;
            case "D1" : case "D2" : bullet.rotation = 180; bullet.x = obj.x + obj.width  / 2  - bullet.width  / 2    ;
                                                           bullet.y = obj.y + obj.height                          + 2; break;
            case "L1" : case "L2" : bullet.rotation = 270; bullet.x = obj.x                                       - 9;
                                                           bullet.y = obj.y + obj.height / 2  - bullet.width  / 2 - 1; break;
        }
    }
}
function setRandomXY(obj){ if(!obj) return;
    var isCanPutObj = false;
    var i=0;
    var objX = obj.x
    var objY = obj.y
    while(isCanPutObj === false){
        objX = Math.floor (Math.random() * (mainWindow.width  - obj.width  - 0) + 0);
        objY = Math.floor (Math.random() * (mainWindow.height - obj.height - 0) + 0);
        console.log("setRandomXY " +i++);
        if( (getCollider(undefined, "leftTop"     , objX, objY, obj.width, obj.height) )
         || (getCollider(undefined, "centerTop"   , objX, objY, obj.width, obj.height) )
         || (getCollider(undefined, "rightTop"    , objX, objY, obj.width, obj.height) )
         || (getCollider(undefined, "leftCenter"  , objX, objY, obj.width, obj.height) )
         || (getCollider(undefined, "centerCenter", objX, objY, obj.width, obj.height) )
         || (getCollider(undefined, "rightCenter" , objX, objY, obj.width, obj.height) )
         || (getCollider(undefined, "leftDown"    , objX, objY, obj.width, obj.height) )
         || (getCollider(undefined, "centerDown"  , objX, objY, obj.width, obj.height) )
         || (getCollider(undefined, "rightDown"   , objX, objY, obj.width, obj.height) )
          ){ isCanPutObj = false
        }else{
            isCanPutObj = true
        }
    }
    obj.x = objX;
    obj.y = objY;
    //сделать проверку возможности размещение там объекта
}
/*function die(killer, victim){      console.log("killer: " + killer.tag + "; victim: " + victim.tag);
    killer.counterTagetHits++;     console.log("counterP1TagetHits " + killer.counterTagetHits);
    victim.visible = false;
    victim.revival.start();
}
*/
function makeObj(X,Y,objType){
    var component = Qt.createComponent("qrc:/qml/Bullet.qml");
    if (component.status === Component.Ready)  var bullet = component.createObject(battlefield);

}
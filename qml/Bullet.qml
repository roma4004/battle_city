import QtQuick 2.7
import "logics.js" as JS

Rectangle{
    property string tag: "bullet"
    property string fraction: "neitral"
    property string imgName: "bullet"
    property string png: ".png"
    property string imgPath: "qrc:/img/"

    property bool isPassObsticle: isNeedExplode
    property bool isDestructible:!isNeedExplode
    property bool isNeedExplode : false

    property int speed: 8
    property int bulletMinDamage
    property int bulletMaxDamage
    property int health: 1
    property int maxWidth : mainWindow.width  - width  - sideBar.width
    property int maxHeight: mainWindow.height - height - 4

 // property var block
    property var whoShotObj
    property var collidersObj: []

    z: 3
    width:  3 * parent.blockWidth  / 6
    height: 4 * parent.blockHeight / 6
    color: "transparent"

    onHealthChanged: isNeedExplode = true
    onXChanged: {
        if(x > maxWidth
        || x <    width
        || health < 0   ) isNeedExplode = true
    }
    onYChanged: {
        if(y > maxHeight
        || y <    height
        || health < 0   ) isNeedExplode = true
    }
    Image{
        anchors.fill: parent
        visible: !isNeedExplode
        source: imgPath+imgName+png
    }
    AnimatedSprite{
        anchors.centerIn: parent
        width: 32
        height: 32
        source: "qrc:/img/spriteExpl5.png"
        frameCount: 5
        frameWidth: 32
        frameHeight: 32
        frameDuration: 500/frameCount
        visible: running
        running: isNeedExplode
    }

    Timer{interval: 500
        running: isNeedExplode
        onTriggered: parent.destroy()
    }
    Timer{interval: 40
        running: !isNeedExplode && !battlefield.isGamePaused
        repeat: true
        onTriggered: {
            var checkLine = ["leftVertic", "rightVertic", "topHoriz", "bottomHoriz"]
            var setWidth, setHeight
            switch(parent.rotation){
            case 0  :
            case 180:
                     setWidth  = width
                     setHeight = height
            break
            case 90 :
            case 270:
                     setWidth  = height
                     setHeight = width
            break
            }
            for(var lineID in checkLine){
                var colidersAll = JS.getLineOfColliders(undefined, checkLine[lineID], x, y, setWidth, setHeight, 1)
                for (var colliderID in colidersAll)
                    if(collidersObj.indexOf(colidersAll[colliderID]) === -1 )
                        collidersObj.push(colidersAll[colliderID])
            }

            for (var unicColladerID in collidersObj){
                JS.takeDamage(collidersObj[unicColladerID], bulletMinDamage, bulletMaxDamage, whoShotObj)
                isNeedExplode = true
            }
            if(!isNeedExplode)
                switch(parent.rotation){
                    case 0  : y -= parent.speed; break
                    case 90 : x += parent.speed; break
                    case 180: y += parent.speed; break
                    case 270: x -= parent.speed; break
                }
        }
    }
    /*Text{ id: label1 // property string tag: "TankText1";
        anchors{
            verticalCenter:   parent.bottom;
            horizontalCenter: parent.horizontalCenter;
        }
        text: parent.tag +"_"+ parent.fraction
    }*/
}

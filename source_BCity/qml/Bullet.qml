import QtQuick 2.7
import "logics.js" as JS

GameObj{
    property bool isNeedExplode: false

    property int speed: 8
    property int minDamage
    property int maxDamage

    property var whoShotObj
    property var collidersObj: []

    tag: "bullet"
    fraction: "neitral"
    imgName: "bullet"
    isObjImgVisible: !isNeedExplode
    isPassObsticle:   isNeedExplode
    isDestructible:  !isNeedExplode
    width:  3 * parent.blockWidth  / 6
    height: 4 * parent.blockHeight / 6
    z: 3
    onXChanged: {
           if(x > maxWidth - width
           || x <    width
           || health < 0   ) isNeedExplode = true
    }
    y: 50
    onYChanged: {
           if(y > maxHeight - 4
           || y <    height
           || health < 0   ) isNeedExplode = true
    }
    onHealthChanged: isNeedExplode = true

    AnimatedSprite{
        anchors.centerIn: parent
        width: 32
        height: 32
        source: imgPath + "spriteExpl5.png"
        frameCount: 5
        frameWidth: 32
        frameHeight: 32
        frameDuration: 500 / frameCount
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
            ThreadP.getBulletColliders(battlefield, parent, whoShotObj)

            if(!isNeedExplode)
                switch(parent.rotation){
                    case 0  : y -= parent.speed; break
                    case 90 : x += parent.speed; break
                    case 180: y += parent.speed; break
                    case 270: x -= parent.speed; break
                }
        }
    }
}

import QtQuick 2.7
import "logics.js" as JS

GameObj{
    health: 1
    onHealthChanged: {
        bonusPickUp.play()
        destroy()
    }
    width:  battlefield.blockWidth  * 3
    height: battlefield.blockHeight * 3
    tag: "bonus"
    fraction: "bonuses"
    imgName: "Timer"
    sourceImg: imgPath + tag + imgName + png
    isPassObsticle: false
    isDestructible: true
    isObjImgVisible: true
    Component.onCompleted:
        pickUpTimeout.interval = ThreadP.getRandomInt(10, 20) * 1000                               

    Timer{running: true; interval: 300; repeat: true
        onTriggered: parent.visible = (parent.visible) ? false : true
    }
    Timer{id: pickUpTimeout; interval: 20000; running: !battlefield.isGamePaused
        onTriggered: parent.destroy()
    }
}

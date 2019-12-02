import QtQuick 2.7
import "logics.js" as JS

Image {id: bonusImg
    property string tag: "bonus"
    property string fraction: "bonuses"
    property string imgPath: "qrc:/img/"
    property string imgName: "Tank"
    property string png: ".png"
    property bool isPassObsticle: false
    property bool isDestructible: true
    property int health: 1
    property int spawnPosMinX: 0
    property int spawnPosMaxX: mainWindow.width - width  - sideBar.width
    property int spawnPosMinY: 0
    property int spawnPosMaxY: mainWindow.height - height

    onHealthChanged: {
        bonusPickUp.play()
        destroy()
    }

    width:  battlefield.blockWidth  * 3
    height: battlefield.blockHeight * 3
    source: imgPath + tag + imgName + png

    Timer{id: blinking; running: true; interval: 300; repeat: true
        onTriggered: {bonusImg.visible = ( bonusImg.visible) ? false : true }
    }
    Component.onCompleted: pickUpTimeout.interval = Cpp.getRandomInt(10, 20) * 1000 //JS.getRandomInt(10, 20) * 1000

    Timer{id: pickUpTimeout; interval: 10000; running: !battlefield.isGamePaused
        onTriggered: {parent.destroy() }
    }
}

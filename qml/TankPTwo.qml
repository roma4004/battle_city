import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import "logics.js" as JS

Rectangle{ //player2
    property string tag: "P2"
    property string fraction: "Players"
    property string imgPath : "qrc:/img/"
    property string direction: "U"
    property string png:".png"
    property string sourceImg: imgPath+tag+direction+imgFrame+png

    property bool isPassObsticle  : !tankImg.visible
    property bool isDestructible  :  tankImg.visible
    property bool isPressedUp     : false
    property bool isPressedLeft   : false
    property bool isPressedDown   : false
    property bool isPressedRight  : false
    property bool isPressedFire   : false

    property bool isTankBonusAct  : false
    property bool isHelmetBonusAct: false
    property bool isNeedExplode   : false
    property bool spawnReady      : false

    property int helmetInterval: 10000
    property int imgFrame: 1
    property int health: 100
    property int bulletSpeed: 7
    property int bulletMinDamage: 10
    property int bulletMaxDamage: 50
    property int counterShoots: 0
    property int counterTagetHits: 0
    property int counterBulletHits: 0
    property int counterBrickHits: 0
    property int spawnPoints: 3
    property int reloadInterval: 2000 //ms
    property int spawnPosMinX: mainWindow.width /2 + battlefield.blockWidth * 4
    property int spawnPosMaxX: mainWindow.width - width  - sideBar.width
    property int spawnPosMinY: mainWindow.height - height
    property int spawnPosMaxY: mainWindow.height - height
    property int maxWidth : mainWindow.width - sideBar.width
    property int maxHeight: mainWindow.height

    property double speed : 3.2

    z: (isTankBonusAct) ? - 1 : 1
    width:  parent.blockWidth  * 2.5 * ( (isTankBonusAct) ? 1.5 : 1)
    height: parent.blockHeight * 2.5 * ( (isTankBonusAct) ? 1.5 : 1)
    color: "transparent"
    onHealthChanged: if(health < 1) {tankImg.visible = false; isNeedExplode = true}
    onDirectionChanged:                             sourceImg = imgPath+tag+direction+imgFrame+png
    onXChanged:{imgFrame = (imgFrame === 1) ? 2 : 1; sourceImg = imgPath+tag+direction+imgFrame+png}
    onYChanged:{imgFrame = (imgFrame === 1) ? 2 : 1; sourceImg = imgPath+tag+direction+imgFrame+png}

    Rectangle{ id: healthBar
        color: (health > 80) ? "green" : (health > 40) ? "yellow" : "red"
        border.color: "black"; width: health / 4; height: 5
        z: 2
        opacity: 0.5
        visible: health < 100
        anchors.horizontalCenter: parent.horizontalCenter
    }

    AnimatedImage{
        width:  parent.width  * 1.3 ;
        height: parent.height * 1.3
        anchors.centerIn: parent
        source: imgPath + "Helmet.gif"
        visible: playing
        playing: isHelmetBonusAct
    }
    AnimatedSprite{id: explSprite
        anchors{fill: parent; centerIn: parent}
        source: "qrc:/img/spriteExpl9.png"
        frameCount: 9
        frameWidth: 32
        frameHeight: 32
        frameDuration: 900/frameCount
        visible: running
        running: isNeedExplode
    }

    AnimatedSprite{id: spawnSprite
        anchors{fill: parent; centerIn: parent}
        source: "qrc:/img/sprateSpawn7.png"
        frameCount: 7
        frameWidth: 15
        frameHeight: 15
        frameDuration: 700/frameCount
        visible: running
        running: spawnReady
        z:5
    }

    Image {id: tankImg
        anchors.fill: parent
        source: parent.sourceImg
        visible: false
        onVisibleChanged: if (!visible) explosion.play()
    }

    Timer{
        interval: helmetInterval
        running: isHelmetBonusAct
        onTriggered:{
            isHelmetBonusAct = false; helmetInterval = 10000
        }
    }
    Timer{
        interval: 15000
        running: isTankBonusAct
        onTriggered: isTankBonusAct = false
    }
    Timer{
        interval: 900
        running: isNeedExplode
        onTriggered: {
            isNeedExplode = false
            parent.x = -100
        }
    }
    Timer{
        interval: 80
        running: tankImg.visible && !battlefield.isGamePaused
        repeat: true
        onTriggered:{
            if(!battlefield.isTimerBonusActPl){
                if(parent.isPressedUp   ){Cpp.moveObj(battlefield, parent, "U", maxWidth, maxHeight)}else
                if(parent.isPressedRight){Cpp.moveObj(battlefield, parent, "R", maxWidth, maxHeight)}else
                if(parent.isPressedDown ){Cpp.moveObj(battlefield, parent, "D", maxWidth, maxHeight)}else
                if(parent.isPressedLeft ){Cpp.moveObj(battlefield, parent, "L", maxWidth, maxHeight)}

              //below comented is a JavaScript variant of move this tank
              //if(parent.isPressedUp   ) {JS.moveObj(parent, "U")}else
              //if(parent.isPressedRight) {JS.moveObj(parent, "R")}else
              //if(parent.isPressedDown ) {JS.moveObj(parent, "D")}else
              //if(parent.isPressedLeft ) {JS.moveObj(parent, "L")}
            }
                if(parent.isPressedFire  && !reloadInterval.running){
                    var component = Qt.createComponent("qrc:/qml/Bullet.qml");
                    if (component.status === Component.Ready){
                        Cpp.makeShoot(parent, component.createObject(battlefield) )
                        bulletShoot.play()
                        reloadInterval.start()
                    }
                //below comented is a JavaScript variant
                //if(parent.isPressedFire  && !reloadInterval.running){
                //    JS.makeShoot(parent);
                //    bulletShoot.play()
                //    reloadInterval.start();
                //}
            }        
        }
    }
    Timer{id: reloadInterval
        interval: parent.reloadInterval
    }
    Timer{
        interval: 3000
        running: !tankImg.visible
                 && parent.spawnPoints > 0
                 && !battlefield.isGamePaused
        onTriggered: {
            parent.spawnPoints--
            parent.health = 100
            helmetInterval = 5000                                 
            //below comented C++ variant(!notWorked)
            //Cpp.setRandomXY(battlefield, parent, parent.width, parent.height)
            JS.setRandomXY(parent)
            parent.spawnReady = true
        }
    }
    Timer{
        interval: 2100
        running: spawnReady
        onTriggered:{
            spawnReady = false
            tankImg.visible = true
            isHelmetBonusAct = true
        }
    }
    /*Text{ id: label1
        anchors.left:parent.right
        text: parent.tag+" x: "+ parent.x +" y: "+parent.y
    }
    Text{ id: label2
        anchors{
            top: label1.bottom;
            left: parent.right
        }
        text: "Shoots/TankHits/BulletHits/BrickHits: " + parent.counterShoots+"/"+parent.counterTagetHits+"/"+parent.counterBulletHits+"/"+counterBrickHits
    }*/
}

import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import "logics.js" as JS

Rectangle{
    property string imgPath : "qrc:/img/"
    property string direction: "U"
    property string png: ".png"    
    property string sourceImg: imgPath + imgName + direction + imgFrame + png

    property bool isPassObsticle  : !tankImg.visible
    property bool isDestructible  :  tankImg.visible
    property bool isTankBonusAct  : false
                onIsTankBonusActChanged:
                    if(isTankBonusAct){
                        health = health * ( (isTankBonusAct) ? 1.5 : 1)
                    }else{
                        health = health / ( (isTankBonusAct) ? 1.5 : 1)
                    }
    property bool isHelmetBonusAct: false
    property bool isNeedExplode   : false
    property bool spawnReady      : false

    property bool isPressedUp     : false
    property bool isPressedLeft   : false
    property bool isPressedDown   : false
    property bool isPressedRight  : false
    property bool isPressedFire   : false


    property int helmetInterval: 10000 //ms
    property int imgFrame: 1
    property int bulletSpeed: 7
    property int bulletMinDamage: 10 * ( (isTankBonusAct) ? 1.5 : 1)
    property int bulletMaxDamage: 50 * ( (isTankBonusAct) ? 1.5 : 1)
    property int health: 100
               onHealthChanged:
                   if(health < 1) {
                       tankImg.visible = false
                       isNeedExplode = true
                   }
    property int counterShoots: 0
    property int counterTagetHits: 0
    property int counterTankKils: 0
    property int counterBulletHits: 0
    property int counterBrickHits: 0
    property int reloadInterval: 2000 //ms
    property int maxWidth : mainWindow.width - sideBar.width
    property int maxHeight: mainWindow.height

    property double speed : 3.2

    z: 1
    x: -100
    color: "transparent"
    width:  parent.blockWidth  * 2.5 * ( (isTankBonusAct) ? 1.5 : 1)
    height: parent.blockHeight * 2.5 * ( (isTankBonusAct) ? 1.5 : 1)
    onWidthChanged: {
        if (width === parent.blockWidth * 2.5){
            x += (parent.blockWidth * 2.5 * 1.5) / 2 - width / 2
        }
    }
    onHeightChanged: {
        if (height === parent.blockHeight * 2.5){
            y += (parent.blockHeight * 2.5 * 1.5) / 2 - height / 2
        }
    }
    onDirectionChanged:
        sourceImg = imgPath + imgName + direction + imgFrame + png
    onXChanged:{
        imgFrame = (imgFrame === 1) ? 2 : 1
        sourceImg = imgPath + imgName + direction + imgFrame + png
    }
    onYChanged:{
        imgFrame = (imgFrame === 1) ? 2 : 1
        sourceImg = imgPath + imgName + direction + imgFrame + png
    }

    Rectangle{id: healthBar
        color: (health > 80) ? "green"  :
               (health > 40) ? "yellow" : "red"
        border.color: "black"
        width: health / 4
        height: 5
        z: 2
        opacity: 0.5
        visible: health < 100
        anchors.horizontalCenter: parent.horizontalCenter
    }

    AnimatedImage{
        width:  parent.width  * 1.3
        height: parent.height * 1.3
        anchors.centerIn: parent
        source: imgPath + "Helmet.gif"
        visible: playing
        playing: isHelmetBonusAct
    }

    AnimatedSprite{id: explSprite
        anchors{fill: parent; centerIn: parent}
        source: imgPath + "spriteExpl9.png"
        frameCount: 9
        frameWidth: 32
        frameHeight: 32
        frameDuration: 900 / frameCount
        visible: running
        running: isNeedExplode
    }

    AnimatedSprite{id: spawnSprite
        anchors{fill: parent; centerIn: parent}
        source: imgPath + "sprateSpawn7.png"
        frameCount: 7
        frameWidth: 15
        frameHeight: 15
        frameDuration: 700 / frameCount
        visible: running
        running: spawnReady
        z:5
    }

    Image {id: tankImg
        anchors{fill: parent; centerIn: parent}
        source: parent.sourceImg
        visible: false
        onVisibleChanged: if (!visible) explosion.play()
    }

    Timer{
        interval: 2100
        running: spawnReady
        onTriggered:{
            spawnReady = false
            tankImg.visible = true
            if (tag === "P1"
             || tag === "P2") isHelmetBonusAct = true
            if (tag === "P1") battlefield.p1Active = true
            if (tag === "P2") battlefield.p1Active = true
        }
    }

    Timer{
        interval: helmetInterval
        running: isHelmetBonusAct
        onTriggered:{
            isHelmetBonusAct = false
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
        onTriggered:{
            isNeedExplode = false
            if (tag === "P1" && parent.spawnPoints === 0)
                battlefield.p1Active = false
            if (tag === "P2" && parent.spawnPoints === 0)
                battlefield.p1Active = false
            parent.x = -100
        }
    }

    Timer{
        interval: 80
        running: tankImg.visible
                 && !isTimerBonusAct
                 && !battlefield.isGamePaused
        repeat: true
        onTriggered:{

            if (parent.isControledByAI){

                if(Cpp.isCanMoveAI(battlefield, parent, parent.direction,
                                   maxWidth, maxHeight) === false)
                    randomChangedirectionAI.interval = 100
                Cpp.moveObj(battlefield, parent, parent.direction,
                            maxWidth, maxHeight)

              //below comented is a JavaScript variant
              //if (JS.isCanMoveAI(parent, parent.direction) === false)
              //    randomChangedirectionAI.interval = 100
              //JS.moveObj(parent, parent.direction)

            }else{

                if(parent.isPressedUp){
                    Cpp.moveObj(battlefield, parent, "U",
                                maxWidth, maxHeight)
                }else
                    if(parent.isPressedRight){
                        Cpp.moveObj(battlefield, parent, "R",
                                    maxWidth, maxHeight)
                    }else
                        if(parent.isPressedDown){
                            Cpp.moveObj(battlefield, parent, "D",
                                        maxWidth, maxHeight)
                        }else
                            if(parent.isPressedLeft){
                                Cpp.moveObj(battlefield, parent, "L",
                                            maxWidth, maxHeight)
                            }
                //below comented is a JavaScript variant
               /* if(parent.isPressedUp) {
                      JS.moveObj(parent, "U")
                  }else
                      if(parent.isPressedRight) {
                          JS.moveObj(parent, "R")
                      }else
                          if(parent.isPressedDown) {
                              JS.moveObj(parent, "D")
                          }else
                              if(parent.isPressedLeft) {
                                  JS.moveObj(parent, "L")
                              }
               */
            }
                if(parent.isPressedFire && !reloadInterval.running){

                    Cpp.makeShoot(parent, JS.createQmlObj("Bullet") )
                  //below comented is a JavaScript variant
                  //JS.makeShoot(parent)

                    bulletShoot.play()
                    reloadInterval.start()
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
        onTriggered:{
            if (tag === "P1" || tag === "P2"){
                parent.spawnPoints--
            }else{
                battlefield.spawnPointsEn--
            }
            parent.health = 100

            if (parent.isControledByAI){

                Cpp.setRandomXY(battlefield, parent, parent.width, parent.height)
              //below comented JavaScript variant
              //JS.setRandomXY(parent)

            }else{

                Cpp.setRandomXY(battlefield, parent, parent.width, parent.height)
              //below comented JavaScript variant
              //JS.setRandomXY(parent)

            }
            parent.spawnReady = true
        }
    }

    Timer{id: mayOpenFireAI
        interval: 300
        running: parent.isControledByAI
                 && tankImg.visible
                 && !reloadInterval.running
                 && !isTimerBonusAct
                 && !battlefield.isGamePaused
        repeat: true
        onTriggered:{
            if(Cpp.mayShootAI(battlefield, parent, maxWidth, maxHeight) ){
                Cpp.makeShoot(parent, JS.createQmlObj("Bullet") )

          /*below comented JavaScript variant
            if(JS.mayShootAI(parent){
                JS.makeShoot(parent)
          */
                bulletShoot.play()
                reloadInterval.start()
            }
        }
    }

    Timer{id: randomChangedirectionAI
        interval: 5000
        running: parent.isControledByAI
                 && tankImg.visible
                 && !isTimerBonusAct
                 && !battlefield.isGamePaused
        repeat: true
        onTriggered:{

            Cpp.setRandomDirectionAI(battlefield, parent, maxWidth, maxHeight)
          //below comented JavaScript variant
          //JS.setRandomDirectionAI(parent)

            interval = JS.getRandomInt(2000, 6000)
        }
    }
}

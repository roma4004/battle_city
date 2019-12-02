import QtQuick 2.7
import "logics.js" as JS

GameObj{
    property string direction: "U"
    property string healthColor: "green";

    property bool isTankBonusAct  : false
                onIsTankBonusActChanged:
                    if(isTankBonusAct){
                        health = health * ( (isTankBonusAct) ? 1.5 : 1)
                    }else{
                        health = health / ( (isTankBonusAct) ? 1.5 : 1)
                    }
    property bool isControledByAI : true
    property bool isTimerBonusAct : false
    property bool isHelmetBonusAct: false
    property bool isNeedExplode   : false
                onIsNeedExplodeChanged: if (isNeedExplode) explosion.play()
    property bool isSpawnReady    : false
    property bool isPressedUp     : false
    property bool isPressedLeft   : false
    property bool isPressedDown   : false
    property bool isPressedRight  : false
    property bool isPressedFire   : false

    property int spawnPoints
    property int explosionDuration: 900
    property int shoots    : 0
    property int tagetHits : 0
    property int tankKils  : 0
    property int bulletHits: 0
    property int brickHits : 0
    property int reloadInterval: 2000 //ms
    property int helmetInterval: 10000 //ms
    property int imgFrame: 1
    property int bulletSpeed: 7
    property int minDamage: 10 * ( (isTankBonusAct) ? 1.5 : 1)
    property int maxDamage: 50 * ( (isTankBonusAct) ? 1.5 : 1)

    property double speed : 3.2

    health: 100
    onHealthChanged:{
        if(health < 1) {
            isObjImgVisible = false
            isNeedExplode = true
            x: -100
        }
        healthColor = (health > 80) ? "green"  :
                      (health > 40) ? "yellow" : "red"
    }
    z: 1
    x: -100
    width:  parent.blockWidth  * 2.5 * ( (isTankBonusAct) ? 1.5 : 1)
    height: parent.blockHeight * 2.5 * ( (isTankBonusAct) ? 1.5 : 1)
    sourceImg: imgPath + imgName + direction + imgFrame + png
    spawnPosMaxY: 0
    onWidthChanged: {
        if(isObjImgVisible){
            if (width === parent.blockWidth * 2.5)
                x += (parent.blockWidth * 2.5 * 1.5) / 2 - width / 2
            if(x + width > maxWidth) x = maxWidth - width;
            if(x         < 0       ) x = 0
        }
    }
    onHeightChanged: {
        if(isObjImgVisible){
            if (height === parent.blockHeight * 2.5)
                y += (parent.blockHeight * 2.5 * 1.5) / 2 - height / 2
            if(y + height > maxHeight) y = maxHeight - height
            if(y          < 0        ) y = 0
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
        color: healthColor;
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
        frameDuration: explosionDuration / frameCount
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
        running: isSpawnReady
        z:5
    }

    Timer{
        interval: 2100
        running: isSpawnReady
        onTriggered:{
            isSpawnReady = false
            isObjImgVisible = true
            if (tag === "P1"
             || tag === "P2") isHelmetBonusAct = true
            if (tag === "P1") battlefield.p1Active = true
            if (tag === "P2") battlefield.p2Active = true
        }
    }

    Timer{
        interval: helmetInterval
        running: isHelmetBonusAct
        onTriggered: isHelmetBonusAct = false
    }

    Timer{
        interval: 15000
        running: isTankBonusAct
        onTriggered: isTankBonusAct = false
    }

    Timer{
        interval: explosionDuration
        running: isNeedExplode
        onTriggered:{
            isNeedExplode = false
            if (tag === "P1" && parent.spawnPoints === 0)
                battlefield.p1Active = false
            if (tag === "P2" && parent.spawnPoints === 0)
                battlefield.p2Active = false
            parent.x = -100
        }
    }

    Timer{
        interval: 100
        running: isObjImgVisible
                 && !isTimerBonusAct
                 && !battlefield.isGamePaused
        repeat: true
        onTriggered:{
            var agr1, arg2, arg3, arg4, arg5
            agr1 = battlefield
            arg2 = parent
            arg3 = parent.direction
            arg4 = maxWidth
            arg5 = maxHeight

            if (parent.isControledByAI){
                switch(parent.tag) {
                case "E1":
                case "E2":
                    if(ThreadE1.isCanMove(agr1, arg2, arg3, arg4, arg5) === false){
                        randomChangedirectionAI.interval = 100
                    }else{
                        ThreadE1.moveObj(agr1, arg2, arg3, arg4, arg5)
                    }
                    break
                case "E3":
                case "E4":
                    if(ThreadE2.isCanMove(agr1, arg2, arg3, arg4, arg5) === false){
                        randomChangedirectionAI.interval = 100
                    }else{
                        ThreadE2.moveObj(agr1, arg2, arg3, arg4, arg5)
                    }
                    break
                case "P1":
                case "P2":
                    if(ThreadP.isCanMove(agr1, arg2, arg3, arg4, arg5) === false){
                        randomChangedirectionAI.interval = 100
                    }else{
                        ThreadP.moveObj(agr1, arg2, arg3, arg4, arg5)
                    }
                    break
                }
            }else{
                var moveSide = "none"
                var needMove = false
                if(parent.isPressedUp   ) {moveSide = "U"; needMove = true}
                if(parent.isPressedRight) {moveSide = "R"; needMove = true}
                if(parent.isPressedDown ) {moveSide = "D"; needMove = true}
                if(parent.isPressedLeft ) {moveSide = "L"; needMove = true}

                if(needMove) ThreadP.moveObj(agr1, arg2, moveSide, arg4, arg5)
            }

            if(parent.isPressedFire && !reloadInterval.running){
                switch(parent.tag) {
                case "E1":
                case "E2":
                    ThreadE1.makeShoot(parent, JS.createQmlObj("Bullet") )
                    break
                case "E3":
                case "E4":
                    ThreadE2.makeShoot(parent, JS.createQmlObj("Bullet") )
                    break
                case "P1":
                case "P2":
                    ThreadP.makeShoot(parent, JS.createQmlObj("Bullet") )
                    break
                }
                bulletShoot.play()
                reloadInterval.start()
            }
        }
    }

    Timer{id: reloadInterval; interval: parent.reloadInterval }

    Timer{
        interval: 3000
        running: !isObjImgVisible
                 && parent.spawnPoints > 0
                 && !battlefield.isGamePaused
        onTriggered:{
            if (tag === "P1" || tag === "P2"){
                parent.spawnPoints--
            }else{
                battlefield.spawnPointsEn--
            }
            parent.health = 100

            var agr1, arg2, arg3, arg4
            agr1 = battlefield
            arg2 = parent
            arg3 = parent.width
            arg4 = parent.height

            if (parent.isControledByAI){
                switch(parent.tag) {
                case "E1":
                case "E2":
                    ThreadE1.setRandomXY(agr1, arg2, arg3, arg4)
                    break
                case "E3":
                case "E4":
                    ThreadE2.setRandomXY(agr1, arg2, arg3, arg4)
                    break
                case "P1":
                case "P2":
                    ThreadP.setRandomXY(agr1, arg2, arg3, arg4)
                    break
                }
            }else{
                ThreadP.setRandomXY(agr1, arg2, arg3, arg4)
            }
            parent.isSpawnReady = true
        }
    }

    Timer{id: mayOpenFireAI
        interval: 300
        running: parent.isControledByAI
                 && isObjImgVisible
                 && !reloadInterval.running
                 && !isTimerBonusAct
                 && !battlefield.isGamePaused
        repeat: true
        onTriggered:{
            var agr1, arg2, arg3, arg4
            agr1 = battlefield
            arg2 = parent
            arg3 = maxWidth
            arg4 = maxHeight

            switch(parent.tag) {
            case "E1":
            case "E2":
                if(ThreadE1.mayShootAI(agr1, arg2, arg3, arg4) ){
                    ThreadE1.makeShoot(arg2, JS.createQmlObj("Bullet") )
                    bulletShoot.play()
                    reloadInterval.start()
                }
                break
            case "E3":
            case "E4":
                if(ThreadE2.mayShootAI(agr1, arg2, arg3, arg4) ){
                    ThreadE2.makeShoot(arg2, JS.createQmlObj("Bullet") )
                    bulletShoot.play()
                    reloadInterval.start()
                }
                break
            case "P1":
            case "P2":
                if(ThreadP.mayShootAI(agr1, arg2, arg3, arg4) ){
                    ThreadP.makeShoot(arg2, JS.createQmlObj("Bullet") )
                    bulletShoot.play()
                    reloadInterval.start()
                }
                break
            }
        }
    }

    Timer{id: randomChangedirectionAI
        interval: 5000
        running: parent.isControledByAI
                 && isObjImgVisible
                 && !isTimerBonusAct
                 && !battlefield.isGamePaused
        repeat: true
        onTriggered:{
            var agr1, arg2, arg3, arg4
            agr1 = battlefield
            arg2 = parent
            arg3 = maxWidth
            arg4 = maxHeight

            switch(parent.tag) {
            case "E1":
            case "E2":
                ThreadE1.setRandomDirectionAI(agr1, arg2, arg3, arg4)
                interval = ThreadE1.getRandomInt(2000, 6000)
                break
            case "E3":
            case "E4":
                ThreadE2.setRandomDirectionAI(agr1, arg2, arg3, arg4)
                interval = ThreadE2.getRandomInt(2000, 6000)
                break            
            case "P1":
            case "P2":
                ThreadE2.setRandomDirectionAI(agr1, arg2, arg3, arg4)
                interval = ThreadE2.getRandomInt(2000, 6000)
                break
            }
        }
    }
}

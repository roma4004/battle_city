import QtQuick 2.7
import QtQuick.Controls 2.0
//import QtQuick.Layouts 1.0
import QtMultimedia 5.5
import "./"
import "logics.js" as JS
import "levels.js" as Lvl

//following order:
//id
//property declarations
//signal declarations
//JavaScript functions
//object properties
//child objects
//states
//transitions

ApplicationWindow {id: mainWindow
    objectName: "MainWindow"
    visible: true
    width: 800; height: 600
    color: "black"
    title: qsTr("Battle City on Qt")

    StartMenu{}
    ScoreBoard{}
    SideBar{id: sideBar }
    Rectangle{id: battlefield
        objectName: "Battlefield"

        property int blockWidth
        property int blockHeight
        property int spawnPointsEn: 20
        property int levelNum: 1

        property bool isInMenu: true
        property bool isGamePaused: false
        property bool isTimerBonusActEn: false
        property bool isTimerBonusActPl: false
        property bool isDestroyedHQ: false
                    onIsDestroyedHQChanged: {
                        p1.spawnPoints = 0
                        p2.spawnPoints = 0
                    }
        property bool p1Active: true
        property bool p2Active: true

        property string gameMode: "demo"
                      onGameModeChanged: {
                          spawnPointsEn = 20
                          switch(gameMode){
                          case "oneP":
                              p1.spawnPoints = 3; p2.spawnPoints = 0
                              p1Active = true;    p2Active = false
                              p1.isControledByAI = false
                              p2.isControledByAI = false
                              break
                          case "twoP":
                              p1.spawnPoints = 3; p2.spawnPoints = 3
                              p1Active = true;    p2Active = true
                              p1.isControledByAI = false
                              p2.isControledByAI = false
                              break
                          case "coop":
                              p1.spawnPoints = 3; p2.spawnPoints = 3
                              p1Active = true;    p2Active = true
                              p1.isControledByAI = false;
                              p2.isControledByAI = true
                              break
                          }
                          p1.health = 0; p1.isSpawnReady = false
                          p2.health = 0; p2.isSpawnReady = false
                          e1.health = 0; e1.isSpawnReady = false
                          e2.health = 0; e2.isSpawnReady = false
                          e3.health = 0; e3.isSpawnReady = false
                          e4.health = 0; e4.isSpawnReady = false

                          p1.shoots     = 0; p2.shoots     = 0;
                          p1.tagetHits  = 0; p2.tagetHits  = 0;
                          p1.tankKils   = 0; p2.tankKils   = 0;
                          p1.bulletHits = 0; p2.bulletHits = 0;
                          p1.brickHits  = 0; p2.brickHits  = 0;

                          listAllObjects.forEach(
                                      function(item, i, listAllObjects) {
                                          item.health = 0
                                          delete listAllObjects[i]
                                      })
                          drawBlock.running = true
                          focus: true
                          battlefield.isDestroyedHQ = false

                      }
        property var listAllObjects: []

        focus: true
        Component.onCompleted: {startGame.play()}
        Keys.onPressed: {
            switch(event.key){
            case Qt.Key_Up      : p1.isPressedUp    = true; break;
            case Qt.Key_Left    : p1.isPressedLeft  = true; break;
            case Qt.Key_Down    : p1.isPressedDown  = true; break;
            case Qt.Key_Right   : p1.isPressedRight = true; break;
            case Qt.Key_Space   : p1.isPressedFire  = true; break;

            case Qt.Key_W       : p2.isPressedUp    = true; break;
            case Qt.Key_A       : p2.isPressedLeft  = true; break;
            case Qt.Key_S       : p2.isPressedDown  = true; break;
            case Qt.Key_D       : p2.isPressedRight = true; break;
            case Qt.Key_Control : p2.isPressedFire  = true; break;
            }
        }
        Keys.onReleased: {
            switch(event.key){
            case Qt.Key_P       : isGamePaused = (isGamePaused)? false
                                                               : true; break;
            case Qt.Key_M       : isInMenu          = true;  break;
            case Qt.Key_Up      : p1.isPressedUp    = false; break;
            case Qt.Key_Left    : p1.isPressedLeft  = false; break;
            case Qt.Key_Down    : p1.isPressedDown  = false; break;
            case Qt.Key_Right   : p1.isPressedRight = false; break;
            case Qt.Key_Space   : p1.isPressedFire  = false; break;

            case Qt.Key_W       : p2.isPressedUp    = false; break;
            case Qt.Key_A       : p2.isPressedLeft  = false; break;
            case Qt.Key_S       : p2.isPressedDown  = false; break;
            case Qt.Key_D       : p2.isPressedRight = false; break;
            case Qt.Key_Control : p2.isPressedFire  = false; break;
            }
        }
        SoundEffect{id: bulletShoot; volume: .1; loops: 1
            source: "qrc:/wav/shoot.wav"
        }
        SoundEffect{id: bonusPickUp; volume: .1; loops: 1
            source: "qrc:/wav/bonusPickUp.wav"
        }
        SoundEffect{id: startGame;   volume: .1; loops: 1
            source: "qrc:/wav/levelStarted.wav"
        }
        SoundEffect{id: explosion;   volume: .1; loops: 1
            source: "qrc:/wav/explosion.wav"
        }
        Timer{interval: 10000; running: battlefield.isTimerBonusActPl
            onTriggered: battlefield.isTimerBonusActPl = false
        }
        Timer{interval: 10000; running: battlefield.isTimerBonusActEn
            onTriggered: battlefield.isTimerBonusActEn = false
        }
        Timer{id: drawBlock; interval: 100; running: true
            onTriggered:{
                var currentLevel = Lvl.level1
                var maxY = mainWindow.height
                var maxX = mainWindow.width - sideBar.width
                parent.blockWidth  = Math.round(maxX / currentLevel[0].length);
                parent.blockHeight = Math.round(maxY / currentLevel.length);
                for(    var i = 0; i < currentLevel.length   ; ++i)
                    for(var j = 0; j < currentLevel[i].length; ++j){
                        switch (currentLevel[i][j]){
                            case 1:
                                JS.makeObsticle(parent.blockWidth,
                                                parent.blockHeight,
                                                j, i, "brick")
                                break
                            case 2:
                                JS.makeObsticle(parent.blockWidth,
                                                parent.blockHeight,
                                                j, i, "brickWhite")
                                break
                            case 3:
                                JS.makeObsticle(parent.blockWidth,
                                                parent.blockHeight,
                                                j, i, "base")
                                break
                        }
                    }
            }
        }
        Timer{interval: 30000; repeat: true; running: !battlefield.isGamePaused
            onTriggered: ThreadP.makeBonus(battlefield, JS.createQmlObj("Bonuses") );                
        }
     // |tag:     |"E{Num}" |"P1"|"P2"|  "obsticle{name}" |
    //  |fraction:|"Enemies"|"Players"|"neitral"|"bonuses"|
        TankEnemy{id: e1; tag: "E1" }
        TankEnemy{id: e2; tag: "E2" }
        TankEnemy{id: e3; tag: "E3" }
        TankEnemy{id: e4; tag: "E4" }

        TankPlayer{id: p1
            tag: "P1"
            imgName: tag
            spawnPosMaxX: mainWindow.width / 2
                          - battlefield.blockWidth * 6 - width
        }

        TankPlayer{id: p2
            tag: "P2"
            imgName: tag
            spawnPosMinX: mainWindow.width / 2
                          + battlefield.blockWidth * 4
            spawnPosMaxX: mainWindow.width - width - sideBar.width
        }

      //test bonus for player and enemy
     // Bonuses{          x: 230; y: 510}
     // Bonuses{          x:   0; y:   0}

        Image{
            anchors.centerIn: noRevivalText
            source: "qrc:/img/pause.png"
            visible: parent.isGamePaused
            scale: 2
        }

        TextBC{id: noRevivalText
            FontLoader{id: bc; source: "qrc:/font/bc7x7.ttf" }
            property bool isPassObsticle: true
            text: "HQ DESTROYED, NO REVIVAL"
            font.pixelSize: 11
            x: (mainWindow.width - sideBar.width) / 2 - width / 2
            y:  mainWindow.height - parent.blockHeight * 7
            visible: battlefield.isDestroyedHQ
            z:5

            Timer{interval: 500; repeat: true;
                running: battlefield.isDestroyedHQ
                onTriggered: parent.visible = (parent.visible) ? false : true
            }
            Timer{interval: 5000
                running: battlefield.isDestroyedHQ
                onTriggered: parent.visible = false
            }
        }
    }
}

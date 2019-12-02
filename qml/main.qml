import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
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

ApplicationWindow { id: mainWindow
    visible: true
    width: 800; height: 600
    color: "black"
    title: qsTr("Battle City on Qt")

    SideBar{id: sideBar }
    Rectangle{id: battlefield
        property int blockWidth
        property int blockHeight
        property int spawnPointsEn: 20
        property int levelNum: 1

        property bool isTimerBonusActEn: false
        property bool isTimerBonusActPl: false

        property bool isGameOver   : false
        property bool isDestroyedHQ: false
        property bool isGamePaused : false

      //property var  allTankListObjects: []

        focus: true
        onIsDestroyedHQChanged: {
            p1.spawnPoints = 0
            p2.spawnPoints = 0
        }

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
                case Qt.Key_P       :
                    isGamePaused = (isGamePaused)? false : true; break;

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

        Text{ id: noRevivalText
            property bool isPassObsticle: true
            color: "white"
            text: "HQ is destroyed, no revival"
            font.pixelSize: 17
            x: (mainWindow.width - sideBar.width) / 2 - noRevivalText.width / 2
            y: mainWindow.height - parent.blockHeight * 7
            visible: false
            z:5
            Timer{id: blinking
                interval: 500
                running: battlefield.isDestroyedHQ
                repeat: true
                onTriggered: {parent.visible = (parent.visible) ? false : true }
            }
            Timer{id: textOff
                interval: 5000
                running: battlefield.isDestroyedHQ
                onTriggered: noRevivalText.destroy()
            }
        }

        SoundEffect {id: bulletShoot; volume: .1; loops: 1; source: "qrc:/wav/shoot.wav"}
        SoundEffect {id: bonusPickUp; volume: .1; loops: 1; source: "qrc:/wav/bonusPickUp.wav"}
        SoundEffect {id: startGame;   volume: .1; loops: 1; source: "qrc:/wav/levelStarted.wav"}
        SoundEffect {id: explosion;   volume: .1; loops: 1; source: "qrc:/wav/explosion.wav"}
       // Timer{interval: 100;   running: true; repeat:true; onTriggered: console.log("ds.getRandFrom()"+Cpp.getRandFrom(parent)) }
        Timer{interval: 10000; running: battlefield.isTimerBonusActPl; onTriggered: battlefield.isTimerBonusActPl = false}
        Timer{interval: 10000; running: battlefield.isTimerBonusActEn; onTriggered: battlefield.isTimerBonusActEn = false}
        Timer{interval: 100;   running: true;
            onTriggered: {//drawBlock
                var currentLevel = Lvl.level1
                var brickType, tile;
                parent.blockWidth  = Math.round( (mainWindow.width  - sideBar.width ) / currentLevel[0].length);
                parent.blockHeight = Math.round(  mainWindow.height                   / currentLevel.length);
                for(    var i = 0; i < currentLevel.length   ; ++i)
                    for(var j = 0; j < currentLevel[i].length; ++j){
                        switch (currentLevel[i][j]){
                            case 1: JS.makeObsticle(parent.blockWidth, parent.blockHeight, j, i, parent, "brick"      ); break
                            case 2: JS.makeObsticle(parent.blockWidth, parent.blockHeight, j, i, parent, "brickWhite" ); break
                            case 3: JS.makeObsticle(parent.blockWidth, parent.blockHeight, j, i, parent, "base"       ); break
                        }
                    }
            }
        }
        Timer{ id: forPlaceBonuses; interval: 30000; running: true; repeat: true;
            onTriggered: JS.makeBonus() //if no arg it place in random empty space
        }        
     // |tag:     |"E{Num}" |"P1"|"P2"|  "obsticle{name}" |
    //  |fraction:|"Enemies"|"Players"|"neitral"|"bonuses"|
        TankPOne{ id: p1; x: 270; y: 560}
        TankPTwo{ id: p2; x: 414; y: 560}
      //test bonus for player and enemy
     // Bonuses{          x: 230; y: 510}
     // Bonuses{          x:   0; y:   0}

        Tank{ id: e1
            property string tag: "E1"
        }
        Tank{ id: e2
            property string tag: "E2"
        }
        Tank{ id: e3
            property string tag: "E3"
        }
        Tank{ id: e4
            property string tag: "E4"
        }
    }
  //Rectangle{id: scoreBoard
  //    Image {id: backgroundImg
  //        anchors.fill: parent
  //        anchors.centerIn: parent
  //        source: ""
  //        visible: false
  //    }
  //    visible: false
  //}

}

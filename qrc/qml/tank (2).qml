import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import "logics.js" as JS

Rectangle{ id: tank1 // player1
        focus: true
        width: 26; height: 26
      //property string tag: "tank1"
      //property string fraction: "Neitral"
      //property int speed : 2
      //property int bulletSpeed : 8
      //property string imgName: "playerTank"
        property string imgPath : "qrc:/img/"
        property string imgDefault : imgPath+imgName+"Up1.png"
        property int objCenterX : x + width/2
        property int objCenterY : y + height/2
        Timer{ id: forContinueMoveingP1; interval: 50; running: p1.visible; repeat: true
            onTriggered:{
                if(battlefield.p1PressedUp   ) {JS.moveObl(p1, "U");}else
                if(battlefield.p1PressedLeft ) {JS.moveObl(p1, "L");}else
                if(battlefield.p1PressedDown ) {JS.moveObl(p1, "D");}else
                if(battlefield.p1PressedRight) {JS.moveObl(p1, "R");}else
                if( (battlefield.p1PressedFire ) && (!shootInterval.running) && (p1.shootCounter < 3) ) {
                    var component = Qt.createComponent("qrc:/qml/Bullet.qml");
                    if (component.status === Component.Ready){
                        var bullet = component.createObject(battlefield);
                        JS.makeShoot(p1, bullet); p1.shootCounter++; console.log("shootCounterP1: " + p1.shootCounter); shootInterval.start();
                    }
                }
            }
        }
        Timer{ id: forContinueMoveingP2; interval: 50; running: p2.visible; repeat: true
            onTriggered:{
                if(battlefield.p2PressedUp   ) {JS.moveObl(p2, "U");}else
                if(battlefield.p2PressedLeft ) {JS.moveObl(p2, "L");}else
                if(battlefield.p2PressedDown ) {JS.moveObl(p2, "D");}else
                if(battlefield.p2PressedRight) {JS.moveObl(p2, "R");}else
                if( (battlefield.p2PressedFire ) && (!shootInterval.running) && (p2.shootCounter < 3) ) {
                    component = Qt.createComponent("qrc:/qml/Bullet.qml");
                    if (component.status === Component.Ready){
                        bullet = component.createObject(battlefield);
                        JS.makeShoot(p2, bullet); p2.shootCounter++; console.log("shootCounterP2: " + p2.shootCounter); shootInterval.start();
                    }
                }
            }
        }
        Timer{ id: shootInterval; interval: 500; running: false; repeat: false
            onTriggered:{ }
        }



/*
        Keys.onPressed: {

            switch( (tag === "P1") && (event.key) ){  //case Qt.Key_Up   : p1.y = p1.y - 2; p1.state = (p1.state === "Up1" ) ? "Up2" : "Up1" ; break;
                case Qt.Key_Up    : Play1.keyPressEvent(3); JS.moveObl(this, "U"); break;//Play1.posCoordY = Play1.posCoordY - 2;
                case Qt.Key_Left  : Play1.keyPressEvent(2); JS.moveObl(this, "L"); break;
                case Qt.Key_Down  : Play1.keyPressEvent(1); JS.moveObl(this, "D"); break;
                case Qt.Key_Right : Play1.keyPressEvent(4); JS.moveObl(this, "R"); break;
                case Qt.Key_Space :
                component = Qt.createComponent("qrc:/qml/Bullet.qml");
                if (component.status === Component.Ready){
                    bullet = component.createObject(battlefield);
                    JS.makeShoot(this, bullet)
                };
             break;
            }
            switch( (tag === "P2") && (event.key) ){   //case Qt.Key_Up   : p1.y = p1.y - 2; p1.state = (p1.state === "Up1" ) ? "Up2" : "Up1" ; break;
                case Qt.Key_W      : Play1.keyPressEvent(3); JS.moveObl(this, "U"); break;//Play1.posCoordY = Play1.posCoordY - 2;
                case Qt.Key_A      : Play1.keyPressEvent(2); JS.moveObl(this, "L"); break;
                case Qt.Key_S      : Play1.keyPressEvent(1); JS.moveObl(this, "D"); break;
                case Qt.Key_D      : Play1.keyPressEvent(4); JS.moveObl(this, "R"); break;
                case Qt.Key_Control:
                    component = Qt.createComponent("qrc:/qml/Bullet.qml");
                    if (component.status === Component.Ready){
                        bullet = component.createObject(battlefield);
                        JS.makeShoot(this, bullet)
                    };
                break;
           }
        }
*/
        Image { id: tankImg;// antialiasing: false
            visible: true
            width:  parent.width
            height: parent.height;
            source: parent.imgDefault
        }//obj.state = (obj.state === direction+"1") ? direction+"2" : direction+"1";

        states:[
            State { name: "U1" ; PropertyChanges { target: tankImg; source: imgPath+imgName+"Up1.png"   } },
            State { name: "U2" ; PropertyChanges { target: tankImg; source: imgPath+imgName+"Up2.png"   } },
            State { name: "L1" ; PropertyChanges { target: tankImg; source: imgPath+imgName+"Left1.png" } },
            State { name: "L2" ; PropertyChanges { target: tankImg; source: imgPath+imgName+"Left2.png" } },
            State { name: "D1" ; PropertyChanges { target: tankImg; source: imgPath+imgName+"Down1.png" } },
            State { name: "D2" ; PropertyChanges { target: tankImg; source: imgPath+imgName+"Down2.png" } },
            State { name: "R1" ; PropertyChanges { target: tankImg; source: imgPath+imgName+"Right1.png"} },
            State { name: "R2" ; PropertyChanges { target: tankImg; source: imgPath+imgName+"Right2.png"} }
        ]
        MouseArea { id: mArea; anchors.fill: parent;
            onClicked: {  }
        }
        Timer{ id: forContinueMoveingAI; interval: 500; running: parent.controledByAI; repeat: true
            onTriggered:{
                if (JS.isCanMove(parent, parent.dirrection) === false) { JS.randomChangeDirrection(parent); forRandomChangeDirrection.restart()}
                    JS.moveObl(parent, parent.dirrection);          //console.log("img: "+enemy1.imgName)}
             }
        }
        Timer{ id: forCheckPlayerAndShootThem; interval: 1000; running: parent.controledByAI; repeat: true
            onTriggered:{
                if(JS.mayShootPayerAI(parent) ){
                    var component = Qt.createComponent("qrc:/qml/Bullet.qml");
                    if (component.status === Component.Ready){
                        var bullet = component.createObject(battlefield);
                        JS.makeShoot(parent, bullet)
                    }
                }
            }
        }
        Timer{ id: forRandomChangeDirrection; interval: 5000; running: parent.controledByAI; repeat: true
            onTriggered:{ JS.randomChangeDirrection(parent); }
        }
        Text{ id: label1 // property string tag: "TankText1";
            anchors.verticalCenter:   parent.bottom;
            anchors.horizontalCenter: parent.horizontalCenter;
            text: parent.tag
        }
        Text{ id: label2 // property string tag: "TankText2"
            anchors.top:              label1.bottom;
            anchors.horizontalCenter: label1.horizontalCenter;
            text: "coordsXY " + parent.x + " " + parent.y
        }
 }

import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import "logics.js" as JS

Rectangle{ // enemy
        property string imgPath : "qrc:/img/"
        property int speed : 2
        property int bulletSpeed : 10
        property int counterShoots : 0
        property int counterTagetHits : 0
        property int counterBulletHits : 0
        property int counterBrickHits : 0
        property int reloadInterval : 5000 //ms
        property int objCenterX : x + width/2
        property int objCenterY : y + height/2     //property string imgName: "playerTank"
        width: 26; height: 26
        color: "transparent"
        Image { id: tankImg; //antialiasing: true
            visible: true
            smooth : true
            width:  parent.width
            height: parent.height;
            source: parent.imgPath+imgName+dirrection+"1.png"
        }//obj.state = (obj.state === direction+"1") ? direction+"2" : direction+"1";

        states:[
            State { name: "U1" ; PropertyChanges { target: tankImg; source: imgPath+imgName+"U1.png"} },
            State { name: "U2" ; PropertyChanges { target: tankImg; source: imgPath+imgName+"U2.png"} },
            State { name: "L1" ; PropertyChanges { target: tankImg; source: imgPath+imgName+"L1.png"} },
            State { name: "L2" ; PropertyChanges { target: tankImg; source: imgPath+imgName+"L2.png"} },
            State { name: "D1" ; PropertyChanges { target: tankImg; source: imgPath+imgName+"D1.png"} },
            State { name: "D2" ; PropertyChanges { target: tankImg; source: imgPath+imgName+"D2.png"} },
            State { name: "R1" ; PropertyChanges { target: tankImg; source: imgPath+imgName+"R1.png"} },
            State { name: "R2" ; PropertyChanges { target: tankImg; source: imgPath+imgName+"R2.png"} }
        ]//        MouseArea { id: mArea; anchors.fill: parent; onClicked: {  } }

        function die(whoKillTag){
            console.log("killed by tag: " + whoKillTag);
            if (whoKillTag === "Bullet_P1"){ p1.counterTagetHits++; console.log("counterP1TagetHits " + p1.counterTagetHits) }
            if (whoKillTag === "Bullet_P2"){ p2.counterTagetHits++; console.log("counterP2TagetHits " + p2.counterTagetHits) }
            if (whoKillTag === "Bullet_E1"){ e1.counterTagetHits++; console.log("counterEnTagetHits " + e1.counterTagetHits) }
            if (whoKillTag === "Bullet_E2"){ e2.counterTagetHits++; console.log("counterEnTagetHits " + e2.counterTagetHits) }
            if (whoKillTag === "Bullet_E3"){ e3.counterTagetHits++; console.log("counterEnTagetHits " + e3.counterTagetHits) }
            if (whoKillTag === "Bullet_E4"){ e4.counterTagetHits++; console.log("counterEnTagetHits " + e4.counterTagetHits) }
            this.visible = false; revivalP1.start()
        }
        Timer { id: revivalP1; interval: 3000
            onTriggered: {
                if(!parent.visible) {
                    parent.visible = true;
                    JS.setRandomXY(parent)
                }
            }
        }
        Timer{ id: forContinueMoveingAI; interval: 80; running: parent.visible; repeat: true
            onTriggered:{
                if (JS.isCanMove(parent, parent.dirrection) === false) {
                    JS.randomChangeDirrection(parent); forRandomChangeDirrection.restart()
                }
                JS.moveObl(parent, parent.dirrection);          //console.log("img: "+enemy1.imgName)}
             }
        }
        Timer{ id: forCheckPlayerAndShootThem; running: parent.visible; repeat: true
            onTriggered:{
                if( (JS.mayShootPayerAI(parent) ) && (!reloadIntervalEnemy.running) ){                    
                    JS.makeShoot(parent);
                    parent.counterShoots++;
                    reloadIntervalEnemy.start();
                }
            }
        }
        Timer{ id: reloadIntervalEnemy; interval: 5000}
        Timer{ id: forRandomChangeDirrection; interval: 5000; running: parent.visible; repeat: true
            onTriggered:{ JS.randomChangeDirrection(parent); }
        }
        Text{ id: label1
            anchors.left:parent.right
            text: parent.tag+" x: "+ parent.x +" y: "+parent.y
        }
        Text{ id: label2
            anchors{
                top: label1.bottom;
                left: parent.right
            }
            text: "Shoots/TankHits/BulletHits/BrickHits: " + parent.counterShoots+"/"+parent.counterTagetHits+"/"+parent.counterBulletHits+"/"+counterBrickHits
        }
 }

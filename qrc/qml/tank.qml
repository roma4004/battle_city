import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import "logics.js" as JS

Rectangle{ id: tank1 // player1
        focus: true
        width: 26; height: 26
        //property string tag: "tank1"
        //property string fraction: "Neitral"
        property string imgPath : "qrc:/img/"
        property string imgDefault : imgPath+imgName+"Up1.png"
        property int objCenterX : x + width/2
        property int objCenterY : y + height/2     //property string imgName: "playerTank"

        Image { id: tankImg; //antialiasing: true
            visible: true
            smooth : true
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
        ]//        MouseArea { id: mArea; anchors.fill: parent; onClicked: {  } }

        function die(whoKillTag){
            console.log("killed by tag: " + whoKillTag);
            if (whoKillTag === "Bullet_P1"){ statistics.counterP1TagetHits++; console.log("counterP1TagetHits " + statistics.counterP1TagetHits) }
            if (whoKillTag === "Bullet_P2"){ statistics.counterP2TagetHits++; console.log("counterP2TagetHits " + statistics.counterP2TagetHits) }
            if (whoKillTag === "Bullet_En"){ statistics.counterEnTagetHits++; console.log("counterEnTagetHits " + statistics.counterEnTagetHits) }
            this.destroy();
        }

        Timer{ id: forContinueMoveingAI; interval: 60; running: parent.controledByAI; repeat: true
            onTriggered:{
                if (JS.isCanMove(parent, parent.dirrection) === false) {
                    JS.randomChangeDirrection(parent); forRandomChangeDirrection.restart()
                }
                JS.moveObl(parent, parent.dirrection);          //console.log("img: "+enemy1.imgName)}
             }
        }
        Timer{ id: forCheckPlayerAndShootThem; running: parent.controledByAI; repeat: true
            onTriggered:{
                if( (JS.mayShootPayerAI(parent) ) && (!reloadIntervalEnemy.running) ){                    
                    JS.makeShoot(parent);
                    statistics.counterEnShoots++;
                    reloadIntervalEnemy.start();
                }
            }
        }
        Timer{ id: reloadIntervalEnemy; interval: 5000}
        Timer{ id: forRandomChangeDirrection; interval: 5000; running: parent.controledByAI; repeat: true
            onTriggered:{ JS.randomChangeDirrection(parent); }
        }
        Text{ id: label1 // property string tag: "TankText1";
            anchors{
                verticalCenter:   parent.bottom;
                horizontalCenter: parent.horizontalCenter;
            }
            text: parent.tag
        }
        Text{ id: label2 // property string tag: "TankText2"
            anchors{
                top:              label1.bottom;
                horizontalCenter: label1.horizontalCenter;
            }
            text: "coordsXY " + parent.x + " " + parent.y
        }
 }

import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import "./"
import "logics.js" as JS

//following order:
//id
//property declarations
//signal declarations
//JavaScript functions
//object properties
//child objects
//states
//transitions

Rectangle{  //player1
    property string tag: "P1"
    property string fraction: "Players"
    property string imgPath : "qrc:/img/"
    property string dirrection: "D"
    property bool pressedUp    : false
    property bool pressedLeft  : false
    property bool pressedDown  : false
    property bool pressedRight : false
    property bool pressedFire  : false
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
    Rectangle{ id: healthBar
        color: "green"; border.color: "black"; width:25; height:5;
        x: 0
        y: -10
        anchors.horizontalCenter: parent.horizontalCenter
    }


    Image { id: tankImg; //antialiasing: true
        visible: true
        smooth : true
        width:  parent.width
        height: parent.height;
        source: parent.imgPath+tag+dirrection+"1.png"
    }//obj.state = (obj.state === direction+"1") ? direction+"2" : direction+"1";   //        MouseArea { id: mArea; anchors.fill: parent; onClicked: {  } }
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
            if(!p1.visible) {
                p1.visible = true;
                JS.setRandomXY(p1)
            }
        }
    }
    Timer{ id: forContinueMoveingP1; interval: 80; running: parent.visible; repeat: true
        onTriggered:{
            if(parent.pressedUp   ) {JS.moveObl(p1, "U");}else
            if(parent.pressedLeft ) {JS.moveObl(p1, "L");}else
            if(parent.pressedDown ) {JS.moveObl(p1, "D");}else
            if(parent.pressedRight) {JS.moveObl(p1, "R");}
            if( (parent.pressedFire) && (!reloadIntervalP1.running) ) {
                JS.makeShoot(p1);
                parent.counterShoots++;
                reloadIntervalP1.start();
                pressedFire = false
            }
        }
    }
    Timer{ id: reloadIntervalP1; interval: 5000}
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
    states:[
        State { name: "U1" ; PropertyChanges { target: tankImg; source: imgPath+tag+"U1.png"} },
        State { name: "U2" ; PropertyChanges { target: tankImg; source: imgPath+tag+"U2.png"} },
        State { name: "L1" ; PropertyChanges { target: tankImg; source: imgPath+tag+"L1.png"} },
        State { name: "L2" ; PropertyChanges { target: tankImg; source: imgPath+tag+"L2.png"} },
        State { name: "D1" ; PropertyChanges { target: tankImg; source: imgPath+tag+"D1.png"} },
        State { name: "D2" ; PropertyChanges { target: tankImg; source: imgPath+tag+"D2.png"} },
        State { name: "R1" ; PropertyChanges { target: tankImg; source: imgPath+tag+"R1.png"} },
        State { name: "R2" ; PropertyChanges { target: tankImg; source: imgPath+tag+"R2.png"} }
    ]//        MouseArea { id: mArea; anchors.fill: parent; onClicked: {  } }
    }


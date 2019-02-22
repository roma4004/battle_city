import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import "./"
import "logics.js" as JS

ApplicationWindow { id: mainWindow
    visible: true
    width: 500; height: 200
    /*Connections { target: DataStorage; onIncreaseOne: txtCount.text = ms }*/
    /*
    Column{ id: firstCol; Text{ id: txtCount; text: DataStorage.message }
        Button{ id: btnUpdate; text: "Just Click Me"
            onClicked: DataStorage.callMeFromQML(); y: 0
            SequentialAnimation { id: yAnimation; running: true; NumberAnimation { target: btnUpdate; property: "y"; from: 1000; to: 0; duration: 5000 } }
        }
    }
    Column{ id: secondCol; anchors.left: firstCol.right
        TextEdit{ id: txtEdit; height: txtCount.height; width: btnEdit.width }
        Button{ id: btnEdit; /*anchors.top: txtCount.bottom*_/ text: "updateProperty"; onClicked: DataStorage.message = txtEdit.text }
    }*/
    //Rectangle{ anchors.left: secondCol.right /*Button{text: "Click me"; onClicked:{ var result = DataStorage.qInvokeExample("I pass whatever i want"); console.log("result got from c++ code into QML " + result) } }*/

    Rectangle{id: battlefield
        property bool p1PressedUp    : false
        property bool p1PressedLeft  : false
        property bool p1PressedDown  : false
        property bool p1PressedRight : false
        property bool p1PressedFire  : false

        property bool p2PressedUp    : false
        property bool p2PressedLeft  : false
        property bool p2PressedDown  : false
        property bool p2PressedRight : false
        property bool p2PressedFire  : false

        Keys.onPressed: {
        switch(event.key){
            case Qt.Key_Up      : p1PressedUp    = true; break;
            case Qt.Key_Left    : p1PressedLeft  = true; break;
            case Qt.Key_Down    : p1PressedDown  = true; break;
            case Qt.Key_Right   : p1PressedRight = true; break;
            case Qt.Key_Space   : p1PressedFire  = true; break;

            case Qt.Key_W       : p2PressedUp    = true; break;
            case Qt.Key_A       : p2PressedLeft  = true; break;
            case Qt.Key_S       : p2PressedDown  = true; break;
            case Qt.Key_D       : p2PressedRight = true; break;
            case Qt.Key_Control : p2PressedFire  = true; break;
          }
        }
        Keys.onReleased: {
        switch(event.key){
            case Qt.Key_Up      : p1PressedUp    = false; break;
            case Qt.Key_Left    : p1PressedLeft  = false; break;
            case Qt.Key_Down    : p1PressedDown  = false; break;
            case Qt.Key_Right   : p1PressedRight = false; break;
            case Qt.Key_Space   : p1PressedFire  = false; break;

            case Qt.Key_W       : p2PressedUp    = false; break;
            case Qt.Key_A       : p2PressedLeft  = false; break;
            case Qt.Key_S       : p2PressedDown  = false; break;
            case Qt.Key_D       : p2PressedRight = false; break;
            case Qt.Key_Control : p2PressedFire  = false; break;
            }
        }
        Tank{ id: p1 //player1
            property string tag: "P1"
            property string fraction: "Players"
            property string imgName : "playerTank"
            property int speed : 2
            property int bulletSpeed : 8
            property bool controledByAI : false
            property int shootCounter : 0
        }
        Tank{ id: p2 //player2
            property string tag: "P2"
            property string fraction: "Players"
            property string imgName : "playerTank"
            property int speed : 2
            property int bulletSpeed : 8
            property bool controledByAI : false
            property int shootCounter : 0
            x: 150


        }
        Tank{ id: enemy1                          //|| passability: ||  passable obstacle ||        impassable obstacle        ||
            property string tag: "enemy1"        // ||         tag: ||     "obsticle{name}_{Num}"    ||"Enemy{Num}"||"P1"||"P2"||
            property string fraction: "Enemies" //  ||    fraction: || "passObsticle"     ||"Neitral"||"Enemies"   ||"Players" ||
            property int speed: 2
            property string dirrection: "U"
            property string imgName: "enemyTank"
            property int bulletSpeed : 8
            property bool controledByAI : true
            property int shootCounter : 0
            x: 50; y: 150
        }
        Tank{ id: enemy2
           property string tag: "enemy2"
           property string fraction: "Enemies"
           property int speed: 2
           property string dirrection: "U"
           property string imgName: "enemyTank"
           property int bulletSpeed : 8
           property bool controledByAI : true
           property int shootCounter : 0
           x: 150; y: 50   // color: "red"; radius: 15; border.color: "black"; border.width: 2

               /*Timer{ interval: 500; running: true; repeat: true
                   onTriggered{
                    //  var rand = Math.random() * (max - min) + min;
                   }
               }*/
        }
           /*Timer{
               id: timerProcessing
               running: isProcessing
               repeat: isProcessing
               interval: 50

               onTriggered:
               {

           }

         }*/
      // }
    }
}
/*
ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex

        Page1 { }
        Page {
            Label {
                text: qsTr("Second page")
                anchors.centerIn: parent
            }
        }
    }
    footer: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex
        TabButton {
            text: qsTr("First")
        }
        TabButton {
            text: qsTr("Second")
        }
    }
}
*/

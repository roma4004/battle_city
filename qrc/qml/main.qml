import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
//import "./"

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
      Rectangle{ id: p1 //player1
            focus: true
            width: 26; height: 26

            Image {
                id: tankP1Img;// antialiasing: false
                visible: true
                width:  parent.width
                height: parent.height;
                source: "qrc:/img/playerTankUp1.png"

                  ///  border.left: 5; border.top: 5
                  //  border.right: 5; border.bottom: 5
                //height: 32; width:  32
                //x: Play1.posCoordX - (p1.width  / 2);
                //y: Play1.posCoordY - (p1.height / 2);
            }
            property int turnSide : 0;
            property int lastTurnSide : 0;
            Keys.onPressed: {
               console.log("coords x: "+p1.x+" y: "+p1.y)
               switch (event.key){
              //case Qt.Key_Up   : p1.y = p1.y - 2; p1.state = (p1.state === "Up1" ) ? "Up2" : "Up1" ; break;
                case Qt.Key_Up   ://Play1.posCoordY = Play1.posCoordY - 2;
                                   Play1.keyPressEvent(3); if(parent.childAt(p1.x + (p1.height / 2)    , p1.y + (p1.width  / 2) - 2) === null) {console.log("collide")} p1.y = p1.y - 2; turnSide = 0;   p1.state = (p1.state === "U1" ) ? "U2" : "U1" ; break;
                case Qt.Key_Left : Play1.keyPressEvent(2); if(parent.childAt(p1.x + (p1.height / 2) - 2, p1.y + (p1.width  / 2)    ) === null) {console.log("collide")} p1.x = p1.x - 2; turnSide = 270; p1.state = (p1.state === "L1" ) ? "L2" : "L1" ; break;
                case Qt.Key_Down : Play1.keyPressEvent(1); if(parent.childAt(p1.x + (p1.height / 2)    , p1.y + (p1.width  / 2) + 2) === null) {console.log("collide")} p1.y = p1.y + 2; turnSide = 180; p1.state = (p1.state === "D1" ) ? "D2" : "D1" ; break;
                case Qt.Key_Right: Play1.keyPressEvent(4); if(parent.childAt(p1.x + (p1.height / 2) + 2, p1.y + (p1.width  / 2)    ) === null) {console.log("collide")} p1.x = p1.x + 2; turnSide = 90;  p1.state = (p1.state === "R1" ) ? "R2" : "R1" ; break;

                case Qt.Key_Space:
                    var component = Qt.createComponent("qrc:/qml/Bullet.qml");
                    if (component.status === Component.Ready) {
                        var childRec = component.createObject(parent);

                        childRec.x  = p1.x + (p1.height / 2) - (childRec.width  / 2);
                        childRec.y  = p1.y + (p1.width  / 2) - (childRec.height / 2);
                        switch (p1.turnSide){
                            case 0   : childRec.y -= p1.height / 2 + childRec.height / 2; break;
                            case 90  : childRec.x += p1.width  / 2 + childRec.width  / 2; break;
                            case 180 : childRec.y += p1.height / 2 + childRec.height / 2; break;
                            case 270 : childRec.x -= p1.width  / 2 + childRec.width  / 2; break;
                        }
                        childRec.dx = 500;
                        childRec.dy = 500;
                        childRec.rotation = p1.turnSide;

                        console.log("width height"+p1.width+p1.height)
                       // console.log(" x: "+childRec.x  +"   y: "+childRec.y)
                       // console.log("dx: "+childRec.dx+"   dy: "+childRec.dy)

                       //childRec.dirrection = rotationy;
                    }; break;

               }
               lastTurnSide = turnSide;
            }
            states:[
                State { name: "U1" ; PropertyChanges { target: tankP1Img; source: "qrc:/img/playerTankUp1.png"   } },
                State { name: "U2" ; PropertyChanges { target: tankP1Img; source: "qrc:/img/playerTankUp2.png"   } },
                State { name: "L1" ; PropertyChanges { target: tankP1Img; source: "qrc:/img/playerTankLeft1.png" } },
                State { name: "L2" ; PropertyChanges { target: tankP1Img; source: "qrc:/img/playerTankLeft2.png" } },
                State { name: "D1" ; PropertyChanges { target: tankP1Img; source: "qrc:/img/playerTankDown1.png" } },
                State { name: "D2" ; PropertyChanges { target: tankP1Img; source: "qrc:/img/playerTankDown2.png" } },
                State { name: "R1" ; PropertyChanges { target: tankP1Img; source: "qrc:/img/playerTankRight1.png"} },
                State { name: "R2" ; PropertyChanges { target: tankP1Img; source: "qrc:/img/playerTankRight2.png"} }
            ]
            MouseArea { id: mArea
                anchors.fill: parent
                onClicked: {
                }
            }
        }
        Rectangle{
        id: enemy

        property string tag: "enemy"
        property string fraction: "neitral" // "Enemies"
        x: 50
        y: 150
        width: 100
        height: 100
        // width: 100; height: 62
        color: "red"; radius: 15; border.color: "black"; border.width: 2
        // x:0; y:0
        }
   // }
    function functionInJavascript(arg){ console.log(arg);
        return "ReturnValueFromJS"
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

import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import "./"
import "logics.js" as JS
import "levels.js" as levels
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
        focus: true
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
        property int tileWidth  : 13
        property int tileHeight : 13
        Keys.onPressed: {
            switch(event.key){
                case Qt.Key_Up      : p1.pressedUp    = true; break;
                case Qt.Key_Left    : p1.pressedLeft  = true; break;
                case Qt.Key_Down    : p1.pressedDown  = true; break;
                case Qt.Key_Right   : p1.pressedRight = true; break;
                case Qt.Key_Space   : p1.pressedFire  = true; break;

                case Qt.Key_W       : p2.pressedUp    = true; break;
                case Qt.Key_A       : p2.pressedLeft  = true; break;
                case Qt.Key_S       : p2.pressedDown  = true; break;
                case Qt.Key_D       : p2.pressedRight = true; break;
                case Qt.Key_Control : p2.pressedFire  = true; break;
            }
        }
        Keys.onReleased: {
            switch(event.key){
                case Qt.Key_Up      : p1.pressedUp    = false; break;
                case Qt.Key_Left    : p1.pressedLeft  = false; break;
                case Qt.Key_Down    : p1.pressedDown  = false; break;
                case Qt.Key_Right   : p1.pressedRight = false; break;
                case Qt.Key_Space   : p1.pressedFire  = false; break;

                case Qt.Key_W       : p2.pressedUp    = false; break;
                case Qt.Key_A       : p2.pressedLeft  = false; break;
                case Qt.Key_S       : p2.pressedDown  = false; break;
                case Qt.Key_D       : p2.pressedRight = false; break;
                case Qt.Key_Control : p2.pressedFire  = false; break;
            }
        }
        Timer{ id: reloadIntervalP1; interval: 5000
            onTriggered: {
                levels.levelOne
                var tile = Qt.createQmlObject('
                    import QtQuick 2.4;
                    import QtLocation 5.0;
                    Brick{
                    width: ' + imageWidth + ';
                    height: ' + imageHeight + ';
                    x: ' + j + ' * ' + imageWidth + ';
                    y: ' + i + ' * ' + imageHeight + ';
                    fillMode: Image.Stretch;
                    source: "qrc:/Images/brick' + brickNumber + '.png";
                    }', rootField);
            }
        }


        Brick {x: 50; y:50}

        TankPOne{ id: p1 }
        TankPTwo{ id: p2 }

        Tank{ id: e1                          //|| passability: ||  passable obstacle ||        impassable obstacle        ||
            property string tag: "E1"        // ||         tag: ||     "obsticle{name}_{Num}"    ||"Enemy{Num}"||"P1"||"P2"||
            property string fraction: "Enemies" //  ||    fraction: || "passObsticle"     ||"Neitral"||"Enemies"   ||"Players" ||
            property string dirrection: "U"
            property string imgName: "En"
            x: 200; y: 50
        }
        Tank{ id: e2
           property string tag: "E2"
           property string fraction: "Enemies"
           property string dirrection: "R"
           property string imgName: "En"
           x: 230; y: 50
        }
        Tank{ id: e3
           property string tag: "E3"
           property string fraction: "Enemies"
           property string dirrection: "L"
           property string imgName: "En"
           x: 200; y: 80
        }
        Tank{ id: e4
            property string tag: "E4"
            property string fraction: "Enemies"
            property string dirrection: "D"
            property string imgName: "En"
            x: 230; y: 80
         }
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

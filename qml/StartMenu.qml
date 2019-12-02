import QtQuick 2.7

Rectangle{id: menu
    FontLoader{id: bc; source: "qrc:/font/bc7x7.ttf" }

    visible: battlefield.isInMenu
    opacity: 0.8
    color: "gray"
    x: (mainWindow.width - sideBar.width) / 2 - width / 2
    y:  mainWindow.height + 100
    z: 2
    width: 600
    height: 400
    focus: visible

    PropertyAnimation {id: menuAnimation
        target: menu
        property: "y"
        to:  mainWindow.height / 2 - height / 2;
        duration: 5000
    }
    Component.onCompleted: menuAnimation.running = true

    property bool isPassObsticle: true
    property int selector: 1
    property int minSelec: 1
    property int maxSelec: 3
    Keys.onReleased: {
        switch(event.key){
        case Qt.Key_Up      : (selector > minSelec)? selector -= 1
                                                   : selector  = maxSelec; break
        case Qt.Key_Down    : (selector < maxSelec)? selector += 1
                                                   : selector  = minSelec; break
        case Qt.Key_M       : battlefield.isInMenu = false
                              battlefield.focus = true; break;
        case Qt.Key_Space   :
            battlefield.gameMode = "none"
            switch(selector){
                case 1: battlefield.gameMode = "oneP"; break
                case 2: battlefield.gameMode = "twoP"; break
                case 3: battlefield.gameMode = "coop"; break
            }
            battlefield.isInMenu = false;
            battlefield.focus = true;
            break
        }
    }
    Column{id: colGlobal
        spacing: 20
        topPadding: 20
        width:  parent.width
        height: parent.height
        Image{
            source: "qrc:/img/titleImg2.png"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Column{
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter
            TextBC{
                text: " I    PLAYER"
                Image{
                    source: "qrc:/img/P1R1.png"
                    visible: selector === 1
                    scale: 2
                    anchors.right: parent.left
                    anchors.rightMargin: 15
                }
            }
            TextBC{
                text: "II   PLAYER"
                Image{
                    source: "qrc:/img/menuSelectorP2.png"
                    visible: selector === 2
                    scale: 2
                    anchors.right: parent.left
                    anchors.rightMargin: 15
                }
            }
            TextBC{
                text: "AI   COOP  "
                Image{
                    source: "qrc:/img/menuSelectorP2.png"
                    visible: selector === 3
                    scale: 2
                    anchors.right: parent.left
                    anchors.rightMargin: 15
                }
            }
        }
        Row{
            spacing: 30
            leftPadding: 20
            topPadding: 20
            Column{
                TextBC{text: "CONTROLS:"; font.pixelSize: 12 }
                Image{
                    source: "qrc:/img/controlMenuPauseSelect.png"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                TextBC{text: "MENU PAUSE SELECT"; font.pixelSize: 12 }
            }
            Column{
                TextBC{ text: "I PLAYER"; font.pixelSize: 12 }
                Image{source: "qrc:/img/controlP1_2.png" }
                Row{
                    spacing: 10
                    TextBC{text: "FIRE/START"; font.pixelSize: 12 }
                    TextBC{text: "MOVE"; font.pixelSize: 12 }
                }
            }
            Column{
                visible: selector == 2
                TextBC{text: "II PLAYER"; font.pixelSize: 12 }
                Image{source: "qrc:/img/controlP2_4.png" }
                Row{
                    spacing: 10
                    TextBC{text: "FIRE"; font.pixelSize: 12 }
                    TextBC{text: "MOVE"; font.pixelSize: 12 }
                }
            }
        }
    }
}

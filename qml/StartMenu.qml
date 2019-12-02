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
    Image {id: titleBattleCityImg
        source: "qrc:/img/titleImg2.png"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 20
    }
    Text{id: oneSelect
        color: "white"
        text: " I    PLAYER"
        font.pixelSize: 17
        font.family: bc.name
        anchors{
            top: titleBattleCityImg.bottom
            topMargin: 20
            horizontalCenter: titleBattleCityImg.horizontalCenter
        }
        Image{id: tankSelectorP1
            visible: selector === 1
            source: "qrc:/img/P1R1.png"
            anchors{
                right: parent.left
                rightMargin: 30
                verticalCenter: parent.verticalCenter
            }
            scale: 2
        }
    }
    Text{id: twoSelect
        color: "white"
        text: "II   PLAYER"
        font.pixelSize: 17
        font.family: bc.name
        anchors{
            top: oneSelect.bottom
            topMargin: 30
            left: oneSelect.left
        }
        Image{id: tankSelectorP2
            visible: selector === 2
            source: "qrc:/img/menuSelectorP2.png"
            anchors{
                right: parent.left
                rightMargin: 30
                verticalCenter: parent.verticalCenter
            }
            scale: 2
        }
    }
    Text{id: coopAISelect
        color: "white"
        text: "AI   COOP"
        font.pixelSize: 17
        font.family: bc.name
        anchors{
            top: twoSelect.bottom
            topMargin: 30
            left: twoSelect.left
        }
        Image{id: coopSelectorP2
            visible: selector === 3
            source: "qrc:/img/menuSelectorP2.png"
            anchors{
                right: parent.left
                rightMargin: 30
                verticalCenter: parent.verticalCenter
            }
            scale: 2
        }
    }

    Text{id: contolManualP1
        color: "white"
        text: "CONTROL I PLAYER"
        font.pixelSize: 12
        font.family: bc.name
        anchors{
            top: coopAISelect.bottom
            topMargin: 30
            left: parent.left
            leftMargin: 15
        }
        Image{id: imgManualP1
            source: "qrc:/img/controlP1_2.png"
            anchors{
                top: contolManualP1.bottom
                left: contolManualP1.left
            }
            Text{id: moveTxtP1
                color: "white"
                text: "MOVE"
                font.pixelSize: 12
                font.family: bc.name
                anchors{
                    top: parent.bottom
                    topMargin: 5
                    right: parent.right
                }
            }
            Text{id: fireTxtP1
                color: "white"
                text: "FIRE/START"
                font.pixelSize: 12
                font.family: bc.name
                anchors{
                    top: parent.bottom
                    topMargin: 5
                    right: moveTxtP1.left
                    rightMargin: 10
                }
            }
        }
    }
    Text{id: contolManualP2
        visible: selector == 2
        color: "white"
        text: "CONTROL II PLAYER"
        font.pixelSize: 12
        font.family: bc.name
        anchors{
            top: coopAISelect.bottom
            topMargin: 30
            left: contolManualP1.right
            leftMargin: 20
        }
        Image{id: imgManualP2
            source: "qrc:/img/controlP2_4.png"
            anchors{
                top: contolManualP2.bottom
                left: contolManualP2.left
            }
            Text{id: moveTxtP2
                color: "white"
                text: "MOVE"
                font.pixelSize: 12
                font.family: bc.name
                anchors{
                    top: parent.bottom
                    topMargin: 5
                    right: parent.right
                    rightMargin: 5
                }
            }
            Text{id: fireTxtP2
                color: "white"
                text: "FIRE"
                font.pixelSize: 12
                font.family: bc.name
                anchors{
                    top: parent.bottom
                    topMargin: 5
                    right: moveTxtP2.left
                    rightMargin: 10
                }
            }
        }
    }
    Text{id: contolManual
        color: "white"
        text: "MAIN CONTROL"
        font.pixelSize: 12
        font.family: bc.name
        anchors{
            top: coopAISelect.bottom
            topMargin: 30
            left: contolManualP2.right
            leftMargin: 20
        }
        Image{id: imgManual
            source: "qrc:/img/controlMenuPauseSelect.png"
            anchors{
                top: contolManual.bottom
                horizontalCenter: parent.horizontalCenter
            }
            Text{id: moveTxt
                color: "white"
                text: "MENU  PAUSE  SELECT"
                font.pixelSize: 12
                font.family: bc.name
                anchors{
                    top: parent.bottom
                    topMargin: 5
                    right: parent.right
                    rightMargin: -50
                }
            }
        }
    }
}

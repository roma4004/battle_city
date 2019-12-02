import QtQuick 2.7
Rectangle{
        property string tag: "sideBar"
        property string fraction: "none"
        color: "gray"
        width: 70
        height: mainWindow.height
        x: mainWindow.width - width
        y: 0
        visible: true
        anchors.right: mainWindow.right

    Image {id: enemyIcons
       visible: true
       smooth : true
       property string blockWidth : battlefield.blockWidth  * 1.5
       property string blockHeight: battlefield.blockHeight * 1.5
       source: "qrc:/img/enLifeBackground.png"
       width:  blockWidth * 2
       height: blockHeight * 10
       anchors.horizontalCenter: parent.horizontalCenter
       //anchors.horizontalCenterOffset: -5
       y: 20
       //row 1
       Image{visible: battlefield.spawnPointsEn > 0 ? true : false
           source: "qrc:/img/enLifeIcon.png"
           width:  parent.blockWidth
           height: parent.blockHeight
           x: 0
           y: 0
       }
       Image{visible: battlefield.spawnPointsEn > 1 ? true : false
           source: "qrc:/img/enLifeIcon.png"
           width:  parent.blockWidth
           height: parent.blockHeight
           x: parent.blockWidth
           y: 0
       }
       //row 2
       Image{visible: battlefield.spawnPointsEn > 2 ? true : false
           source: "qrc:/img/enLifeIcon.png"
           width:  parent.blockWidth
           height: parent.blockHeight
           x: 0
           y: parent.blockHeight
       }
       Image{visible: battlefield.spawnPointsEn > 3 ? true : false
           source: "qrc:/img/enLifeIcon.png"
           width:  parent.blockWidth
           height: parent.blockHeight
           x: parent.blockWidth
           y: parent.blockHeight
       }
       //row 3
       Image{visible: battlefield.spawnPointsEn > 4 ? true : false
           source: "qrc:/img/enLifeIcon.png"
           width:  parent.blockWidth
           height: parent.blockHeight
           x: 0
           y: parent.blockHeight * 2
       }
       Image{visible: battlefield.spawnPointsEn > 5 ? true : false
           source: "qrc:/img/enLifeIcon.png"
           width:  parent.blockWidth
           height: parent.blockHeight
           x: parent.blockWidth
           y: parent.blockHeight * 2
       }
       //row 4
       Image{visible: battlefield.spawnPointsEn > 6 ? true : false
           source: "qrc:/img/enLifeIcon.png"
           width:  parent.blockWidth
           height: parent.blockHeight
           x: 0
           y: parent.blockHeight * 3
       }
       Image{visible: battlefield.spawnPointsEn > 7 ? true : false
           source: "qrc:/img/enLifeIcon.png"
           width:  parent.blockWidth
           height: parent.blockHeight
           x: parent.blockWidth
           y: parent.blockHeight * 3
       }
       //row 5
       Image{visible: battlefield.spawnPointsEn > 8 ? true : false
           source: "qrc:/img/enLifeIcon.png"
           width:  parent.blockWidth
           height: parent.blockHeight
           x: 0
           y: parent.blockHeight * 4
       }
       Image{visible: battlefield.spawnPointsEn > 9 ? true : false
           source: "qrc:/img/enLifeIcon.png"
           width:  parent.blockWidth
           height: parent.blockHeight
           x: parent.blockWidth
           y: parent.blockHeight * 4
       }
       //row 6
       Image{visible: battlefield.spawnPointsEn > 10 ? true : false
           source: "qrc:/img/enLifeIcon.png"
           width:  parent.blockWidth
           height: parent.blockHeight
           x: 0
           y: parent.blockHeight * 5
       }
       Image{visible: battlefield.spawnPointsEn > 11 ? true : false
           source: "qrc:/img/enLifeIcon.png"
           width:  parent.blockWidth
           height: parent.blockHeight
           x: parent.blockWidth
           y: parent.blockHeight * 5
       }
       //row 7
       Image{visible: battlefield.spawnPointsEn > 12 ? true : false
           source: "qrc:/img/enLifeIcon.png"
           width:  parent.blockWidth
           height: parent.blockHeight
           x: 0
           y: parent.blockHeight * 6
       }
       Image{visible: battlefield.spawnPointsEn > 13 ? true : false
           source: "qrc:/img/enLifeIcon.png"
           width:  parent.blockWidth
           height: parent.blockHeight
           x: parent.blockWidth
           y: parent.blockHeight * 6
       }
       //row 8
       Image{visible: battlefield.spawnPointsEn > 14 ? true : false
           source: "qrc:/img/enLifeIcon.png"
           width:  parent.blockWidth
           height: parent.blockHeight
           x: 0
           y: parent.blockHeight * 7
       }
       Image{visible: battlefield.spawnPointsEn > 15 ? true : false
           source: "qrc:/img/enLifeIcon.png"
           width:  parent.blockWidth
           height: parent.blockHeight
           x: parent.blockWidth
           y: parent.blockHeight * 7
       }
       //row 9
       Image{visible: battlefield.spawnPointsEn > 16 ? true : false
           source: "qrc:/img/enLifeIcon.png"
           width:  parent.blockWidth
           height: parent.blockHeight
           x: 0
           y: parent.blockHeight * 8
       }
       Image{visible: battlefield.spawnPointsEn > 17 ? true : false
           source: "qrc:/img/enLifeIcon.png"
           width:  parent.blockWidth
           height: parent.blockHeight
           x: parent.blockWidth
           y: parent.blockHeight * 8
       }
       //row 10
       Image{visible: battlefield.spawnPointsEn > 18 ? true : false
           source: "qrc:/img/enLifeIcon.png"
           width:  parent.blockWidth
           height: parent.blockHeight
           x: 0
           y: parent.blockHeight * 9
       }
       Image{visible: battlefield.spawnPointsEn > 19 ? true : false
           source: "qrc:/img/enLifeIcon.png"
           width:  parent.blockWidth
           height: parent.blockHeight
           x: parent.blockWidth
           y: parent.blockHeight * 9
       }
    }
    Image {id: p1LifeBackground
       visible: true
       smooth : true
       source: "qrc:/img/p1LifeBackground.png"
       width:  battlefield.blockWidth  * 3
       height: battlefield.blockHeight * 3
       anchors.horizontalCenter: parent.horizontalCenter
       y: 250
       Image {
           anchors.right: parent.right
           anchors.rightMargin: 3
           anchors.bottom: parent.bottom
           width:  battlefield.blockWidth  * 1.3
           height: battlefield.blockHeight * 1.3
           source: "qrc:/img/num" + p1.spawnPoints + ".png"
       }
    }
    Image {id: p2LifeBackground
       visible: true //p2.inGame
       smooth : true
       source: "qrc:/img/p2LifeBackground.png"
       width:  battlefield.blockWidth * 3
       height: battlefield.blockHeight * 3
       anchors.horizontalCenter: parent.horizontalCenter
       y: 350
       Image {
           anchors.right: parent.right
           anchors.rightMargin: 3
           anchors.bottom: parent.bottom
           width:  battlefield.blockWidth  * 1.3
           height: battlefield.blockHeight * 1.3
           source: "qrc:/img/num" + p2.spawnPoints + ".png"
       }
    }
    Image{id: levelNum
        visible: true
        smooth : true
        source: "qrc:/img/levelNumFlag.png"
        width:  battlefield.blockWidth  * 3
        height: battlefield.blockHeight * 4
        anchors.horizontalCenter: parent.horizontalCenter
        y: 450
        Image{
            visible: true
            smooth : true
            source: "qrc:/img/levelNumBackground.png"
            width:  battlefield.blockWidth  * 3
            height: battlefield.blockHeight * 1.3
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.bottom
            Image{
                visible: true
                smooth : true
                source: "qrc:/img/num" + Math.floor(battlefield.levelNum / 10 ) + ".png"
                width:  battlefield.blockWidth  * 1.3
                height: battlefield.blockHeight * 1.3
                x: 0
                y: 1
            }
            Image{
                visible: true
                smooth : true
                source: "qrc:/img/num" + battlefield.levelNum + ".png"
                width:  battlefield.blockWidth  * 1.3
                height: battlefield.blockHeight * 1.3
                x:      battlefield.blockWidth  * 1.3 + 3
                y: 1
            }
        }
    }

}

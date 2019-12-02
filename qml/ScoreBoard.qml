import QtQuick 2.7

Rectangle{id: stat
    FontLoader{id: bc; source: "qrc:/font/bc7x7.ttf" }

    visible: (battlefield.isDestroyedHQ || battlefield.isGamePaused) && !battlefield.isInMenu
             || (!battlefield.p1Active && !battlefield.p2Active && !battlefield.isDestroyedHQ)
             || battlefield.spawnPointsEn < 1
             //add win word to score board
    opacity: 0.8
    color: "gray"
    x: (mainWindow.width - sideBar.width) / 2 - width / 2
    y: mainWindow.height / 2 - height / 2
    z: 2
    width: 600
    height: 400

    property bool isP2Active: battlefield.p2Active
    property bool isPassObsticle: true

    Text{id: titleRow
        color: "white"
        text: "STAGE " + battlefield.levelNum
        font.pixelSize: 24
        font.family: bc.name
        y: 10
        anchors.horizontalCenter: parent.horizontalCenter
    }
    Text{id: playerOneTag
        color: "white"
        text: "I   PLAYER"
        font.pixelSize: 17
        font.family: bc.name
        anchors{
            top: titleRow.bottom
            horizontalCenter: parent.horizontalCenter
            horizontalCenterOffset: - (playerOneTag.width + playerOneTag.width) / 2
            topMargin: 20
        }
        Text{id: playerTwoTag
            visible: isP2Active
            color: "white"
            text: "II   PLAYER"
            font.pixelSize: 17
            font.family: bc.name
            anchors{
                left: playerOneTag.right
                verticalCenter: playerOneTag.verticalCenter
                leftMargin: 100
            }
        }
    }
    //row1
    Text{id: p1KilsPoints
        color: "white"
        text: p1.counterTankKils * 100
        font.pixelSize: 17
        font.family: bc.name
        anchors{
            right: kilsPtsL.left
            rightMargin: 10
            verticalCenter: kilsPtsL.verticalCenter
        }
    }
    Text{id: kilsPtsL
        color: "white"
        text: "PTS"
        font.pixelSize: 17
        font.family: bc.name
        anchors{
            right: kilsArrowL.left
            rightMargin: 80
            verticalCenter: kilsArrowL.verticalCenter
        }
    }
    Text{id: p1KilsTankType1
        color: "white"
        text: p1.counterTankKils
        font.pixelSize: 17
        font.family: bc.name
        anchors{
            right: kilsArrowL.left
            rightMargin: 10
            verticalCenter: kilsArrowL.verticalCenter
        }
    }
    Image{id: kilsArrowL
        source: "qrc:/img/arrowLeftW.png"
        anchors{
            right: tankType1Img.left
            rightMargin: 20
            verticalCenter: tankType1Img.verticalCenter
        }
    }
    Image{id: tankType1Img
        source: "qrc:/img/statTankKils.png"
        anchors{
            top: playerOneTag.bottom
            topMargin: 30
            horizontalCenter: stat.horizontalCenter
        }
        scale: 2
    }
    Image{id: kilsArrowR
        visible: isP2Active
        source: "qrc:/img/arrowLeftW.png"
        rotation: 180
        anchors{
            left: tankType1Img.right
            verticalCenter: tankType1Img.verticalCenter
            leftMargin: 20
        }
    }
    Text{id: p2KilsTankType1
        visible: isP2Active
        color: "white"
        text: p2.counterTankKils
        font.pixelSize: 17
        font.family: bc.name
        anchors{
            left: kilsArrowR.right
            verticalCenter: kilsArrowR.verticalCenter
            leftMargin: 10
        }
    }
    Text{id: p2KilsPoints
        visible: isP2Active
        color: "white"
        text: p2.counterTankKils * 100
        font.pixelSize: 17
        font.family: bc.name
        anchors{
            left: kilsArrowR.right
            leftMargin: 80
            verticalCenter: kilsArrowR.verticalCenter
        }
    }
    Text{id: kilsPtsR
        visible: isP2Active
        color: "white"
        text: "PTS"
        font.pixelSize: 17
        font.family: bc.name
        y: 15
        anchors{
            left: p2KilsPoints.right
            verticalCenter: p2KilsPoints.verticalCenter
            leftMargin: 10
        }
    }
    //row 1 end

    //row2
    Text{id: p1ShotsPoints
        color: "white"
        text: p1.counterShoots * 10
        font.pixelSize: 17
        font.family: bc.name
        anchors{
            right: shotsPtsL.left
            rightMargin: 10
            verticalCenter: shotsPtsL.verticalCenter
        }
    }
    Text{id: shotsPtsL
        color: "white"
        text: "PTS"
        font.pixelSize: 17
        font.family: bc.name
        anchors{
            right: shotsArrowL.left
            rightMargin: 80
            verticalCenter: shotsArrowL.verticalCenter
        }
    }
    Text{id: p1Shots
        color: "white"
        text: p1.counterShoots
        font.pixelSize: 17
        font.family: bc.name
        anchors{
            right: shotsArrowL.left
            rightMargin: 10
            verticalCenter: shotsArrowL.verticalCenter
        }
    }
    Image{id: shotsArrowL
        source: "qrc:/img/arrowLeftW.png"
        anchors{
            right: shotsImg.left
            rightMargin: 20
            verticalCenter: shotsImg.verticalCenter
        }
    }
    Image{id: shotsImg
        source: "qrc:/img/statShots.png"
        anchors{
            top: tankType1Img.bottom
            topMargin: 30
            horizontalCenter: stat.horizontalCenter
        }
        scale: 2
    }
    Image{id: shotsArrowR
        visible: isP2Active
        source: "qrc:/img/arrowLeftW.png"
        rotation: 180
        anchors{
            left: shotsImg.right
            verticalCenter: shotsImg.verticalCenter
            leftMargin: 20
        }
    }
    Text{id: p2Shots
        visible: isP2Active
        color: "white"
        text: p2.counterShoots
        font.pixelSize: 17
        font.family: bc.name
        anchors{
            left: shotsArrowR.right
            verticalCenter: shotsArrowR.verticalCenter
            leftMargin: 10
        }
    }
    Text{id: p2ShotsPoints
        visible: isP2Active
        color: "white"
        text: p2.counterShoots * 10
        font.pixelSize: 17
        font.family: bc.name
        anchors{
            left: shotsArrowR.right
            leftMargin: 80
            verticalCenter: shotsArrowR.verticalCenter
        }
    }
    Text{id: shotsPtsR
        visible: isP2Active
        color: "white"
        text: "PTS"
        font.pixelSize: 17
        font.family: bc.name
        anchors{
            left: p2ShotsPoints.right
            verticalCenter: p2ShotsPoints.verticalCenter
            leftMargin: 10
        }
    }
    //row2 end

    //row3
    Text{id: p1BulletHitsPoints
        color: "white"
        text: p1.counterBulletHits * 30
        font.pixelSize: 17
        font.family: bc.name
        anchors{
            right: bulletHitsPtsL.left
            rightMargin: 10
            verticalCenter: bulletHitsPtsL.verticalCenter
        }
    }
    Text{id: bulletHitsPtsL
        color: "white"
        text: "PTS"
        font.pixelSize: 17
        font.family: bc.name
        anchors{
            right: bulletHitsArrowL.left
            rightMargin: 80
            verticalCenter: bulletHitsArrowL.verticalCenter
        }
    }
    Text{id: p1BulletHits
        color: "white"
        text: p1.counterBulletHits
        font.pixelSize: 17
        font.family: bc.name
        anchors{
            right: bulletHitsArrowL.left
            rightMargin: 10
            verticalCenter: bulletHitsArrowL.verticalCenter
        }
    }
    Image{id: bulletHitsArrowL
        source: "qrc:/img/arrowLeftW.png"
        anchors{
            right: bulletHitsImg.left
            rightMargin: 20
            verticalCenter: bulletHitsImg.verticalCenter
        }
    }
    Image{id: bulletHitsImg
        source: "qrc:/img/statBulletHits.png"
        anchors{
            top: shotsImg.bottom
            topMargin: 30
            horizontalCenter: stat.horizontalCenter
        }
        scale: 2
    }
    Image{id: bulletHitsArrowR
        visible: isP2Active
        source: "qrc:/img/arrowLeftW.png"
        rotation: 180
        anchors{
            left: bulletHitsImg.right
            verticalCenter: bulletHitsImg.verticalCenter
            leftMargin: 20
        }
    }
    Text{id: p2BulletHits
        visible: isP2Active
        color: "white"
        text: p2.counterBulletHits
        font.pixelSize: 17
        font.family: bc.name
        anchors{
            left: bulletHitsArrowR.right
            verticalCenter: bulletHitsArrowR.verticalCenter
            leftMargin: 10
        }
    }
    Text{id: p2BulletHitsPoints
        visible: isP2Active
        color: "white"
        text: p2.counterBulletHits * 30
        font.pixelSize: 17
        font.family: bc.name
        anchors{
            left: bulletHitsArrowR.right
            leftMargin: 80
            verticalCenter: bulletHitsArrowR.verticalCenter
        }
    }
    Text{id: bulletHitsPtsR
        visible: isP2Active
        color: "white"
        text: "PTS"
        font.pixelSize: 17
        font.family: bc.name
        anchors{
            left: p2BulletHitsPoints.right
            verticalCenter: p2BulletHitsPoints.verticalCenter
            leftMargin: 10
        }
    }
    //row3 end

    //row4
    Text{id: p1TagetHitsPoints
        color: "white"
        text: p1.counterTagetHits * 50
        font.pixelSize: 17
        font.family: bc.name
        anchors{
            right: tagetHitsPtsL.left
            rightMargin: 10
            verticalCenter: tagetHitsPtsL.verticalCenter
        }
    }
    Text{id: tagetHitsPtsL
        color: "white"
        text: "PTS"
        font.pixelSize: 17
        font.family: bc.name
        anchors{
            right: tagetHitsArrowL.left
            rightMargin: 80
            verticalCenter: tagetHitsArrowL.verticalCenter
        }
    }
    Text{id: p1TagetHits
        color: "white"
        text: p1.counterTagetHits
        font.pixelSize: 17
        font.family: bc.name
        anchors{
            right: tagetHitsArrowL.left
            rightMargin: 10
            verticalCenter: tagetHitsArrowL.verticalCenter
        }
    }
    Image{id: tagetHitsArrowL
        source: "qrc:/img/arrowLeftW.png"
        anchors{
            right: tagetHitsImg.left
            rightMargin: 20
            verticalCenter: tagetHitsImg.verticalCenter
        }
    }
    Image{id: tagetHitsImg
        source: "qrc:/img/statTargetHits3.png"
        anchors{
            top: bulletHitsImg.bottom
            topMargin: 30
            horizontalCenter: stat.horizontalCenter
        }
        scale: 2
    }
    Image{id: tagetHitsArrowR
        visible: isP2Active
        source: "qrc:/img/arrowLeftW.png"
        rotation: 180
        anchors{
            left: tagetHitsImg.right
            verticalCenter: tagetHitsImg.verticalCenter
            leftMargin: 20
        }
    }
    Text{id: p2TagetHits
        visible: isP2Active
        color: "white"
        text: p2.counterTagetHits
        font.pixelSize: 17
        font.family: bc.name
        anchors{
            left: tagetHitsArrowR.right
            verticalCenter: tagetHitsArrowR.verticalCenter
            leftMargin: 10
        }
    }
    Text{id: p2TagetHitsPoints
        visible: isP2Active
        color: "white"
        text: p2.counterTagetHits * 50
        font.pixelSize: 17
        font.family: bc.name
        anchors{
            left: tagetHitsArrowR.right
            leftMargin: 80
            verticalCenter: tagetHitsArrowR.verticalCenter
        }
    }
    Text{id: tagetHitsPtsR
        visible: isP2Active
        color: "white"
        text: "PTS"
        font.pixelSize: 17
        font.family: bc.name
        anchors{
            left: p2TagetHitsPoints.right
            verticalCenter: p2TagetHitsPoints.verticalCenter
            leftMargin: 10
        }
    }
    //row4 end

    //row5
    Text{id: p1BrickHitsPoints
        color: "white"
        text: p1.counterBrickHits * 20
        font.pixelSize: 17
        font.family: bc.name
        anchors{
            right: brickHitsPtsL.left
            rightMargin: 10
            verticalCenter: brickHitsPtsL.verticalCenter
        }
    }
    Text{id: brickHitsPtsL
        color: "white"
        text: "PTS"
        font.pixelSize: 17
        font.family: bc.name
        anchors{
            right: brickHitsArrowL.left
            rightMargin: 80
            verticalCenter: brickHitsArrowL.verticalCenter
        }
    }
    Text{id: p1BrickHits
        color: "white"
        text: p1.counterBrickHits
        font.pixelSize: 17
        font.family: bc.name
        anchors{
            right: brickHitsArrowL.left
            rightMargin: 10
            verticalCenter: brickHitsArrowL.verticalCenter
        }
    }
    Image{id: brickHitsArrowL
        source: "qrc:/img/arrowLeftW.png"
        anchors{
            right: brickHitsImg.left
            rightMargin: 20
            verticalCenter: brickHitsImg.verticalCenter
        }
    }
    Image{id: brickHitsImg
        source: "qrc:/img/statBrickDestoyed.png"
        anchors{
            top: tagetHitsImg.bottom
            topMargin: 30
            horizontalCenter: stat.horizontalCenter
        }
        scale: 2
    }
    Image{id: brickHitsArrowR
        visible: isP2Active
        source: "qrc:/img/arrowLeftW.png"
        rotation: 180
        anchors{
            left: brickHitsImg.right
            verticalCenter: brickHitsImg.verticalCenter
            leftMargin: 20
        }
    }
    Text{id: p2BrickHits
        visible: isP2Active
        color: "white"
        text: p2.counterBrickHits
        font.pixelSize: 17
        font.family: bc.name
        anchors{
            left: brickHitsArrowR.right
            verticalCenter: brickHitsArrowR.verticalCenter
            leftMargin: 10
        }
    }
    Text{id: p2BrickHitsPoints
        visible: isP2Active
        color: "white"
        text: p2.counterBrickHits * 20
        font.pixelSize: 17
        font.family: bc.name
        anchors{
            left: brickHitsArrowR.right
            leftMargin: 80
            verticalCenter: p2BrickHits.verticalCenter            
        }
    }
    Text{id: brickHitsPtsR
        visible: isP2Active
        color: "white"
        text: "PTS"
        font.pixelSize: 17
        font.family: bc.name
        anchors{
            left: p2BrickHitsPoints.right
            leftMargin: 10
            verticalCenter: p2BrickHitsPoints.verticalCenter

        }
    }
    //row5 end

    Image{id: totalLineL
        source: "qrc:/img/scoreLine.png"
        anchors.right: totalScoreTxt.left
        anchors.rightMargin: -70
        anchors.verticalCenter: totalScoreTxt.verticalCenter
        scale: 0.5
    }
    Text{id: totalScoreTxt
        color: "white"
        text: "TOTAL SCORE"
        font.pixelSize: 17
        font.family: bc.name
        anchors.top: p1BrickHitsPoints.bottom
        anchors.topMargin: 20
        anchors.horizontalCenter: stat.horizontalCenter
    }
    Image {id: totalLineR
        source: "qrc:/img/scoreLine.png"
        anchors.left: totalScoreTxt.right
        anchors.leftMargin: -70
        anchors.verticalCenter: totalScoreTxt.verticalCenter
        scale: 0.5
    }

    Text{id: p1TotalScorePoints
        color: "white"
        text: (  p1.counterTankKils   * 100
               + p1.counterShoots     * 10
               + p1.counterBulletHits * 30
               + p1.counterTagetHits  * 50
               + p1.counterBrickHits  * 20 )
        font.pixelSize: 17
        font.family: bc.name
        anchors{
            right: p1TotalScorePTS.left
            rightMargin: 10
            verticalCenter: p1TotalScorePTS.verticalCenter
        }
    }
    Text{id: p1TotalScorePTS
        color: "white"
        text: "PTS"
        font.pixelSize: 17
        font.family: bc.name
        anchors{
            right: brickHitsArrowL.left
            rightMargin: 80
            verticalCenter: p1TotalScore.verticalCenter
        }
    }
    Text{id: p1TotalScore
        color: "white"
        text: (  p1.counterTankKils
               + p1.counterShoots
               + p1.counterBulletHits
               + p1.counterTagetHits
               + p1.counterBrickHits )
        font.pixelSize: 17
        font.family: bc.name
        anchors{
            top: p1BrickHits.bottom
            topMargin: 50
            right: brickHitsArrowL.left
            rightMargin: 10
        }
    }
    Text{id: p2TotalScore
        visible: isP2Active
        color: "white"
        text: (  p2.counterTankKils
               + p2.counterShoots
               + p2.counterBulletHits
               + p2.counterTagetHits
               + p2.counterBrickHits )
        font.pixelSize: 17
        font.family: bc.name
        anchors{
            top: p2BrickHits.bottom
            topMargin: 50
            left: brickHitsArrowR.right
            leftMargin: 10

        }
    }
    Text{id: p2TotalScorePoints
        visible: isP2Active
        color: "white"
        text: (  p2.counterTankKils   * 100
               + p2.counterShoots     * 10
               + p2.counterBulletHits * 30
               + p2.counterTagetHits  * 50
               + p2.counterBrickHits  * 20 )
        font.pixelSize: 17
        font.family: bc.name
        anchors{
            left: brickHitsArrowR.right
            leftMargin: 80
            verticalCenter: p2TotalScore.verticalCenter
        }
    }
    Text{id: p2TotalScorePTS
        visible: isP2Active
        color: "white"
        text: "PTS"
        font.pixelSize: 17
        font.family: bc.name
        anchors{
            left: p2TotalScorePoints.right
            leftMargin: 10
            verticalCenter: p2TotalScorePoints.verticalCenter

        }
    }
}

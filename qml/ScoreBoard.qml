import QtQuick 2.7

Rectangle{id: stat
    FontLoader{id: bc; source: "qrc:/font/bc7x7.ttf" }

    visible: (battlefield.isDestroyedHQ
             || battlefield.isGamePaused) && !battlefield.isInMenu
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
    Column{
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 15
        topPadding: 10
        TextBC{text: "STAGE " + battlefield.levelNum; font.pixelSize: 24;
            anchors.horizontalCenter: parent.horizontalCenter}
        Row{
            spacing: 140
            TextBC{text:  "I   PLAYER" }
            TextBC{text: "II   PLAYER"; visible: isP2Active }
        }
        Row{
            spacing: 15
            Column{
                spacing: 30
                TextBC{id: tankKils  ; text: p1.tankKils   * 100 }
                TextBC{id: shoots    ; text: p1.shoots     * 10  }
                TextBC{id: bulletHits; text: p1.bulletHits * 30  }
                TextBC{id: tagetHits ; text: p1.tagetHits  * 50  }
                TextBC{id: brickHits ; text: p1.brickHits  * 20  }
            }
            Column{
                spacing: 30
                rightPadding: 20
                Repeater{
                    model: 5
                    TextBC{text: "PTS"}
                }
            }
            Column{
                spacing: 30
                rightPadding: 10
                TextBC{text: p1.tankKils   }
                TextBC{text: p1.shoots     }
                TextBC{text: p1.bulletHits }
                TextBC{text: p1.tagetHits  }
                TextBC{text: p1.brickHits  }
            }
            Column{
                spacing: 30
                rightPadding: 10
                Repeater{
                    model: 5
                    Image{source: "qrc:/img/arrowLeftW.png" }
                }
            }
            Column{
                spacing: 30
                Image{source: "qrc:/img/tankKils.png"     ; scale: 2 }
                Image{source: "qrc:/img/shots.png"        ; scale: 2 }
                Image{source: "qrc:/img/bulletHits.png"   ; scale: 2 }
                Image{source: "qrc:/img/targetHits.png"   ; scale: 2 }
                Image{source: "qrc:/img/brickDestoyed.png"; scale: 2 }
            }
            Column{
                spacing: 30
                leftPadding: 10
                Repeater{
                    model: 5
                    Image{
                        source: "qrc:/img/arrowLeftW.png"
                        visible: isP2Active
                        rotation: 180
                    }
                }
            }
            Column{
                spacing: 30
                leftPadding: 10
                TextBC{text: p2.tankKils  ; visible: isP2Active }
                TextBC{text: p2.shoots    ; visible: isP2Active }
                TextBC{text: p2.bulletHits; visible: isP2Active }
                TextBC{text: p2.tagetHits ; visible: isP2Active }
                TextBC{text: p2.brickHits ; visible: isP2Active }
            }
            Column{
                spacing: 30
                leftPadding: 20
                TextBC{text: p2.tankKils   * 100; visible: isP2Active }
                TextBC{text: p2.shoots     * 10 ; visible: isP2Active }
                TextBC{text: p2.bulletHits * 30 ; visible: isP2Active }
                TextBC{text: p2.tagetHits  * 50 ; visible: isP2Active }
                TextBC{text: p2.brickHits  * 20 ; visible: isP2Active }
            }
            Column{
                spacing: 30
                leftPadding: 10
                Repeater {
                    model: 5
                    TextBC{text: "PTS"; visible: isP2Active }
                }
            }
        }
        Row{
            TextBC{text: "________________" }
            TextBC{text: "TOTAL SCORE" }
            TextBC{text: "________________" }
        }
        Row{
            Column{
                rightPadding: 15
                TextBC{text: (  p1.tankKils   * 100
                              + p1.shoots     * 10
                              + p1.bulletHits * 30
                              + p1.tagetHits  * 50
                              + p1.brickHits  * 20 )
                }
            }
            Column{
                rightPadding: 35
                TextBC{text: "PTS" }
            }
            Column{
                rightPadding: 25
                TextBC{text: (  p1.tankKils
                              + p1.shoots
                              + p1.bulletHits
                              + p1.tagetHits
                              + p1.brickHits )
                }
            }
            Column{
                leftPadding: 115
                TextBC{text: (  p2.tankKils
                              + p2.shoots
                              + p2.bulletHits
                              + p2.tagetHits
                              + p2.brickHits )
                    visible: isP2Active
                }
            }
            Column{
                leftPadding: 35
                TextBC{text: (  p2.tankKils   * 100
                              + p2.shoots     * 10
                              + p2.bulletHits * 30
                              + p2.tagetHits  * 50
                              + p2.brickHits  * 20 )
                    visible: isP2Active
                }
            }
            Column{
                leftPadding: 25
                TextBC{text: "PTS"; visible: isP2Active }
            }
        }
    }
}

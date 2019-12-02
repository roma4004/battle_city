import QtQuick 2.7

Rectangle{
    FontLoader{id: bc; source: "qrc:/font/bc7x7.ttf" }
    property string tag: "sideBar"
    property string fraction: "none"
    property string blockWidth : battlefield.blockWidth  * 1.5
    property string blockHeight: battlefield.blockHeight * 1.5
    property int spawnPointsEn : battlefield.spawnPointsEn
    color: "gray"
    width: 70
    height: mainWindow.height
    x:      mainWindow.width - width
    Column{id: colGlobal
        spacing: 80
        anchors{
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 20
        }
        Image {
           source: "qrc:/img/enLifeBackground.png"
           width:  blockWidth * 2
           height: blockHeight * 10
           Row{
               Column{
                   SideBarIcon{visible: spawnPointsEn >  0 ? true : false }//row 1
                   SideBarIcon{visible: spawnPointsEn >  2 ? true : false }//row 2
                   SideBarIcon{visible: spawnPointsEn >  4 ? true : false }//row 3
                   SideBarIcon{visible: spawnPointsEn >  6 ? true : false }//row 4
                   SideBarIcon{visible: spawnPointsEn >  8 ? true : false }//row 5
                   SideBarIcon{visible: spawnPointsEn > 10 ? true : false }//row 6
                   SideBarIcon{visible: spawnPointsEn > 12 ? true : false }//row 7
                   SideBarIcon{visible: spawnPointsEn > 14 ? true : false }//row 8
                   SideBarIcon{visible: spawnPointsEn > 16 ? true : false }//row 9
                   SideBarIcon{visible: spawnPointsEn > 18 ? true : false }//row 10
               }
               Column{
                   SideBarIcon{visible: spawnPointsEn >  1 ? true : false }//row 1
                   SideBarIcon{visible: spawnPointsEn >  3 ? true : false }//row 2
                   SideBarIcon{visible: spawnPointsEn >  5 ? true : false }//row 3
                   SideBarIcon{visible: spawnPointsEn >  7 ? true : false }//row 4
                   SideBarIcon{visible: spawnPointsEn >  9 ? true : false }//row 5
                   SideBarIcon{visible: spawnPointsEn > 11 ? true : false }//row 6
                   SideBarIcon{visible: spawnPointsEn > 13 ? true : false }//row 7
                   SideBarIcon{visible: spawnPointsEn > 15 ? true : false }//row 8
                   SideBarIcon{visible: spawnPointsEn > 17 ? true : false }//row 9
                   SideBarIcon{visible: spawnPointsEn > 19 ? true : false }//row 10
               }
           }
        }
        Column{
            Row{
                SideBarIcon{source: "qrc:/img/p1Icon.png" }
                SideBarIcon{source: "qrc:/img/pIconP.png" }
            }
            Row{
                SideBarIcon{source: "qrc:/img/pLifeIcon.png" }
                SideBarIcon{source: "qrc:/img/p1LifeBackground.png"
                    SideBarIcon{
                        source: "qrc:/img/num" + p1.spawnPoints + ".png"
                    }
                }
            }
        }
        Column{
            Row{
                SideBarIcon{source: "qrc:/img/p2Icon.png" }
                SideBarIcon{source: "qrc:/img/pIconP.png" }
            }
            Row{
                SideBarIcon{source: "qrc:/img/pLifeIcon.png" }
                SideBarIcon{source: "qrc:/img/p2LifeBackground.png"
                    SideBarIcon{
                        source: "qrc:/img/num" + p2.spawnPoints + ".png"
                    }
                }
            }
        }
        Column{
            Image{
               smooth: true
               source: "qrc:/img/levelNumFlag.png"
               width:  blockWidth  * 2
               height: blockHeight * 3
            }
            SideBarIcon{
                source: "qrc:/img/levelNumBackground.png"
                width:  blockWidth * 2
                Row{
                    SideBarIcon{
                        source: "qrc:/img/num"
                                + Math.floor(battlefield.levelNum / 10) + ".png"
                    }
                    SideBarIcon{
                        source: "qrc:/img/num" + battlefield.levelNum + ".png"
                    }
                }
            }
        }
    }
}

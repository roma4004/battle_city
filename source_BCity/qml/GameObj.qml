import QtQuick 2.7
//import QtQuick.Controls 2.0
//import QtQuick.Layouts 1.0

Item {
    property string tag
    property string fraction
    property string imgName
    property string imgPath: "qrc:/img/"
    property string png: ".png"
    property string sourceImg: imgPath + imgName + png

    property int maxWidth : mainWindow.width - sideBar.width
    property int maxHeight: mainWindow.height
    property int spawnPosMinX: 0
    property int spawnPosMaxX: maxWidth - width
    property int spawnPosMinY: 0
    property int spawnPosMaxY: maxHeight - height
    property int health: 1

    property bool isPassObsticle : !isObjImgVisible
    property bool isDestructible :  isObjImgVisible
    property bool isObjImgVisible: false

    Image {
        anchors{fill: parent; centerIn: parent}
        source: parent.sourceImg
        visible: isObjImgVisible
        //onVisibleChanged: if (!visible) explosion.play()
    }
}

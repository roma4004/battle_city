import QtQuick 2.7
//import QtQuick.Controls 2.0
//import QtQuick.Layouts 1.0

Image {
    property string tag: "obsticleWall"
    property string fraction: "neitral"
    property string imgPath: "qrc:/img/"
    property string imgName: "brick"
    property string png: ".png"
    property bool isPassObsticle: false
    property bool isDestructible: true
    property int health: 1

    z: -1
    width:  13
    height: 13    
    source: imgPath + imgName + png
    onHealthChanged: destroy()
}

import QtQuick 2.0

Image {
    visible: true
    smooth : true
    width:  13
    height: 13;
    source: "qrc:/img/brick.png"
    function die(whoKillTag){
        console.log("killed by tag: " + whoKillTag);
        if (whoKillTag === "Bullet_P1"){ p1.counterBrickHits++; console.log("counterP1BrickHits " + p1.counterBrickHits) }
        if (whoKillTag === "Bullet_P2"){ p2.counterBrickHits++; console.log("counterP2BrickHits " + p2.counterBrickHits) }
        if (whoKillTag === "Bullet_E1"){ e1.counterBrickHits++; console.log("counterEnBrickHits " + e1.counterBrickHits) }
        if (whoKillTag === "Bullet_E2"){ e2.counterBrickHits++; console.log("counterEnBrickHits " + e2.counterBrickHits) }
        if (whoKillTag === "Bullet_E3"){ e3.counterBrickHits++; console.log("counterEnBrickHits " + e3.counterBrickHits) }
        if (whoKillTag === "Bullet_E4"){ e4.counterBrickHits++; console.log("counterEnBrickHits " + e4.counterBrickHits) }
        this.destroy();
    }
}

import QtQuick 2.0
import "logics.js" as JS

Rectangle { id: bullet
   // width: 100; height: 62
    //color: "red"; radius: 15; border.color: "black"; border.width: 2
   // x:0; y:0
    property int dx
    property int dy
    property string dirrection
    property var block
    property int speed : 8
    property string tag: "bullet"
    property string fraction: "neitral"
    width: 6; height: 8;

    Image {
        antialiasing: false;
        width:  bullet.width;
        height: bullet.height; id: bulletImg; source: "qrc:/img/bullet.png"
    }
    Component.onCompleted: { }
    //Behavior on x { PropertyAnimation { easing.type: Easing.Linear; duration: 50 } }
    //Behavior on y { PropertyAnimation { easing.type: Easing.Linear; duration: 50 } }

   // NumberAnimation on x {from: x; to: dx; onRunningChanged: { if (!running) { } } }
    //NumberAnimation on y {from: y; to: dy; }
    function die(whoKillTag){
        console.log("bullet destroyed by tag: " + whoKillTag);
        if (whoKillTag === "Bullet_P1"){ statistics.counterP1BulletHits++; console.log("counterP1BulletHits " + statistics.counterP1BulletHits) }
        if (whoKillTag === "Bullet_P2"){ statistics.counterP2BulletHits++; console.log("counterP2BulletHits " + statistics.counterP2BulletHits) }
        if (whoKillTag === "Bullet_En"){ statistics.counterEnBulletHits++; console.log("counterEnBulletHits " + statistics.counterEnBulletHits) }
        this.destroy();
    }
    Timer { id: serverTickForBullet
        interval: 100
        running: true
        repeat:  true
        onTriggered: {

            var coliders = [];
            var colider;

                 if(rotation === 0   ) {y -= parent.speed; parent.dirrection = "U"}
            else if(rotation === 90  ) {x += parent.speed; parent.dirrection = "R"}
            else if(rotation === 180 ) {y += parent.speed; parent.dirrection = "D"}
            else if(rotation === 270 ) {x -= parent.speed; parent.dirrection = "L"}
            colider = null;
            colider = JS.getCollider(parent, "leftTop"     , parent.dirrection );
                 if( (colider) && (coliders.indexOf(colider) === -1 ) ) coliders.push(colider); //console.log("bullet.leftTop.colider.tag:"+colider.tag); if(colider) console.log("1 " + colider + " tag " + colider.tag)
            colider = null;
            colider = JS.getCollider(parent, "centerTop"   , parent.dirrection );
                 if( (colider) && (coliders.indexOf(colider) === -1) ) coliders.push(colider); //console.log("bullet.centerTop.colider.tag: "+colider.tag); if(colider) console.log("2 " + colider + " tag " + colider.tag)
            colider = null;
            colider = JS.getCollider(parent, "rightTop"    , parent.dirrection );
                 if( (colider) && (coliders.indexOf(colider) === -1) ) coliders.push(colider);
                                                      // console.log("bullet.rightTop.colider.tag: "+colider.tag); if(colider) console.log("3 " + colider + " tag " + colider.tag)
/*
            colider = JS.getCollider(parent, "leftCenter"  , parent.dirrection ); if(!coliders.indexOf(colider) ){ coliders.push(colider); colider = null; console.log("4"+colider.tag); }else{if(colider) console.log("4 " + colider + " tag " + colider.tag)}
         // colider = JS.getCollider(parent, "centerCenter", parent.dirrection ); if(!coliders.indexOf(colider) ){ coliders.push(colider); colider = null; console.log("5"+colider.tag); }else{if(colider) console.log("5 " + colider + " tag " + colider.tag)}
            colider = JS.getCollider(parent, "rightCenter" , parent.dirrection ); if(!coliders.indexOf(colider) ){ coliders.push(colider); colider = null; console.log("6"+colider.tag); }else{if(colider) console.log("6 " + colider + " tag " + colider.tag)}

            colider = JS.getCollider(parent, "leftDown"    , parent.dirrection ); if(!coliders.indexOf(colider) ){ coliders.push(colider); colider = null; console.log("7"+colider.tag); }else{if(colider) console.log("7 " + colider + " tag " + colider.tag)}
            colider = JS.getCollider(parent, "centerDown"  , parent.dirrection ); if(!coliders.indexOf(colider) ){ coliders.push(colider); colider = null; console.log("8"+colider.tag); }else{if(colider) console.log("8 " + colider + " tag " + colider.tag)}
            colider = JS.getCollider(parent, "rightDown"   , parent.dirrection ); if(!coliders.indexOf(colider) ){ coliders.push(colider); colider = null; console.log("9"+colider.tag); }else{if(colider) console.log("9 " + colider + " tag " + colider.tag)}
*/

         // var checkCollider1 = battlefield.childAt(x - 1            , y - 1             ); /* "leftTop"     */ //if (checkCollider1) console.log("leftTop      col1: "+ checkCollider1)
         // var checkCollider2 = battlefield.childAt(x + 1 + width    , y - 1             ); /* "rightTop"    */ //if (checkCollider2) console.log("rightTop     col2: "+ checkCollider2)
         // var checkCollider3 = battlefield.childAt(x - 1            , y + 1 + height    ); /* "leftDown"    */ //if (checkCollider3) console.log("leftDown     col3: "+ checkCollider3)
         // var checkCollider4 = battlefield.childAt(x + 1 + width    , y + 1 + height    ); /* "rightDown"   */ //if (checkCollider4) console.log("rightDown    col4: "+ checkCollider4)
         // var checkCollider5 = battlefield.childAt(x     + width / 2, y - 1             ); /* "topCenter"   */ //if (checkCollider5) console.log("topCenter    col5: "+ checkCollider5)
         // var checkCollider6 = battlefield.childAt(x - 1         / 2, y     + height / 2); /* "leftCenter"  */ //if (checkCollider6) console.log("leftCenter   col6: "+ checkCollider6)
         // var checkCollider7 = battlefield.childAt(x     + width / 2, y     + height / 2); /* "centerCenter"*/ //if (checkCollider7) console.log("centerCenter col7: "+ checkCollider7)
         // var checkCollider8 = battlefield.childAt(x + 1 + width    , y     + height / 2); /* "rightCenter" */ //if (checkCollider8) console.log("rightCenter  col8: "+ checkCollider8)
         // var checkCollider9 = battlefield.childAt(x     + width / 2, y + 1 + height    ); /* "downCenter"  */ //if (checkCollider9) console.log("downCenter   col9: "+ checkCollider9)

            if (coliders.length > 0) console.log("arr.lenght:" + coliders.length);
            for(var i in coliders) if(coliders[i] ) console.log("arr.item.tag:" +coliders[i].tag)
            for(var k = 0; k < coliders.length; k++) if( (coliders[k]) && (isEnemy(fraction, coliders[k].fraction) ) ) coliders[k].die(parent.tag);

        /*  if(   (collider1) && (isEnemy(fraction, collider1.fraction) ) ) { collider1.die(parent.tag); console.log("tag" + parent.tag); console.log("isEnemy ("+fraction+", checkCollider1.fraction) "+isEnemy(fraction, checkCollider1.fraction) ) }
            if(   (collider2) && (isEnemy(fraction, collider2.fraction) ) ) { collider2.die(parent.tag); console.log("tag" + parent.tag); console.log("isEnemy ("+fraction+", checkCollider2.fraction) "+isEnemy(fraction, checkCollider2.fraction) ) }
            if(   (collider3) && (isEnemy(fraction, collider3.fraction) ) ) { collider3.die(parent.tag); console.log("tag" + parent.tag); console.log("isEnemy ("+fraction+", checkCollider3.fraction) "+isEnemy(fraction, checkCollider3.fraction) ) }
            if(   (collider4) && (isEnemy(fraction, collider4.fraction) ) ) { collider4.die(parent.tag); console.log("tag" + parent.tag); console.log("isEnemy ("+fraction+", checkCollider4.fraction) "+isEnemy(fraction, checkCollider4.fraction) ) }
         // if(   (collider5) && (isEnemy(fraction, collider5.fraction) ) ) { collider5.die(parent.tag); console.log("tag" + parent.tag); console.log("isEnemy ("+fraction+", checkCollider5.fraction) "+isEnemy(fraction, checkCollider5.fraction) ) }
            if(   (collider6) && (isEnemy(fraction, collider6.fraction) ) ) { collider6.die(parent.tag); console.log("tag" + parent.tag); console.log("isEnemy ("+fraction+", checkCollider6.fraction) "+isEnemy(fraction, checkCollider6.fraction) ) }
            if(   (collider7) && (isEnemy(fraction, collider7.fraction) ) ) { collider7.die(parent.tag); console.log("tag" + parent.tag); console.log("isEnemy ("+fraction+", checkCollider7.fraction) "+isEnemy(fraction, checkCollider7.fraction) ) }
            if(   (collider8) && (isEnemy(fraction, collider8.fraction) ) ) { collider8.die(parent.tag); console.log("tag" + parent.tag); console.log("isEnemy ("+fraction+", checkCollider8.fraction) "+isEnemy(fraction, checkCollider8.fraction) ) }
            if(   (collider9) && (isEnemy(fraction, collider9.fraction) ) ) { collider9.die(parent.tag); console.log("tag" + parent.tag); console.log("isEnemy ("+fraction+", checkCollider9.fraction) "+isEnemy(fraction, checkCollider9.fraction) ) }
        */


           // var QVector<int> vector(10);

            // запуск таймера анимации взрыва, который потом уничтожает объект(анимацию) за собой
            // продумать случай если множественные совпадения происходят, допустим щас счетчик попадания может получить +6 за одно попадание

            if(/* ( (collider1) && (isEnemy(fraction, collider1.fraction) ) )
             || ( (collider2) && (isEnemy(fraction, collider2.fraction) ) )
             || ( (collider3) && (isEnemy(fraction, collider3.fraction) ) )
             || ( (collider4) && (isEnemy(fraction, collider4.fraction) ) )
           //|| ( (collider5) && (isEnemy(fraction, collider5.fraction) ) )
             || ( (collider6) && (isEnemy(fraction, collider6.fraction) ) )
             || ( (collider7) && (isEnemy(fraction, collider7.fraction) ) )
             || ( (collider8) && (isEnemy(fraction, collider8.fraction) ) )
             || ( (collider9) && (isEnemy(fraction, collider9.fraction) ) )

             ||*/(coliders.length > 0)
             || (x > mainWindow.width)
             || (y > mainWindow.height)
             || (x < 0)
             || (y < 0) ) {
                parent.destroy();
            } // console.log("Destroying bullet, which has reached the edge...");
        }
    }
    function isEnemy(yourFraction, otherFraction) {
        if ( yourFraction === otherFraction) return false;
        else                                 return true;
    }
    function startAnimation() { startAnimationTimer.restart() }

    Timer { id: startAnimationTimer
        running: false
        repeat:  false
        interval: 50
        onTriggered: visible = true
    }

}

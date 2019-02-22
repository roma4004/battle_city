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
        height: bullet.height; id: bulletImg; source: "qrc:/img/bullet.png" }
    Component.onCompleted: {

 //       if(rotation === 0  ) dy = -100;
 //  else if(rotation === 90 ) dx =  100;
  // else if(rotation === 180) dy =  100;
 //  else if(rotation === 270) dx = -100;
        //startAnimation()
                                                                 //console.log("complit bullet...")
                                                                 //console.log(" x: "+x  +"   y: "+y)
                                                                 //console.log("dx: "+dx+"   dy: "+dy)
    }

    //Behavior on x { PropertyAnimation { easing.type: Easing.Linear; duration: 50 } }
    //Behavior on y { PropertyAnimation { easing.type: Easing.Linear; duration: 50 } }

   // NumberAnimation on x {from: x; to: dx; onRunningChanged: { if (!running) { } } }
    //NumberAnimation on y {from: y; to: dy; }
    Timer { id: serverTickForBullet
        interval: 250
        running: true
        repeat:  true
        onTriggered: {//console.log("rotation: "+rotation)
                 if(rotation === 0   ) {y -= speed }
            else if(rotation === 90  ) {x += speed }
            else if(rotation === 180 ) {y += speed }
            else if(rotation === 270 ) {x -= speed }

           // var objX = bullet.x;
           // var objY = bullet.y;

            var checkCollider1 = battlefield.childAt(x - 1            , y - 1                 ); // "leftTop"
            var checkCollider2 = battlefield.childAt(x + 1 + width    , y - 1                 ); // "rightTop"
            var checkCollider3 = battlefield.childAt(x - 1            , y + 1 + height        ); // "leftDown"
            var checkCollider4 = battlefield.childAt(x + 1 + width    , y + 1 + height        ); // "rightDown"
            var checkCollider5 = battlefield.childAt(x     + width / 2, y - 1                 ); // "topCenter"
            var checkCollider6 = battlefield.childAt(x - 1         / 2, y     + height / 2    ); // "leftCenter"
            var checkCollider7 = battlefield.childAt(x     + width / 2, y     + height / 2    ); // "centerCenter"
            var checkCollider8 = battlefield.childAt(x + 1 + width    , y     + height / 2    ); // "rightCenter"
            var checkCollider9 = battlefield.childAt(x     + width / 2, y + 1 + height        ); // "downCenter"

            //if (checkCollider1) console.log("leftTop      col1: "+ checkCollider1)
            //if (checkCollider2) console.log("rightTop     col2: "+ checkCollider2)
            //if (checkCollider3) console.log("leftDown     col3: "+ checkCollider3)
            //if (checkCollider4) console.log("rightDown    col4: "+ checkCollider4)
            //if (checkCollider5) console.log("topCenter    col5: "+ checkCollider5)
            //if (checkCollider6) console.log("leftCenter   col6: "+ checkCollider6)
            //if (checkCollider7) console.log("centerCenter col7: "+ checkCollider7)
            //if (checkCollider8) console.log("rightCenter  col8: "+ checkCollider8)
            //if (checkCollider9) console.log("downCenter   col9: "+ checkCollider9)


                 //console.log(parent.parent.childAt(x, y) );  //console.log("after move bullet...")        //console.log(" x: "+x  +"   y: "+ y)        // console.log("dx: "+dx+"   dy: "+dy)   // console.log("parent.width" + mainWindow.width+"|"+mainWindow.height)
            if( (checkCollider1) && (isEnemy(fraction, checkCollider1.fraction) ) ) { checkCollider1.visible = false; console.log("isEnemy ("+fraction+", checkCollider1.fraction) "+isEnemy(fraction, checkCollider1.fraction) ) }
            if( (checkCollider2) && (isEnemy(fraction, checkCollider2.fraction) ) ) { checkCollider2.visible = false; console.log("isEnemy ("+fraction+", checkCollider2.fraction) "+isEnemy(fraction, checkCollider2.fraction) ) }
            if( (checkCollider3) && (isEnemy(fraction, checkCollider3.fraction) ) ) { checkCollider3.visible = false; console.log("isEnemy ("+fraction+", checkCollider3.fraction) "+isEnemy(fraction, checkCollider3.fraction) ) }
            if( (checkCollider4) && (isEnemy(fraction, checkCollider4.fraction) ) ) { checkCollider4.visible = false; console.log("isEnemy ("+fraction+", checkCollider4.fraction) "+isEnemy(fraction, checkCollider4.fraction) ) }
            if( (checkCollider5) && (isEnemy(fraction, checkCollider5.fraction) ) ) { checkCollider5.visible = false; console.log("isEnemy ("+fraction+", checkCollider5.fraction) "+isEnemy(fraction, checkCollider5.fraction) ) }
            if( (checkCollider6) && (isEnemy(fraction, checkCollider6.fraction) ) ) { checkCollider6.visible = false; console.log("isEnemy ("+fraction+", checkCollider6.fraction) "+isEnemy(fraction, checkCollider6.fraction) ) }
            if( (checkCollider7) && (isEnemy(fraction, checkCollider7.fraction) ) ) { checkCollider7.visible = false; console.log("isEnemy ("+fraction+", checkCollider7.fraction) "+isEnemy(fraction, checkCollider7.fraction) ) }
            if( (checkCollider8) && (isEnemy(fraction, checkCollider8.fraction) ) ) { checkCollider8.visible = false; console.log("isEnemy ("+fraction+", checkCollider8.fraction) "+isEnemy(fraction, checkCollider8.fraction) ) }
            if( (checkCollider9) && (isEnemy(fraction, checkCollider9.fraction) ) ) { checkCollider9.visible = false; console.log("isEnemy ("+fraction+", checkCollider9.fraction) "+isEnemy(fraction, checkCollider9.fraction) ) }
            // запуск таймера анимации взрыва, который потом уничтожает объект(анимацию) за собой

            if( ( (checkCollider1) && (isEnemy(fraction, checkCollider1.fraction) ) )
             || ( (checkCollider2) && (isEnemy(fraction, checkCollider2.fraction) ) )
             || ( (checkCollider3) && (isEnemy(fraction, checkCollider3.fraction) ) )
             || ( (checkCollider4) && (isEnemy(fraction, checkCollider4.fraction) ) )
             || ( (checkCollider5) && (isEnemy(fraction, checkCollider5.fraction) ) )
             || ( (checkCollider6) && (isEnemy(fraction, checkCollider6.fraction) ) )
             || ( (checkCollider7) && (isEnemy(fraction, checkCollider7.fraction) ) )
             || ( (checkCollider8) && (isEnemy(fraction, checkCollider8.fraction) ) )
             || ( (checkCollider9) && (isEnemy(fraction, checkCollider9.fraction) ) )
             || (x > mainWindow.width)
             || (y > mainWindow.height)
             || (x < 0)
             || (y < 0) ) {
                if(parent.tag === "Bullet_P1") {p1.shootCounter--; console.log("p1.shootCounter " + p1.shootCounter) }
                if(parent.tag === "Bullet_P2") {p2.shootCounter--; console.log("p2.shootCounter " + p2.shootCounter) }
                if(parent.tag === "Bullet_E1") {e1.shootCounter--; console.log("e2.shootCounter " + e2.shootCounter) }
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

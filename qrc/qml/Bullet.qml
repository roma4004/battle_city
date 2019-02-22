import QtQuick 2.0

Rectangle { id: bullet
   // width: 100; height: 62
    //color: "red"; radius: 15; border.color: "black"; border.width: 2
   // x:0; y:0
    property int dx
    property int dy
    property int dirrection
    property var block
    property string tag: bullet
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
        console.log("complit bullet...")
        console.log(" x: "+x  +"   y: "+y)
        console.log("dx: "+dx+"   dy: "+dy)
    }

    //Behavior on x { PropertyAnimation { easing.type: Easing.Linear; duration: 50 } }
    //Behavior on y { PropertyAnimation { easing.type: Easing.Linear; duration: 50 } }

   // NumberAnimation on x {from: x; to: dx; onRunningChanged: { if (!running) { } } }
    //NumberAnimation on y {from: y; to: dy; }
    Timer { id: serverTickForBullet
        interval: 50
        running: true
        repeat:  true
        onTriggered: {

            var speed = 8;
            var block  = null;
            var block2 = null;            //console.log("rotation: "+rotation)
                 if(rotation === 0   ) {y -= speed;   console.log(parent.parent.childAt(x, y) );}
            else if(rotation === 90  ) {x += speed;   console.log(parent.parent.childAt(x, y) );}
            else if(rotation === 180 ) {y += speed;   console.log(parent.parent.childAt(x, y) );}
            else if(rotation === 270 ) {x -= speed;   console.log(parent.parent.childAt(x, y) );}
                  //console.log("after move bullet...")        //console.log(" x: "+x  +"   y: "+ y)        // console.log("dx: "+dx+"   dy: "+dy)   // console.log("parent.width" + mainWindow.width+"|"+mainWindow.height)
            block = parent.parent.childAt(x, y);
            if (block){              // console.log("block.x " + block.x); console.log("block.tag " + block.tag);
                if (isEnemy(fraction, block.fraction) ){
                    block.destroy(); bullet.destroy(); return;  //     console.log("Destroying enemy, bullet..."); // запуск таймера анимации взрыва, который потом уничтожает объект(анимацию) за собой
                }
            }
            if(  (x > mainWindow.width)
               ||(y > mainWindow.height)
               ||(x < 0)
               ||(y < 0) ) {                                                               console.log("Destroying bullet which has reached the edge...");
                bullet.destroy();
            }

           // root.now = new Date()
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

#include "PlayerTank.h"

PlayerTank::PlayerTank(): posCoordY (250), posCoordX(25), height (16), width(16){

}

void PlayerTank::setFramePath(QString frameName){
    framePath = frameName;
    emit framePathChanged();
}

void PlayerTank::setPosCoordX(int coodrX){
    posCoordX = coodrX;
}
void PlayerTank::setPosCoordY(int coodrY){
    posCoordY = coodrY;
}
//void PlayerTank::callMeQML()
//{
//    emit posCoordsChanged();
//}

void PlayerTank::nextFrame(){
    if   (actualFrame == 2) {
          actualFrame = 1;
    }else actualFrame++;

}
void PlayerTank::keyPressEvent(int keyCode)
{
    //const float step = 0.1f;
    switch (keyCode)    {
        case 1 : posCoordY += 2; break;
        case 2 : posCoordX -= 2; break;
        case 3 : posCoordY -= 2; break;
        case 4 : posCoordX += 2; break;
    }
  // update();
}

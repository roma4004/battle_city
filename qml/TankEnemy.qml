import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import "logics.js" as JS

Tank{
    property string fraction: "Enemies"
    property string imgName: "En"

    property bool isControledByAI: true
    property bool isTimerBonusAct: battlefield.isTimerBonusActEn

    property int spawnPosMinX: 0
    property int spawnPosMaxX: mainWindow.width - width  - sideBar.width
    property int spawnPosMinY: 0
    property int spawnPosMaxY: 0
    property int spawnPoints: battlefield.spawnPointsEn
}

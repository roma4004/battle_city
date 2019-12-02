import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import "logics.js" as JS

Tank{
    property string fraction: "Players"

    property bool isControledByAI : true
    property bool isTimerBonusAct : battlefield.isTimerBonusActPl

    property int spawnPosMinY: mainWindow.height - height
    property int spawnPosMaxY: mainWindow.height - height
    property int spawnPoints: 3
}

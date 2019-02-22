import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Item {

    RowLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 20
        anchors.top: parent.top
    }

    ColumnLayout {
        x: 0
        y: 0
        width: 640
        height: 480

        Rectangle {
            id: rectangle1
            color: "#a8a8a8"
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.preferredHeight: 200
            Layout.preferredWidth: 460
        }

        Rectangle {
            id: rectangle2
            color: "#a8a8a8"
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.preferredHeight: 200
            Layout.preferredWidth: 460
        }
    }


}

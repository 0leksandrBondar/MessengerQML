import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

import "ClientPage"

ApplicationWindow
{
    id: mainWindow
    visible: true
    width: 1300
    height: 900
    minimumWidth: 850
    minimumHeight: 700
    title: qsTr("Messenger")

    Material.theme: Material.Dark

    ClientPage
    {
        anchors.fill: parent
    }
}
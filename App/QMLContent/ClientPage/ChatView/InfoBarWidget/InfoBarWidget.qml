import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Rectangle
{
    radius: 20
    border.width: 2
    anchors.margins: 5
    border.color: "#282e33"
    color: Material.background

    function setRecieverName(name)
    {
        clientName.text = name
    }

    Label
    {
        id: clientName
        text: "Sample client name"
        font.pointSize: 16
        color: "#00ff95"
        anchors.leftMargin: 10
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
    }
}
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Popup
{
    clip: true
    modal: true

    background: Rectangle
    {
        radius: 20
        border.width: 2
        border.color: "#282e33"
        color: Material.background
    }
    Overlay.modal: Rectangle
    {
        color: Material.background
        opacity: 0.5
    }

    TextField
    {
        id: searchClientField
        width: parent.width
        height: 40
        anchors.centerIn: parent
        placeholderText: (!activeFocus && text.length === 0) ? qsTr("Search") : ""
        font.pointSize: 10

        background: Rectangle {
            color: Material.background
            radius: 20
            border.color: "#282e33"
            border.width: 2
        }
    }

    Button
    {
        id: findButton
        text: "Find"
        width: 100
        height: 50
        anchors.topMargin: 50
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: searchClientField.bottom
        background: Rectangle
        {
            color: findButton.hovered ? "#434543" :  "#282e33"
            radius: 20
        }
        onClicked:
        {
            if(searchClientField.text !== "")
                foundNewClient(searchClientField.text)
        }
    }
}
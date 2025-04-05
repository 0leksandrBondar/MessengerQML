import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Rectangle
{
    color: Material.background

    signal actionButtonClicked();
    signal searchLineChanged(string value)

    Button
    {
        id: actionsButton
        width: 100
        height: 50
        text: "actions"
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        background: Rectangle
        {
            color: actionsButton.hovered ? "#434543" :  "#282e33"
            radius: 15
        }
        onClicked: actionButtonClicked()
    }

    TextField
    {
        id: inputField
        width: parent.width - actionsButton.width
        height: 40
        anchors.left: actionsButton.right
        anchors.verticalCenter: parent.verticalCenter
        placeholderText: (!activeFocus && text.length === 0) ? qsTr("Search") : ""
        font.pointSize: 10
        onTextChanged: searchLineChanged(text)

        background: Rectangle {
            color: Material.background
            radius: 20
            border.color: "#282e33"
            border.width: 2
        }
    }
}
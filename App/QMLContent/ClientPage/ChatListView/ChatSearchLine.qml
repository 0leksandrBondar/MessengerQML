import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Rectangle
{
    color: Material.background

    signal searchLineChanged(string value)

    TextField
    {
        id: inputField
        width: parent.width / 1.1
        height: 40
        anchors.centerIn: parent
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
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Popup
{
    id: popup
    clip: true
    modal: true
    width: 500
    height: 400
    parent: Overlay.overlay
    x: Math.round((parent.width - width) / 2)
    y: Math.round((parent.height - height) / 2)
    Overlay.modal: Rectangle
    {
        color: Material.background
        opacity: 0.5
    }

    property string filename: ""

    function validateFilePath(path)
    {
        if (path.startsWith("file:///"))
        {
            return path.replace("file:///", "");
        }
        return path;
    }

    Rectangle
    {
        id: title
        height: 75
        width: parent.width
        anchors.top: parent.top
        color: Material.background
        Label
        {
            id: windowTitle
            text: "Send as a file"
            anchors.leftMargin: 10
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    Rectangle
    {
        id: content
        height: 75
        width: parent.width
        anchors.topMargin: 5
        anchors.top: title.bottom
        color: Material.background
        Label
        {
            id: fileName
            text: validateFilePath(filename)
            anchors.leftMargin: 10
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    Button
    {
        id: sendButtonn
        text: "send"
        width: 100
        height: 30
        anchors.top: content.bottom
        onClicked: client.sendFile(infoBarWidget.recipientName, fileName.text)
    }
}

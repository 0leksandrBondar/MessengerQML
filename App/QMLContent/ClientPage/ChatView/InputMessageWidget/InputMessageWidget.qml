import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Basic
import QtQuick.Controls.Material 2.15

Rectangle
{
    id: inputMessageWidget
    color: Material.background
    radius: 20
    border.color: "#282e33"
    border.width: 2

    signal sendButtonClicked(string text)
    function sendMessage()
    {
        let message = textEditor.text.trim();
        if (message !== "")
        {
            sendButtonClicked(message);
            textEditor.clear();
        }
    }

    TextEditor
    {
        id: textEditor
        height: parent.height;
        width: parent.width - (sendButton.width + fileButton.width);
        anchors.right: fileButton.left

        Keys.onPressed: function (event)
        {
            if (event.key === Qt.Key_Return && event.modifiers && Qt.ControlModifier)
            {
                sendMessage()
            }
        }
    }

    Button
    {
        id: sendButton

        width: 100
        height: 50
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        text: "send"
        background: Rectangle
        {
            color: sendButton.hovered ? "#434543" :  "#282e33"
        }

        onClicked: sendMessage()
    }

    Button
    {
        id: fileButton
        width: 100
        height: 50
        anchors.right: sendButton.left
        anchors.bottom: parent.bottom
        text: "File"
        background: Rectangle
        {
            color: fileButton.hovered ? "#434543" :  "#282e33"
        }
    }
}
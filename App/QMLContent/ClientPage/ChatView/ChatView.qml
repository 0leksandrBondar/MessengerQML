import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

import "./InputMessageWidget"
import "./MessagesViewWidget"

Rectangle
{
    color:  Material.background

    MessagesViewWidget
    {
        id: messagesViewWidget
        color: Material.background
        width: parent.width
        height: parent.height - inputMessageWidget.height
        anchors.bottom: parent.bottom
    }

    InputMessageWidget
    {
        id: inputMessageWidget
        width: parent.width
        height: 50
        anchors.bottom: parent.bottom

        onSendButtonClicked: function(text)
        {
            messagesViewWidget.addMessage(text)
        }
    }
}
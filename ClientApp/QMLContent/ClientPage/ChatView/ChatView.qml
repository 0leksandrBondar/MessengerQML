import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

import "./InfoBarWidget"
import "./InputMessageWidget"
import "./MessagesViewWidget"

Rectangle
{
    color:  Material.background

    function updateRecipientName(name)
    {
        infoBarWidget.setRecieverName(name)
    }

    InfoBarWidget
    {
        id: infoBarWidget
        height: 50
        width: parent.width
        anchors.top: parent.top
    }

    MessagesViewWidget
    {
        id: messagesViewWidget
        color: Material.background
        width: parent.width
        height: parent.height - (inputMessageWidget.height + infoBarWidget.width)
        anchors.top: infoBarWidget.bottom
    }

    InputMessageWidget
    {
        id: inputMessageWidget
        width: parent.width
        height: 50
        anchors.bottom: parent.bottom

        onSendButtonClicked: function(text)
        {
            messagesViewWidget.addMessage(client.getClientName(), text)
            client.sendText(infoBarWidget.recipientName, text)
        }
    }
}
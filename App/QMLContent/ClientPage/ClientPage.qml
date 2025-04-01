import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

import "./ChatView"
import "./ChatListView"

Rectangle
{
    ChatListView
    {
        id: chatListView
        width: parent.width / 3
        height: parent.height
        anchors.left: parent.left
        onClickOnChatBlock: function(chatName)
        {
            chatView.updateRecipientName(chatName)
        }
    }

    ChatView
    {
        id: chatView
        height: parent.height
        width: parent.width - chatListView.width
        anchors.left: chatListView.right
    }
}
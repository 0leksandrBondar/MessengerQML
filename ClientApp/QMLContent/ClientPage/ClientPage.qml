import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

import "./ChatView"
import "./ChatListView"
import "./ActionsWidget"

Rectangle
{
    property bool isChatSelected: false
    color:  Material.background
    focus: true

    Keys.onReleased: (event) => {
        if (event.key === Qt.Key_Escape) {
            isChatSelected = false
            event.accepted = true
        }
    }

    ChatListView
    {
        id: chatListView
        width: parent.width / 3
        height: parent.height
        anchors.left: parent.left
        onClickOnChatBlock: function(chatName)
        {
            isChatSelected = true
            chatView.updateRecipientName(chatName)
        }
    }

    ChatView
    {
        visible: isChatSelected
        id: chatView
        height: parent.height
        width: parent.width - chatListView.width
        anchors.left: chatListView.right
    }

    ActionsWidget
    {
        id: actionWidget
        width:  parent.width / 4
        height: parent.height
        window: parent
        onFoundNewClient: function(clientName)
        {
            chatListView.addNewChat(clientName)
        }
    }
}

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Rectangle
{
    id: chatListViewBlock

    signal clickOnChatBlock(string chatName);

    property var filter : ""

    function addNewChat(chatName)
    {
        chatBlockList.append({"text": chatName});
    }

    function filterChatList()
    {
        filteredBlockList.clear()

        for (var i = 0; i < chatBlockList.count; ++i)
        {
            var chatName = chatBlockList.get(i).text;
            if (chatName.toLowerCase().includes(filter.toLowerCase()))
            {
                filteredBlockList.append({"text": chatName});
            }
        }
    }

    ChatSearchLine
    {
        id: chatSearchLine
        width: parent.width
        height: 60

        onSearchLineChanged: function(value)
        {
            filter = value
            filterChatList()
        }
        onActionButtonClicked: function()
        {
            actionWidget.open()
        }
    }

    Rectangle
    {
        id: chatListView

        height: parent.height - chatSearchLine.height
        width: parent.width
        color: Material.background
        anchors.top: chatSearchLine.bottom

        ListModel
        {
            id: chatBlockList
        }

        ListModel
        {
            id: filteredBlockList
        }

        ListView
        {
            id: listView
            clip: true
            anchors.fill: parent
            model: filter.length === 0 ? chatBlockList : filteredBlockList
            orientation: Qt.Vertical
            boundsBehavior: Flickable.StopAtBounds
            verticalLayoutDirection: ListView.TopToBottom
            delegate: ChatBlock
            {
                title: model.text
                width: listView.width
            }
            ScrollBar
            {
                visible: parent.contentHeight > parent.height
                background: Rectangle
                {
                    width: 10
                    radius: 20
                    color: "transparent"
                    anchors.right: parent.right
                }
                contentItem: Rectangle
                {
                    radius: 20
                    color: "transparent"
                    implicitWidth: 10
                    anchors.right: parent.right
                }
            }
        }
    }
    Rectangle
    {
        id: resizeWidget
        width: 5
        height: parent.height
        color: "transparent"
        anchors.left: chatListViewBlock.right

        MouseArea
        {
            anchors.fill: parent
            hoverEnabled: true
            drag.target: parent
            drag.axis: Drag.XAxis
            cursorShape: drag.active ? Qt.SizeHorCursor : Qt.ArrowCursor
            onEntered:
            {
                cursorShape = Qt.SizeHorCursor;
            }
            onMouseXChanged:
            {
                if(drag.active)
                {
                    const maxWidth = mainWindow.width - (mainWindow.width / 2);
                    const minWidth = mainWindow.width * 0.2;
                    chatListViewBlock.width += mouseX

                    if(chatListViewBlock.width > maxWidth)
                        chatListViewBlock.width = maxWidth
                    if(chatListViewBlock.width < minWidth)
                        chatListViewBlock.width = minWidth
                }
            }
        }
    }
    Component.onCompleted:
    {
        chatBlockList.append({"text": "Alice"})
        chatBlockList.append({"text": "Bob"})
        chatBlockList.append({"text": "Charlie"})
        chatBlockList.append({"text": "David"})
        chatBlockList.append({"text": "Eve"})
        chatBlockList.append({"text": "Frank"})
        chatBlockList.append({"text": "Grace"})
        chatBlockList.append({"text": "Henry"})
        chatBlockList.append({"text": "Ivy"})
        chatBlockList.append({"text": "Jack"})
    }
}

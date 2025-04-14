import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

import "./MessageWidget"

Rectangle
{
    id: correspondensScene

    property var message: null

    width: parent.width
    height: listView.contentHeight
    anchors.bottom: inputMessageWidget.top
    color: "#18191d"

    ListModel
    {
        id: listModel
    }

    ListView
    {
        id: listView
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        model: listModel
        spacing: 5

        anchors
        {
            fill: parent
            bottom: parent.bottom
            left: parent.left
            leftMargin: 10
            topMargin: 2
        }

        delegate: MessageWidget
        {
            senderName: model.senderName
            messageText: model.messageText
            messageTime: Qt.formatDateTime(new Date(), "hh:mm")
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

    Component.onCompleted:
    {
        listModel.append(
            {
                "senderName": "Alex",
                "messageText": "This is small message example:)",
                "currentTimeValue": Qt.formatDateTime(new Date(), "hh:mm"),
            })
        listModel.append(
            {
                "senderName": "Alex",
                "messageText": "This is a large example message. I want to see what it looks like:)",
                "currentTimeValue": Qt.formatDateTime(new Date(), "hh:mm"),
            })
    }

    function addMessage(text)
    {
        listModel.append(
            {
                "senderName": "Alex",
                "messageText": text.toString(),
                "currentTimeValue": Qt.formatDateTime(new Date(), "hh:mm"),
            })
    }
}
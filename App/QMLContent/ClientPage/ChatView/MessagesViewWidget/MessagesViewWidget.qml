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
    anchors.bottom: inputField.top
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
            message: model.message
            owner: model.owner
            currentTimeValue: model.currentTimeValue
            isSenderMe: model.isSenderMe
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

    function addMessage(text)
    {
        listModel.append(
            {
                "owner": "ME",
                "message": text.toString(),
                "currentTimeValue": Qt.formatDateTime(new Date(), "hh:mm"),
                "isSenderMe": true
            })
    }
}
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Rectangle
{
    id: messageWidget
    color: Material.background
    border.color: "gray"
    radius: 10

    property string senderName: ""
    property string messageText: ""
    property string messageTime: Qt.formatDateTime(new Date(), "hh:mm")
    property int fontSize: 14
    property int horizontalPadding: 12
    property int verticalPadding: 8
    property int avatarSize: 36

     width: contentColumn.width + 2 * horizontalPadding + avatarSize + horizontalPadding
     height: Math.max(contentColumn.height + 2 * verticalPadding, avatarSize + 2 * verticalPadding)

    Row
    {
        anchors.fill: parent
        spacing: messageWidget.horizontalPadding
        padding: 10

        Rectangle
        {
            width: messageWidget.avatarSize
            height: messageWidget.avatarSize
            radius: width / 2
            color: "lightblue"

            Text
            {
                anchors.centerIn: parent
                text: messageWidget.senderName.substring(0, 1).toUpperCase()
                color: "white"
                font.bold: true
                font.pointSize: messageWidget.fontSize + 4
            }
        }

        Column
        {
            id: contentColumn
            anchors.verticalCenter: parent.verticalCenter
            spacing: 2

            Text
            {
                text: messageWidget.senderName
                color: "green"
                font.bold: true
                font.pointSize: messageWidget.fontSize
            }

            Text
            {
                text: messageWidget.messageText
                color: "white"
                font.pointSize: messageWidget.fontSize
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                width: 250
            }

            Text
            {
                anchors.right: parent.right
                text: messageWidget.messageTime
                color: "grey"
                font.pointSize: messageWidget.fontSize - 2
            }
        }
    }
}
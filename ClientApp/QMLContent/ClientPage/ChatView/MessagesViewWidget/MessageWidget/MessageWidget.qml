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
    property string imagePath: ""
    property string messageText: ""
    property string messageTime: Qt.formatDateTime(new Date(), "hh:mm")
    property int fontSize: 14
    property int horizontalPadding: 12
    property int verticalPadding: 8
    property int avatarSize: 36
    property int maxImageWidth: 300
    property int maxImageHeight: 300

    width:  contentLayout.width + horizontalPadding
    height: Math.max(messageLayout.height + 2 * verticalPadding, avatarSize + 2 * verticalPadding)

    Column
    {
        id: messageLayout
        width: parent.width
        padding: 5

        Row
        {
            // HEADER LAYOUT
            id: headerRow
            height: 50
            width: parent.width
            spacing: 10

            Rectangle
            {
                // AVATAR
                width: avatarSize
                height: avatarSize
                radius: width / 2
                color: "#272927"
                anchors.verticalCenter: parent.verticalCenter
                Text
                {
                    anchors.centerIn: parent
                    text: senderName.substring(0, 1).toUpperCase()
                    color: "#00ff95"
                    font.bold: true
                    font.pointSize: fontSize + 4
                }
            }
            Text
            {
                // Sender label
                text: senderName
                color: "green"
                font.bold: true
                font.pointSize: fontSize
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        Column
        {
            id: contentLayout
            padding: 5
            Image
            {
                source: imagePath
                width: Math.min(implicitWidth, messageWidget.maxImageWidth)
                height: Math.min(implicitHeight, messageWidget.maxImageHeight)
            }
            Text
            {
                text: messageText
                color: "white"
                font.pointSize: fontSize
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                width: 250
            }
            Text
            {
                anchors.right: parent.right
                text: messageTime
                color: "grey"
                font.pointSize: fontSize - 2
            }
        }
    }
}
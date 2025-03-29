import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle
{
    id: messageBox

    property string message: qsTr("")
    property string owner: qsTr("")
    property string currentTimeValue: ""
    property bool isSenderMe: false

    readonly property int angleRadius: 10
    readonly property int maxWidth: parent.width / 2
    readonly property int ownerNameTextSize: 15
    readonly property int ownerNameLeftPadding: 10
    readonly property int ownerNameTopPadding: 0
    readonly property int messageTextTopPadding: 0
    readonly property int messageTextLeftPadding: 10
    readonly property int messageBoxHeight: ownerName.height + messageText.height + 10

    width: calculateWidth()

    function calculateWidth()
    {
        if (messageText.width < ownerName.width)
            return ownerName.width + 20;
        else if (messageText.width <= maxWidth)
            return messageText.width + timeIndicator.width;
        else
            return maxWidth;
    }

    height: messageBoxHeight
    color: isSenderMe ? "#2b2f37" : "#33393f"

    radius: angleRadius

    Canvas
    {
        id: triangle
        property int triangleWidth: 40
        property int triangleHeight: 5
        width: triangleWidth
        height: messageBox.height
        anchors.left: messageBox.left

        onPaint:
        {
            drawTriangle()
        }
        function drawTriangle()
        {
            var ctx = getContext("2d");
            ctx.beginPath();
            ctx.moveTo(0, height);
            ctx.lineTo(triangleWidth, height - triangleHeight);
            ctx.lineTo(0, height - triangleWidth);
            ctx.closePath();
            ctx.fillStyle = messageBox.color;
            ctx.fill();
        }
    }

    TextMetrics
    {
        id: textMetrics
        text: messageBox.message
        font: messageText.font
    }

    Text
    {
        id: ownerName
        font.bold: true
        color: isSenderMe ? "#457571" : "#4575a1"
        anchors.top: parent.top
        topPadding: ownerNameTopPadding
        leftPadding: ownerNameLeftPadding
        text: messageBox.owner
        wrapMode: Text.WordWrap
        font.pixelSize: ownerNameTextSize
    }

    Text
    {
        id: messageText
        text: messageBox.message
        anchors.top: ownerName.bottom
        topPadding: messageTextTopPadding

        leftPadding: messageTextLeftPadding
        color: "white"
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        width: textMetrics.width >= maxWidth ? maxWidth : textMetrics.width + 50
        font.pixelSize: 15
    }

    Text
    {
        id: timeIndicator
        text: currentTimeValue
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        bottomPadding: 5
        rightPadding: 5
        color:  "#505b65"
        font.pixelSize: 10
    }
}
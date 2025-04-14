import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Basic
import QtQuick.Controls.Material 2.15

Rectangle
{
    id: inputMessageWidget
    color: Material.background
    radius: 20
    border.color: "#282e33"
    border.width: 2

    signal sendButtonClicked(string text)
    function sendMessage()
    {
        let message = textEditor.text.trim();
        if (message !== "")
        {
            sendButtonClicked(message);
            textEditor.clear();
        }
    }

    Flickable {
        id: flickable
        width: parent.width - (sendButton.width + fileButton.width)
        height: parent.height
        anchors.right: fileButton.left
        contentWidth: textEditor.width
        contentHeight: textEditor.height
        boundsBehavior: Flickable.StopAtBounds
        clip: true

        TextEdit
        {
            id: textEditor
            width: flickable.width
            height: contentHeight
            clip: true
            color: "white"
            font.pointSize: 14
            wrapMode: TextEdit.Wrap
            verticalAlignment: Text.AlignVCenter
            textFormat: TextEdit.PlainText

            onCursorRectangleChanged:
            {
                if(contentHeight > inputMessageWidget.height && inputMessageWidget.height < mainWindow.height / 3)
                    inputMessageWidget.height = contentHeight;
                if(inputMessageWidget.height > mainWindow.height / 3)
                    inputMessageWidget.height = mainWindow.height / 3;
            }

            onTextChanged:
            {
                if (textEditor.text.trim() === "")
                    inputMessageWidget.height = 50;
            }

            Keys.onPressed: function (event)
            {
                if (event.key === Qt.Key_Return && event.modifiers && Qt.ControlModifier)
                    sendMessage()
            }
        }
    }

    Button
    {
        id: sendButton

        width: 75
        height: 50
        anchors.rightMargin: 5
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        text: "send"
        background: Rectangle
        {
            color: sendButton.hovered ? "#434543" :  "#282e33"
            radius: 20
        }

        onClicked: sendMessage()
    }

    Button
    {
        id: fileButton
        width: 75
        height: 50
        anchors.rightMargin: 1
        anchors.right: sendButton.left
        anchors.bottom: parent.bottom
        text: "File"
        background: Rectangle
        {
            color: fileButton.hovered ? "#434543" :  "#282e33"
            radius: 20
        }
    }
}
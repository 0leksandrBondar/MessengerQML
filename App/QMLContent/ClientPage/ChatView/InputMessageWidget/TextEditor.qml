import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Flickable
{
    id: flick
    clip: true
    contentWidth: textEdit.contentWidth
    contentHeight: textEdit.contentHeight
    boundsBehavior: Flickable.StopAtBounds
    property string text: qsTr("")

    function clear()
    {
        textEdit.clear();
    }

    TextEdit
    {
        id: textEdit
        width: flick.width

        property int defaultInputFieldHeight: 50

        height: contentHeight < inputMessageWidget.height ? inputMessageWidget.height : contentHeight

        focus: true
        color: "white"
        font.pointSize: 14
        wrapMode: TextEdit.Wrap
        leftPadding: 15
        verticalAlignment: Text.AlignVCenter

        onCursorRectangleChanged:
        {
            if(contentHeight > inputMessageWidget.height && inputMessageWidget.height < mainWindow.height / 3)
                inputMessageWidget.height = contentHeight;
            if(inputMessageWidget.height > mainWindow.height / 3)
                inputMessageWidget.height = mainWindow.height / 3;
        }

        onTextChanged:
        {
            flick.text = textEdit.text
            if (textEdit.text.trim() === "")
                inputMessageWidget.height = defaultInputFieldHeight;
        }
    }
}
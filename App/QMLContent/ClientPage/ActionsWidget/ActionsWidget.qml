import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

import "./Actions"

Popup
{
    id: popup
    modal: true
    padding: 0

    property Item window: null

    background: Rectangle
    {
        color: Material.background
    }

    Overlay.modal: Rectangle
    {
        color: Material.background
        opacity: 0.5
    }

    ListModel
    {
        id: actionModel
    }

    ListView
    {
        anchors.fill: parent
        clip: true
        model: actionModel
        orientation: Qt.Vertical
        boundsBehavior: Flickable.StopAtBounds
        verticalLayoutDirection: ListView.TopToBottom

        delegate: ActionBlock
        {
            width: parent.width
            name: model.name

            onSelectedAction: function(actionName)
            {
                popup.close()
                if(actionName === "Create chat")
                    createChatAction.open()
            }
        }
    }

    CreateChatAction
    {
        id: createChatAction
        width: 400
        height: 400
        x: (popup.window.width - createChatAction.width) / 2   // h center of mainWindow
        y: (popup.window.height - createChatAction.height) / 2 // v center of mainWindow
    }

    Component.onCompleted:
    {
        actionModel.append({"name": "Create chat"})
        actionModel.append({"name": "Create group" })
        actionModel.append({"name": "Settings"})
    }
}

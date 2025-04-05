import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Popup
{
    id: popup
    modal: true
    padding: 0

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
        ListElement{ name: "Create chat" }
        ListElement{ name: "Create group" }
        ListElement{ name: "Settings" }
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
        }
    }
}

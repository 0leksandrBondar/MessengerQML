import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Popup
{
    id: popup
    clip: true
    modal: true
    parent: Overlay.overlay
    Overlay.modal: Rectangle
    {
        color: Material.background
        opacity: 0.5
    }
}

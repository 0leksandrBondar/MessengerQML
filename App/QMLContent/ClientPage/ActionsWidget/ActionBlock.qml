import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Rectangle
{
    id: actionBlock

    height: 50
    width: parent.width
    color: Material.background

    signal selectedAction(string actionName)

    property string name: "null"

    Label
    {
        text: name
        color: "#00e8d1"
        anchors.centerIn: parent
        font.pointSize: 14
    }
    MouseArea
    {
        anchors.fill: parent
        hoverEnabled: true
        onEntered:
        {
            actionBlock.color = "#434543"
        }
        onExited:
        {
            actionBlock.color = Material.background
        }
        onClicked:
        {
            selectedAction(name)
        }
    }
}
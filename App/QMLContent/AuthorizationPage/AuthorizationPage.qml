import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Basic
import QtQuick.Controls.Material 2.15

Rectangle
{
    width: mainWindow.width
    height: mainWindow.height

    color: Material.background

    signal signInButtonClicked()

    Label
    {
        id: pageLabel
        text: "Welcome to the Messenger"
        color: "#00ff95"
        font.bold: true
        font.pointSize: 54
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: parent.height / 6
    }

    TextField
    {
        id: userNameInputField
        width: 500
        height: 50
        font.pointSize: 20
        anchors.top: pageLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 150
        placeholderText: (!activeFocus && text.length === 0) ? qsTr("Enter username ...") : ""
        background: Rectangle
        {
            color: Material.background
            radius: 20
            border.color: "#00ff95"
            border.width: 1
        }
    }

    TextField
    {
        id: passwordInputField
        width: 500
        height: 50
        font.pointSize: 20
        echoMode: TextInput.Password
        anchors.top: userNameInputField.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 30
        placeholderText: (!activeFocus && text.length === 0) ? qsTr("Enter password ...") : ""
        background: Rectangle
        {
            color: Material.background
            radius: 20
            border.color: "#00ff95"
            border.width: 1
        }
    }

    Button
    {
        id: signInButton
        width: 150
        height: 70
        anchors.topMargin: 30
        anchors.top: passwordInputField.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: signInButtonClicked()
        contentItem: Text
        {
            text: qsTr("SignIn")
            color: parent.hovered ? "#1b1c1f" : "#00ff95"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pointSize: 17
        }
        background: Rectangle
        {
            radius: 30
            border.width: 1
            border.color: "#00ff95"
            opacity: parent.hovered ? 0.7 : 0.9
            color: parent.hovered ? "#00ff95" : "#1b1c1f"
        }
    }
}
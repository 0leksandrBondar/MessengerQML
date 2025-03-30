import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

import "ClientPage"
import "AuthorizationPage"

ApplicationWindow
{
    id: mainWindow
    visible: true
    width: 1300
    height: 900
    minimumWidth: 850
    minimumHeight: 700
    title: qsTr("Messenger")

    Material.theme: Material.Dark

    StackView
    {
        id: pageSwitcher
        anchors.fill : parent
        initialItem: authorizationPage

        Component
        {
            id: authorizationPage
            AuthorizationPage
            {
                onSignInButtonClicked:  pageSwitcher.push(clientPage)
            }
        }
        Component
        {
            id: clientPage
            ClientPage
            {
            }
        }
    }
}
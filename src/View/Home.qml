import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts

import "Controls"

Page {
    id: homePage

    title: qsTr("Home")

    property var mainWindow: null

    padding: 20

    Item {
        width: parent.width
        height: folderPathTextField.implicitHeight + browseButton.implicitHeight
        anchors.centerIn: parent

        Label {
            id: presentationLabel

            text: qsTr("Please select a folder")
            font.family: "Roboto"
            font.pixelSize: 21
            // color:
            anchors.horizontalCenter: parent.horizontalCenter
            Material.foreground: Material.theme == Material.Dark ? Material.color(Material.Yellow, Material.Shade100)
                                                                 : Material.color(Material.Yellow, Material.Shade600)
        }

        POTextField {
            id: folderPathTextField

            text:                       mainWindow.modelManager.folderPath
            placeholderText:            qsTr("Folder path")

            anchors.top:                presentationLabel.bottom
            anchors.topMargin:          10
            anchors.horizontalCenter:   parent.horizontalCenter

            onAcceptedCallback: function() {
                // Set to model
                mainWindow.modelManager.folderPath = folderPathTextField.text;
            }
        }

        POButton {
            id: browseButton

            text: qsTr("Browse...")

            anchors.top: folderPathTextField.bottom
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter

            onClicked: folderDialog.open()
        }

        POButton {
            id: organizeButton

            text: qsTr("Organize")
            visible: folderPathTextField.length > 0

            anchors.top: browseButton.bottom
            anchors.topMargin: 5
            anchors.horizontalCenter: parent.horizontalCenter

            onClicked: mainWindow.switchToTab(1)
        }
    }


    FolderDialog {
        id: folderDialog

        title: qsTr("Select a folder")

        onAccepted: {
            // Set to model
            mainWindow.modelManager.folderPath = folderDialog.selectedFolder.toString();
        }
    }

}

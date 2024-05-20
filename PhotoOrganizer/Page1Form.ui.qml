import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Item {
    id: item1
    property alias photoPathButton:     photoPathButton
    property alias buttonCreateFolder:  buttonCreateFolder
    property alias photoPathField:      photoPathField
    property alias photoPathFieldText:  photoPathField.text
    property alias dirName1:            folder1NameField.text
    property alias dirName2:            folder2NameField.text
    property alias dirName3:            folder3NameField.text
    property var   dirNames:            [folder1NameField.text, folder2NameField.text, folder3NameField.text]

    ColumnLayout {
        id: pathColumnLayout
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.left: parent.left
        spacing: 8
        anchors.rightMargin: 16
        anchors.leftMargin: 16
        transformOrigin: Item.Center

        Text {
            id: infoPathText
            color: "#ba0958"
            text: qsTr("Select your picture folder")
            font.bold: false
            font.family: "Arial"
            font.pointSize: 12
            verticalAlignment: Text.AlignTop
            elide: Text.ElideRight
        }
        RowLayout {
            id: photoPathRow
            y: 0
            width: 450
            spacing: 8
            Layout.fillWidth: true
            anchors.horizontalCenter: parent.horizontalCenter

            TextField {
                id: photoPathField
                x: 0
                width: 250
                text: ""
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignLeft
                font.pointSize: 10
                placeholderText: qsTr("Folder path")
            }

            Button {
                id: photoPathButton
                text: qsTr("Browse")
            }
        }

        Text {
            id: infoPathText2
            color: "#ba0958"
            text: qsTr("Folder name 1")
            font.family: "Arial"
            elide: Text.ElideRight
            verticalAlignment: Text.AlignTop
            font.pointSize: 12
        }

        TextField {
            id: folder1NameField
            text: qsTr("Web_pictures")
            width: parent.width * 0.5
        }

        Text {
            id: infoPathText3
            color: "#ba0958"
            text: qsTr("Folder name 2")
            font.family: "Arial"
            elide: Text.ElideRight
            verticalAlignment: Text.AlignTop
            font.pointSize: 12
        }

        TextField {
            id: folder2NameField
            text: qsTr("To_be_printed")
        }

        Text {
            id: infoPathText4
            color: "#ba0958"
            text: qsTr("Folder name 3")
            font.family: "Arial"
            elide: Text.ElideRight
            verticalAlignment: Text.AlignTop
            font.pointSize: 12
        }

        TextField {
            id: folder3NameField
            text: qsTr("Others")
        }

        Button {
            id: buttonCreateFolder

            width: 72
            text: qsTr("Create")
            rightPadding: 11
            leftPadding: 11
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            highlighted: true
        }
    }
}

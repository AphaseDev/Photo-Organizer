import QtQuick
import QtQuick.Controls
import Qt.labs.platform as Platform
import Qt.labs.folderlistmodel

ApplicationWindow {
    width: 640
    height: 480
    visible: true
    title: "" // The title of the window is automatically set by setting QGuiApplication::setApplicationDisplayName

    background: Rectangle {
        color: "darkGray"
    }

    header: ToolBar {
        Flow {
            anchors.fill: parent
            ToolButton {
                text: qsTr("Open")
                icon.name: "document-open"
                onClicked: fileOpenDialog.open()
            }
        }
    }

    Platform.MenuBar {
        Platform.Menu {
            title: qsTr("&File")
            Platform.MenuItem {
                text: qsTr("&Open...")
                icon.name: "document-open"
                onTriggered: fileOpenDialog.open()
            }
        }

        Platform.Menu {
            title: qsTr("&Help")
            Platform.MenuItem {
                text: qsTr("&About...")
                onTriggered: aboutDialog.open()
            }
        }
    }

    // Button {
    //     anchors.centerIn: parent
    //     text: "Browse..."
    // }


    ListView {
        id: listView
        anchors.fill: parent
        highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
        model: folderModel
        delegate: Item {
            width: listView.width
            height: 140

            Keys.onSpacePressed: maximizeImage(listViewItemImage.source);

            Image {
                id: listViewItemImage
                x: 5
                y: 5
                width: 128
                height: 128
                source: fileUrl
            }

            Text {
                y: 5
                anchors.left: listViewItemImage.right
                anchors.leftMargin: 10
                text: fileName
                font.pointSize: 16
            }

            MouseArea {
                anchors.fill: parent
                onReleased: maximizeImage(listViewItemImage.source);
            }
        }
    }


    // Full-screen image popup
    Popup {
        id: imagePopup

        modal: true
        focus: true
        dim: true
        anchors.centerIn: parent
        width: Math.min(fullSizeImage.sourceSize.width, parent.width * 0.7)
        height: Math.min(fullSizeImage.sourceSize.height, parent.height * 0.7)
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        // Rectangle {
        //     // width: Math.min(parent.width * 0.9, 600)
        //     // height: Math.min(parent.height * 0.9, 600)
        //     // width: fullSizeImage.
        //     // height: fu
        //     color: "black"
        //     border.color: "white"
        //     border.width: 2
        //     radius: 8

            Image {
                id: fullSizeImage
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
            }
        // }
    }

    // Function to open the image in a popup
    function maximizeImage(imageSource) {
        // console.log("Opening image: " + imageSource);
        if (imageSource && imageSource !== "") {
            fullSizeImage.source = imageSource;
            imagePopup.open();
        } else {
            console.warn("Invalid image source");
        }
    }



    // Platform.FileDialog {
    //     id: fileOpenDialog

    //     title: "Select an image file"
    //     folder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
    //     nameFilters: [
    //         "Image files (*.png *.jpeg *.jpg)",
    //     ]
    //     onAccepted: {
    //         image.source = fileOpenDialog.fileUrl;
    //     }
    // }
    Platform.FolderDialog {
        id: fileOpenDialog

        onAccepted: {
            folderModel.folder = fileOpenDialog.folder;
            // showCurrentView();
        }
    }

    FolderListModel {
        id: folderModel

        showDirs: false
        nameFilters: [ "*.png", "*.jpeg", "*.jpg", "*.gif" ]
    }

}

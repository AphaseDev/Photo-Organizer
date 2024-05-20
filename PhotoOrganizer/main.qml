import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.0

ApplicationWindow {
    id: mainApplicationWindow
    visible: true
    width:   640
    height:  480
    title:   qsTr("Photo Organizer ") + Qt.application.version


    property var    imageNameFilters : ["*.png", "*.PNG", "*.jpg", "*.JPG", "*.gif", "*.GIF"];
    property string folderLocation :   ""; //fileDialog.shortcuts.pictures;
    property alias  directoryNames :   page1Path.dirNames


    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex

        Page1 {
            id: page1Path


            FileDialog {
                id: fileDialog
                title: qsTr("Choose a folder with some images")
                selectFolder: true
                folder: folderLocation
                onAccepted: {
                    var folderPath = fileUrl.toString()
                    //displayedFolderLocation = folderPath.substring(8, folderPath.length) //+ "/"
                    //console.log("REPLY: "+folderPath)

                    page1Path.photoPathFieldText = folderPath
                }
            }
        }

        Page2 {
            id: page2Organizer
            picturesLocation: folderLocation
        }

        //onCurrentIndexChanged: (currentIndex == 1) ? swipeView.interactive = false : swipeView.interactive = true;
    }

    footer: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex
        TabButton {
            text: qsTr("Folder")
        }
        TabButton {
            text: qsTr("Organizer")
        }
    }



    Shortcut { sequence: StandardKey.Quit; onActivated: Qt.quit() }

    Component.onCompleted: {

    }
}

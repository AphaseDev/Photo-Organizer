import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import Qt.labs.folderlistmodel

import "Controls"

Page {
    id: homePage

    title: qsTr("Organizer")

    property var mainWindow: null
    readonly property string modelFolderPath:       mainWindow.modelManager.folderPath.length > 0 ? "file:///" + mainWindow.modelManager.folderPath : ""

    readonly property string currentFileName:       getFolderModelProperty(folderListView.currentIndex, "fileName")
    readonly property string currentFilePath:       getFolderModelProperty(folderListView.currentIndex, "filePath")
    readonly property string currentFileBaseName:   getFolderModelProperty(folderListView.currentIndex, "fileBaseName")
    readonly property string currentFileSuffix:     getFolderModelProperty(folderListView.currentIndex, "fileSuffix")
    readonly property bool   currentFileIsDirh:     getFolderModelProperty(folderListView.currentIndex, "fileIsDir")

    padding: 20

    Item {
        id: homePageItem

        anchors.fill:   parent

        // File Info
        POTextField {
            id: fileNameTextField

            text:               currentFileName
            placeholderText:    qsTr("File Name") + (folderListView.currentIndex >= 0 ? " | " + folderListView.currentIndex : "")
            z:                  100
            // visible:       !currentFileIsDirh

            onAcceptedCallback: function() {
                if (fileNameTextField.text.length > 0) {
                    console.debug("# onAccepted:", fileNameTextField.text);
                    // Rename the file
                    mainWindow.modelManager.renameFile(currentFilePath, currentFileName, text);
                }
                giveFocusBackToViewer();
            }
        }

        // Viewer
        ListView {
            id: folderListView

            anchors.fill:                parent
            snapMode:                    ListView.SnapOneItem
            highlightFollowsCurrentItem: true
            highlightRangeMode:          ListView.StrictlyEnforceRange   // To update the currentIndex when the list is moved
            highlightMoveDuration:       250
            highlightMoveVelocity:       -1
            orientation:                 ListView.Horizontal
            // boundsBehavior:             Flickable.StopAtBounds
            focus:                       true
            clip:                        true
            // keyNavigationWraps:         true
            model:                       modelFolderPath.length > 0 ? folderModel : null    // Added because if folderPath is null, the folderModel's default value is the application's working directory

            onMovementEnded: {
                // Auto-update currentIndex when the view settles on a new item
                const l_centerIndex = getCenterIndex();
                if (l_centerIndex >= 0) {
                    currentIndex = l_centerIndex;
                }
            }
            onCountChanged: {
                if (count > 0) {
                    // Ensure the first item is selected on startup
                    currentIndex = getCenterIndex();
                    // console.log("onCountChanged: ", currentIndex);
                }
            }
            function getCenterIndex() {
                return indexAt(contentX + width * 0.5, 0);
            }

            delegate: Loader {
                id: imageLoader

                sourceComponent: Component {
                    id: fileDelegate

                    Item {
                        id: delegateItem

                        width:  folderListView.width    // Full-screen width
                        height: folderListView.height

                        Column {
                            id: pictureDelegateColumn

                            Image {
                                id: imageView

                                width:          folderListView.width
                                height:         folderListView.height
                                fillMode:       Image.PreserveAspectFit
                                source:         fileUrl
                                antialiasing:   true
                                asynchronous:   true
                                visible:        !fileIsDir
                            }
                        }

                        // Support key navigation
                        focus: true
                        Keys.onRightPressed: {
                            if (!folderListView.moving && folderListView.interactive) {
                                folderListView.incrementCurrentIndex();
                            }
                        }
                        Keys.onLeftPressed: {
                            if (!folderListView.moving && folderListView.interactive) {
                                folderListView.decrementCurrentIndex();
                            }
                        }
                        Keys.onSpacePressed: maximizeImage(imageView.source)

                        MouseArea {
                            anchors.fill: parent
                            onReleased: delegateItem.forceActiveFocus()
                            onDoubleClicked: maximizeImage(imageView.source)
                        }
                    } // Item
                }
            }

            Component.onCompleted: {
                // To be able to use key navigation directly
                giveFocusBackToViewer();
            }
        } // ListView


        // Output folders left
        POButtonGroup {
            id: buttonGroupLeft

            side:           Qt.AlignLeft
            x:              -homePage.padding
            buttonsModel:   mainWindow.modelManager.outputFoldersLeft

            onClickedCallback: function(p_index, p_folderPath, p_labelTitle) {
                // TODO rewrite
                // mainWindow.modelManager.moveFileToFolder(modelData.folderPath, homePage.currentFileName, modelData.labelTitle);

                giveFocusBackToViewer();
            }
        }


        // Output folders right
        POButtonGroup {
            id: buttonGroupRight

            side:           Qt.AlignRight
            x:              parent.width - width + homePage.padding
            buttonsModel:   mainWindow.modelManager.outputFoldersRight

            onClickedCallback: function(p_index, p_folderPath, p_labelTitle) {
                // TODO rewrite
                // mainWindow.modelManager.moveFileToFolder(modelData.folderPath, homePage.currentFileName, modelData.labelTitle);

                giveFocusBackToViewer();
            }
        }

    } // homePageItem



    // Model
    FolderListModel {
        id: folderModel

        // property var imageNameFilters : ["*.png", "*.PNG", "*.jpg", "*.JPG", "*.gif", "*.GIF"];
        // nameFilters: imageNameFilters
        showDirs:   false   // TEST true
        folder:     modelFolderPath

        onFolderChanged: console.log("FolderListModel: "+ folder)
    }

    function getFolderModelProperty(p_index, p_property) {
        return folderListView.currentIndex >= 0 ? folderModel.get(p_index, p_property) : "";
    }


    // Maximize image popup
    Popup {
        id: imagePopup

        modal:              true
        focus:              true
        dim:                true
        anchors.centerIn:   parent
        width:              Math.min(fullSizeImage.sourceSize.width, parent.width * 0.8)
        height:             Math.min(fullSizeImage.sourceSize.height, parent.height * 0.8)
        closePolicy:        Popup.CloseOnEscape | Popup.CloseOnPressOutside

        Image {
            id: fullSizeImage
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
        }
        MouseArea {
            anchors.fill: parent
            onDoubleClicked: imagePopup.close()
        }
    }

    // Opens the image in a popup
    function maximizeImage(imageSource) {
        // console.log("Opening image: " + imageSource);
        if (imageSource && imageSource !== "") {
            fullSizeImage.source = imageSource;
            imagePopup.open();
        } else {
            console.warn("Invalid image source");
        }
    }

    function giveFocusBackToViewer() {
        folderListView.forceActiveFocus();
    }

}

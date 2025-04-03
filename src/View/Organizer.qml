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
            }
        }

        ListView {
            id: folderListView

            anchors.fill:       parent
            snapMode:           ListView.SnapOneItem
            highlightFollowsCurrentItem: true
            highlightRangeMode: ListView.StrictlyEnforceRange   // To update the currentIndex as the list is moved
            orientation:        ListView.Horizontal
            // boundsBehavior:     Flickable.StopAtBounds
            focus:                  true
            clip:                   true
            // interactive:    false

            model:              modelFolderPath.length > 0 ? folderModel : null // Added because if folderPath is null, the folderModel's default value is the application's working directory

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
                        width:  folderListView.width    // Full-screen width
                        height: folderListView.height

                        Column {
                            id: pictureDelegateColumn

                            Image {
                                id: imageView

                                width:          folderListView.width
                                height:         folderListView.height
                                fillMode:       Image.PreserveAspectFit
                                source:         /*!fileIsDir ?*/ fileUrl //: ""
                                antialiasing:   true
                                asynchronous:   true
                                visible:        !fileIsDir
                            }
                            //                            PinchArea {
                            //                                height:         imageView.height
                            //                                width:          imageView.width
                            //                                pinch.target:   pictureDelegateColumn
                            //                                pinch.dragAxis: Pinch.XAndYAxis

                            //                                MouseArea {
                            //                                    id: dragArea
                            //                                    hoverEnabled:   true
                            //                                    anchors.fill:   parent
                            //                                    drag.target:    pictureDelegateColumn
                            //                                    scrollGestureEnabled: false  // 2-finger-flick gesture should pass through to the Flickable
                            //                                    onClicked: console.log('CLICKED')
                            //                                }
                            //                            }
                        }

                        // ColumnLayout {
                        //     id: columnLayout

                        //     width: 100
                        //     height: 100
                        //     spacing: 1
                        //     anchors.right: parent.right
                        //     anchors.rightMargin: 16
                        //     anchors.verticalCenter: parent.verticalCenter

                        //     Button {
                        //         id: folderButton1

                        //         Layout.alignment: Qt.AlignRight
                        //         text: directoryNames[0]
                        //         highlighted: true

                        //         onClicked: {
                        //             //console.log('Clicked: '+filePath+' '+fileName)
                        //             mainWindow.modelManager.moveFileToFolder(filePath, fileName, folderButton1.text);
                        //         }
                        //         DropArea {
                        //             anchors.fill: parent
                        //             onEntered: {
                        //                 console.log('DROPPED 1')
                        //             }
                        //         }
                        //     } // folderButton1

                        //     Button {
                        //         id: folderButton2

                        //         Layout.alignment: Qt.AlignRight
                        //         text: directoryNames[1]
                        //         highlighted: true

                        //         onClicked: {
                        //             mainWindow.modelManager.moveFileToFolder(filePath, fileName, folderButton2.text);
                        //         }
                        //         DropArea {
                        //             anchors.fill: parent
                        //             onEntered: {
                        //                 console.log('DROPPED 1')
                        //             }
                        //         }
                        //     } // folderButton2

                        //     Button {
                        //         id: folderButton3

                        //         Layout.alignment: Qt.AlignRight
                        //         text: directoryNames[2]
                        //         highlighted: true

                        //         onClicked: {
                        //             mainWindow.modelManager.moveFileToFolder(filePath, fileName, folderButton3.text);
                        //         }
                        //         DropArea {
                        //             anchors.fill: parent
                        //             onEntered: {
                        //                 console.log('DROPPED 1')
                        //             }
                        //         }
                        //     } // folderButton3
                        // }
                    } // Item
                }
            }

        } // ListView
    }


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


    // -------------

    // ListView {
    //     id: listView
    //     anchors.fill: parent
    //     highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
    //     model: folderModel
    //     delegate: Item {
    //         width: listView.width
    //         height: 140

    //         Keys.onSpacePressed: maximizeImage(listViewItemImage.source);

    //         Image {
    //             id: listViewItemImage
    //             x: 5
    //             y: 5
    //             width: 128
    //             height: 128
    //             source: fileUrl
    //         }

    //         Text {
    //             y: 5
    //             anchors.left: listViewItemImage.right
    //             anchors.leftMargin: 10
    //             text: fileName
    //             font.pointSize: 16
    //         }

    //         MouseArea {
    //             anchors.fill: parent
    //             onReleased: maximizeImage(listViewItemImage.source);
    //         }
    //     }
    // }


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



    // FolderListModel {
    //     id: folderModel

    //     folder: mainWindow.modelManager.folderPath
    //     showDirs: false
    //     nameFilters: [ "*.png", "*.jpeg", "*.jpg", "*.gif" ]
    // }
}

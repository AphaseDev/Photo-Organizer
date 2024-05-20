import QtQuick 2.7
import Qt.labs.folderlistmodel 2.1
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1

Page2Form {
    id: page2OrganizerForm

    property string picturesLocation: "";

    ListView {
        id: folderListView
        anchors.fill:   parent
        snapMode:       ListView.SnapToItem
        orientation:    ListView.Horizontal
        clip:           true
        //interactive:    false

        FolderListModel {
            id: folderModel
            nameFilters: imageNameFilters
            folder:      picturesLocation
            showDirs:    false

            onFolderChanged: console.log("FolderListModel: "+ folder)
            Component.onCompleted: console.log("FolderListModel: "+ folder)
        }

        model: folderModel
        delegate: Component {
            id: loaderComponentDelegate
            Loader {
                id: imageLoader
                sourceComponent: Component {
                    id: fileDelegate

                    Item {
                        width:  folderListView.width
                        height: folderListView.height

                        Column {
                            id: pictureDelegateColumn
                            TextField {
                                text:           fileName
                                //visible:        !fileIsDir
                                anchors.leftMargin: 16
                                onAccepted:     {
                                    modelManager.renameFile(filePath, fileName, text)
                                }
                            }
                            Image {
                                id: imageView
                                width:          folderListView.width
                                height:         folderListView.height
                                fillMode:       Image.PreserveAspectFit
                                source:         /*!fileIsDir ?*/ fileURL //: ""
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

                        ColumnLayout {
                            id: columnLayout

                            width: 100
                            height: 100
                            spacing: 1
                            anchors.right: parent.right
                            anchors.rightMargin: 16
                            anchors.verticalCenter: parent.verticalCenter

                            Button {
                                id: folderButton1

                                Layout.alignment: Qt.AlignRight
                                text: directoryNames[0]
                                highlighted: true

                                onClicked: {
                                    //console.log('Clicked: '+filePath+' '+fileName)
                                    modelManager.moveFileToFolder(filePath, fileName, folderButton1.text)
                                }
                                DropArea {
                                    anchors.fill: parent
                                    onEntered: {
                                        console.log('DROPPED 1')
                                    }
                                }
                            } // folderButton1

                            Button {
                                id: folderButton2

                                Layout.alignment: Qt.AlignRight
                                text: directoryNames[1]
                                highlighted: true

                                onClicked: {
                                    modelManager.moveFileToFolder(filePath, fileName, folderButton2.text)
                                }
                                DropArea {
                                    anchors.fill: parent
                                    onEntered: {
                                        console.log('DROPPED 1')
                                    }
                                }
                            } // folderButton2

                            Button {
                                id: folderButton3

                                Layout.alignment: Qt.AlignRight
                                text: directoryNames[2]
                                highlighted: true

                                onClicked: {
                                    modelManager.moveFileToFolder(filePath, fileName, folderButton3.text)
                                }
                                DropArea {
                                    anchors.fill: parent
                                    onEntered: {
                                        console.log('DROPPED 1')
                                    }
                                }
                            } // folderButton3
                        }

                    } // Item

                }
            }
        }

    } // ListView


}

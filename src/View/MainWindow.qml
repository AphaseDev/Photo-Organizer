import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: mainAppWindow

    visible: true
    title: "" // The title of the window is automatically set by setting QGuiApplication::setApplicationDisplayName

    minimumHeight: 200
    minimumWidth: 300

    readonly property var modelManager: null

    // background: Rectangle {
    //     color: "darkGray"
    // }

    // header: ToolBar {
    //     Flow {
    //         anchors.fill: parent

    //         ToolButton {
    //             text: qsTr("Open")
    //             icon.name: "document-open"
    //             onClicked: fileOpenDialog.open()
    //         }
    //     }
    // }



    StackLayout {
        id: mainStackLayout

        anchors.fill: parent
        currentIndex: mainTabBar.currentIndex

        Loader {
            active: mainStackLayout.currentIndex === 0
            sourceComponent: homeComponent
        }

        Loader {
            active: mainStackLayout.currentIndex === 1
            sourceComponent: organizerComponent
        }

        Loader {
            active: mainStackLayout.currentIndex === 2
            sourceComponent: settingsComponent
        }
    }

    // Lazy-loaded components
    Component {
        id: homeComponent

        Home {
            mainWindow: mainAppWindow
        }
    }
    Component {
        id: organizerComponent

        Organizer {
            mainWindow: mainAppWindow
        }
    }
    Component {
        id: settingsComponent

        Settings {
            mainWindow: mainAppWindow
        }
    }

    footer: TabBar {
        id: mainTabBar

        width: parent.width
        position: TabBar.Footer

        TabButton {
            text: qsTr("Home")
        }
        TabButton {
            text: qsTr("Organizer")
        }
        TabButton {
            text: qsTr("Settings")
        }
    }

    function switchToTab(p_pageNumber)
    {
        mainTabBar.setCurrentIndex(p_pageNumber);
    }


    Connections {
        target: modelManager
        function onRaiseAlert(p_message) {
            console.debug("Alert:", p_message);
            alertDrawer.label.text = p_message;
            alertDrawer.open();
        }
    }

    Drawer {
        id: alertDrawer

        width: mainAppWindow.width
        height: 0.15 * mainAppWindow.height
        edge: Qt.BottomEdge

        property Label label: messageLabel

        Label {
            id: messageLabel

            anchors.centerIn:   parent
            color:              "white"
            font.family:        "Roboto"
            font.pixelSize:     19
        }
    }
}

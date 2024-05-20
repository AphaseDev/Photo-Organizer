import QtQuick 2.7

Page1Form {

    photoPathField.onAccepted: {
        //console.log("REPLY: "+photoPathFieldText)
//        folderLocation = photoPathFieldText;
    }
    photoPathButton.onClicked: {
        fileDialog.open()
    }
    buttonCreateFolder.onClicked: {
        folderLocation = photoPathFieldText;

        if(folderLocation != "") {
            swipeView.setCurrentIndex(1)

            modelManager.createFolder(folderLocation, dirNames[0])
            modelManager.createFolder(folderLocation, dirNames[1])
            modelManager.createFolder(folderLocation, dirNames[2])
        }

    }
}

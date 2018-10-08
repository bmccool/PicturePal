import QtQuick 2.1
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4
import Qt.labs.folderlistmodel 2.1




Rectangle {
    width: 200
    height: 200
    color: "green"

    TreeView {
        TableViewColumn {
            title: "Name"
            role: "fileName"
            width: 100
        }
        TableViewColumn {
            title: "Permissions"
            role: "filePermissions"
            width: 100
        }
        model: fileSystemModel
    }
}


// This opens a file picker
/*
Rectangle {
    width: 200
    height: 200
    color: "green"

    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        folder: shortcuts.home
        onAccepted: {
            console.log("You chose: " + fileDialog.fileUrls)
            Qt.quit()
        }
        onRejected: {
            console.log("Canceled")
            Qt.quit()
        }
        Component.onCompleted: visible = true
    }
}
*/

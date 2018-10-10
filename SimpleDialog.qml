import QtQuick 2.1
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4
import Qt.labs.folderlistmodel 2.1



/*
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
        //model: fileSystemModel
        model: folderModel
    }
}
*/


// This opens a file picker

Rectangle {
    width: 200
    height: 200
    color: "green"

    MouseArea {
        anchors.fill: parent
        z: 2
        onClicked: {
            loader.active = !loader.active
        }
    }

    ListModel {
        id: folderModel
    }

    Component {
        id: folderDelegate
        Row {
            spacing: 10
            Text { text: folder }
        }
    }

    ListView {
        anchors.fill: parent
        model: folderModel
        delegate: folderDelegate
        z: 1
    }


    Loader { 
        id: loader
        sourceComponent: fileDialogComponent
        active: false
    }

    Component {
        id: fileDialogComponent
        FileDialog {
            id: fileDialog
            title: "Please choose a folder"
            selectFolder: true
            folder: shortcuts.home
            // TODO do we need to Qt.quit()?
            onAccepted: {
                console.log("You chose: " + fileDialog.fileUrl)
                folderModel.append({"folder": fileDialog.fileUrl.toString()})
                console.log("There are " + folderModel.count + " items in folderModel")
                loader.active = false
                //Qt.quit()
            }
            onRejected: {
                console.log("Canceled")
                loader.active = false
                //Qt.quit()
            }
            Component.onCompleted: visible = true
        }
    }
}

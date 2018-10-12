import QtQuick 2.1
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4
import Qt.labs.folderlistmodel 2.1

Rectangle {
    id: root
    width: parent.width
    height: parent.height

    MouseArea {
        anchors.fill: parent
        z: 2
        onClicked: {
            loader.active = !loader.active
        }
    }

//    ListModel {
//        id: folderModel
//    }

//    Component {
//        id: folderDelegate
//        Row {
//            spacing: 10
//            Text { text: folder }
//        }
//    }

//    Component {
//        id: pictureDelegate
//        Row {
//            spacing: 10
//            Text {text: display}
//        }
//    }

    ListView {
        anchors.fill: parent
        anchors.leftMargin: 25
        anchors.rightMargin: 25
        anchors.bottomMargin: 25
        anchors.topMargin: 25

        model: myModel//folderModel
        //delegate: pictureDelegate//folderDelegate
        delegate: Text {
            anchors.leftMargin: 50
            font.pointSize: 15
            horizontalAlignment: Text.AlignHCenter
            text: display
        }
        z: 3
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
            onAccepted: {
                console.log("You chose: " + fileDialog.fileUrl)
                folderModel.append({"folder": fileDialog.fileUrl.toString()})
                console.log("There are " + folderModel.count + " items in folderModel")
                loader.active = false
            }
            onRejected: {
                console.log("Canceled")
                loader.active = false
            }
            Component.onCompleted: visible = true
        }
    }
}

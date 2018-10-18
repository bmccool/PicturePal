import QtQuick 2.1
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4
import Qt.labs.folderlistmodel 2.1
import QtQml.Models 2.1
import QtQuick.Layouts 1.11

ApplicationWindow {
    id: root
    title: qsTr("PicturePal")
    width: 640
    height: 480
    visible: true

    toolBar:ToolBar {
        RowLayout {
            anchors.fill: parent
            ToolButton {
                text: "Add Folder"
                onClicked: { loader.active = !loader.active }
            }
            ToolButton {text: "Add Filter"}
            ToolButton {
                text: "Show Pictures"
                onClicked: { slideShow.visible =! slideShow.visible }
            }
            Item { Layout.fillWidth:true }
        }
    }

    Rectangle {
        id: slideShow
        anchors.fill: parent
        color: "black"
        visible: false
        z: 10

        property int index: 0
        property variant rlist: []

        function getNextUrl(){
            return "file:///" + backend.getPicUrl(index++); //filename
        }

        Image {
            id: slideShowImage
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            source: ""
        }

        MouseArea { 
            anchors.fill: parent
            z: 11
            onClicked: { slideShowImage.source = parent.getNextUrl() }
        }

    }

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

    Component {
        id: pictureDelegate
        Row {
            spacing: 10
            Text {text: display}
        }
    }

    ListView {
        anchors.fill: parent
        anchors.leftMargin: 25
        anchors.rightMargin: 25
        anchors.bottomMargin: 25
        anchors.topMargin: 25

        model: folderModel//pictureModel//folderModel//myModel
        delegate: folderDelegate//pictureDelegate
        //delegate: Row {
        //    Text { text: name }
        //    Text { text: caption }
        //}
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
            onAccepted: {
                console.log("You chose: " + fileDialog.fileUrl)
                backend.text = fileDialog.fileUrl.toString()
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

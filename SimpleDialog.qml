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
            ToolButton { text: "Show Folders"}
            ToolButton {
                text: "Add Folder"
                onClicked: { loader.active = !loader.active }
            }
            ToolButton { text: "Add Filter" }
            ToolButton { 
                text: "Show Filters"
                onClicked: { filterLoader.active = !filterLoader.active }
            }
            ToolButton {
                text: "Show Pictures"
                onClicked: { slideShowLoader.active = !slideShowLoader.active }
            }
            Item { Layout.fillWidth:true }
        }
    }

    Loader {
        id: filterLoader
        source: "Filters.qml"
        active: false
        anchors.fill: parent
        z: 10 // TODO can we make a ZTOP or something so we dont have magic numbers for z?
    }

    Loader {
        id: slideShowLoader
        source: "SlideShow.qml"
        active: false
        anchors.fill: parent
        z: 10 // TODO can we make a ZTOP or something so we dont have magic numbers for z?
    }

    PicturePalSettings {}

    ListModel {
        id: folderModel
    }

    Component {
        id: folderDelegate
        Item{
            width: parent.width
            height: 20
            Row {
                spacing: 10
                Text { text: folder }
            }
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: {
                    folderView.currentIndex = index
                    if (mouse.button === Qt.RightButton) {
                        contextMenu.popup()
                    }
                }
                Menu {
                    id: contextMenu
                    MenuItem { 
                        text: "Remove folder"
                        onTriggered: { removeFolder(index) }
                    }
                }
            }

        }
    }

    function removeFolder(index) {
        // Remove the folder from folderModel
        folderModel.remove(index)
        // Clear backend pictures
        backend.clearPics()
        // For each folder
        for (var i = 0; i < folderModel.count; ++i) {
            // Add folder to backend 
            backend.text = folderModel.get(i).folder
        }
    }

    ListView {
        id: folderView
        anchors.fill: parent
        anchors.leftMargin: 25
        anchors.rightMargin: 25
        anchors.bottomMargin: 25
        anchors.topMargin: 25

        highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
        focus: true

        model: folderModel
        delegate: folderDelegate
        // How to show filename and caption from picture model
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

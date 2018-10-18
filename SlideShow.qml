import QtQuick 2.1
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4
import Qt.labs.folderlistmodel 2.1
import QtQml.Models 2.1
import QtQuick.Layouts 1.11

Rectangle {
    id: slideShow
    anchors.fill: parent
    color: "black"
    z: 10

    property int index: 0
    property variant rlist: []

    function getNextUrl(){
    	var url = "file:///" + backend.getPicUrl(index); //filename
        index = (index + 1) % backend.numPics();
        return url;
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
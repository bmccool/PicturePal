import QtQuick 2.11
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4
import Qt.labs.folderlistmodel 2.1
import QtQml.Models 2.1
import QtQuick.Layouts 1.11

Rectangle {
    id: filters
    anchors.fill: parent
    z: 10
    //color: "green"

    ListModel {
        id: filterModel
    }

    Component {
        id: filterDelegate
        Item{
            width: parent.width
            height: 20
            Row {
                spacing: 10
                Text { text: display }
            }
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: {
                    filterView.currentIndex = index
                    if (mouse.button === Qt.RightButton) {
                        contextMenu.popup()
                    }
                }
                Menu {
                    id: contextMenu
                    MenuItem { 
                        text: "Remove filter"
                        onTriggered: { removeFilter(index) }
                    }
                }
            }

        }
    }    

    //Column {

        /*
    	ListView {
        	id: filterView
        	anchors.fill: parent
        	anchors.leftMargin: 25
        	anchors.rightMargin: 25
        	anchors.bottomMargin: 25
        	anchors.topMargin: 25

        	highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
        	focus: true

        	model: filterModel
        	delegate: filterDelegate
	        z: 1
    	}
    	*/   
    //}

    Item {
    	id: contents
    	width: parent.width - 100
    	height: parent.height - 100
    	anchors.verticalCenter: parent.verticalCenter
    	anchors.horizontalCenter: parent.horizontalCenter

    	FocusScope {
    		id: focusScope
            TextInput: {
            	id: textInputComponent
            	//anchors { left: parent.left; leftMargin: 4; right: parent.left; rightMargin: 4; verticalCenter: parent.verticalCenter }
            	focus: true
            	selectByMouse: true
            	color: "black"

            }
    	}
    }

   function removeFolder(index) {
         console.log("removeFolder!")
    }

}
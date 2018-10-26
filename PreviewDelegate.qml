import QtQuick 2.1

Item {
    id: delegate
    property string text
    width: parent.width
    height: itemRect.height + 2

    Rectangle {
        id: itemRect

        property bool selected: itemMouseArea.containsMouse        

        height: textComponent.height
        width: parent.width - 2

        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        color: "#333333"
        radius: 5
        border {
            width: 2
            color: itemMouseArea.containsMouse ? "white" : "grey"
        }

        Text {
            width: parent.width - 10
            anchors.horizontalCenter: parent.horizontalCenter
            id: textComponent
            color: "white"
            text: delegate.text
        }
        MouseArea {
            id: itemMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: console.log("TODO: CLICKED: " + textComponent.text + " AND DID NOTHING")        
        }
    }
}

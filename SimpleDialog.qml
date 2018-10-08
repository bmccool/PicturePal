import QtQuick 2.0
import QtQuick.Dialogs 1.2

Rectangle {
    width: 200
    height: 200
    color: "green"

    Text {
        text: "Hello World"
        anchors.centerIn: parent
    }

    Dialog {
        visible: true
        title: "Blue sky dialog"

        contentItem: Rectangle {
            color: "lightskyblue"
            implicitWidth: 400
            implicitHeight: 100
            Text {
                text: "Hello blue sky!"
                color: "navy"
                anchors.centerIn: parent
            }
        }
    }
}
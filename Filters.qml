import QtQuick 2.1

Rectangle {
    width: 640
    height: 480
    color: "black"

    Suggestions {
        id: suggestions
    }

    Item {
        id: contents
        width: parent.width - 100
        height: parent.height - 100
        anchors.centerIn: parent

        LineEdit {
            id: inputField
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 18

            hint.text: "Enter a keyword. Possible keywords are listed below"
            borderColor: "red"

            function activateSuggestionAt(offset) {
                var max = suggestionsBox.count
                if(max == 0)
                    return

                var newIndex = ((suggestionsBox.currentIndex + 1 + offset) % (max + 1)) - 1
                suggestionsBox.currentIndex = newIndex
            }
            onUpPressed: activateSuggestionAt(-1)
            onDownPressed: activateSuggestionAt(+1)
            onEnterPressed: processEnter()
            onAccepted: processEnter()

            Component.onCompleted: {
                inputField.forceActiveFocus()
            }

            function processEnter() {
                if (suggestionsBox.currentIndex === -1) {
                	//TODO should this be a function that just takes text input in order to generalize for keyboard/mouse/other input?
                	backend.selectKeyword(textInput.text)
                	textInput.text = ''
                } else {            	
                    suggestionsBox.complete(suggestionsBox.currentItem)
                }
            }
        }

        SuggestionsPreview {
            // just to show you what you can type in
            model: keywordModel
        }

        SuggestionBox {
        	//TODO Binding loop detected for property "height"
            id: suggestionsBox
            model: keywordModel
            width: 200
            anchors.top: inputField.bottom
            anchors.left: inputField.left
            filter: inputField.textInput.text
            property: "name"
            onItemSelected: complete(item)

            function complete(item) {
                suggestionsBox.currentIndex = -1
                if (item !== undefined)
                    inputField.textInput.text = item.name
            }
        }

    }

}

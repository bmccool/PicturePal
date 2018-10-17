import sys
from PySide2.QtWidgets import (QLineEdit, QPushButton, QApplication,
    QVBoxLayout, QDialog, QFileSystemModel, QTreeView)
from PySide2.QtQuick import QQuickView
from PySide2.QtCore import QUrl, QDir, QStringListModel, QObject, Signal, Property

from picture_utils import *

class Form(QDialog):

    def __init__(self, parent=None):
        super(Form, self).__init__(parent)
        # Create widgets
        self.edit = QLineEdit("Write my name here")
        self.button = QPushButton("Show Greetings")
        # Create layout and add widgets
        layout = QVBoxLayout()
        layout.addWidget(self.edit)
        layout.addWidget(self.button)
        # Set dialog layout
        self.setLayout(layout)
        # Add button signal to greetings slot
        self.button.clicked.connect(self.greetings)

    # Greets the user
    def greetings(self):
        print ("Hello %s" % self.edit.text())


class Backend(QObject):
    textChanged = Signal(str)

    def __init__(self, parent=None):
        QObject.__init__(self, parent)
        self.m_text = ""
        self.model = QStringListModel()

    @Property(str, notify=textChanged)
    def text(self):
        return self.m_text

    @text.setter
    def setText(self, text):
        if self.m_text == text:
            return
        self.m_text = text
        self.textChanged.emit(self.m_text)

    def processFolder(self, folder):
        print("PROCESSING FOLDER")
        folder = folder.strip("file:///") # Remove unnecessary bits
        pictures = None
        pictures = get_all_pictures(folder)
        keywords = get_keywords(pictures)
        keywords = sort_dict(keywords)
        captions = []
        for picture in pictures:
            captions.append(str(picture[1]))
        #Pictures is a list, Keywords is a dict
        self.model.setStringList(captions)
    


if __name__ == '__main__':
    app = QApplication(sys.argv)
        



    # Create the Qt Application
    # Create and show the form
    #form = Form()
    #form.show()
    view = QQuickView()
    view.setResizeMode(QQuickView.SizeRootObjectToView)
    url = QUrl("SimpleDialog.qml")

    backend = Backend()
    #backend.textChanged.connect(lambda text: print(text))
    backend.textChanged.connect(lambda text: backend.processFolder(text))

    #Expose a model to the QML code

    view.rootContext().setContextProperty("myModel", backend.model)
    view.rootContext().setContextProperty("backend", backend)

    view.setSource(url)
    view.show()
    # Run the main Qt loop
    

    
    """
    # Shows a file tree view of current direcoty
    model = QFileSystemModel()
    model.setRootPath(QDir.currentPath())

    tree =  QTreeView()
    tree.setModel(model)
    tree.show()

    """
    sys.exit(app.exec_())
import sys
from PySide2.QtWidgets import (QLineEdit, QPushButton, QApplication,
    QVBoxLayout, QDialog, QFileSystemModel, QTreeView)
from PySide2.QtQuick import QQuickView
from PySide2.QtCore import QUrl, QDir

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

if __name__ == '__main__':
    app = QApplication(sys.argv)
    

    # Create the Qt Application
    # Create and show the form
    #form = Form()
    #form.show()
    view = QQuickView()
    url = QUrl("SimpleDialog.qml")
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
import sys
from PySide2.QtWidgets import (QLineEdit, QPushButton, QApplication,
    QVBoxLayout, QDialog, QFileSystemModel, QTreeView)
from PySide2.QtQuick import QQuickView
from PySide2.QtCore import QUrl, QDir, QStringListModel, QObject, Signal, Slot, Property, QAbstractItemModel, QAbstractListModel, Qt, QModelIndex
from PySide2.QtQml import QQmlApplicationEngine


from picture_utils import *

class PictureModel(QAbstractListModel):
    FilenameRole = Qt.UserRole + 1
    CaptionRole = Qt.UserRole + 2

    _roles = {FilenameRole: b"name", CaptionRole: b"caption"}

    def __init__(self):
        super(PictureModel, self).__init__()
        self._pictures = []

    def setPictureList(self, pictures):
        self.beginResetModel()
        self._pictures = pictures
        self.endResetModel()

    def rowCount(self, in_index):
        return len(self._pictures)

    def data(self, QModelIndex, role=None):
        row = QModelIndex.row()
        if role == self.FilenameRole:
            return str(self._pictures[row][0])

        if role == self.CaptionRole:
            return str(self._pictures[row][1])

    def roleNames(self):
        return self._roles

    #TODO shouldn't i be able to do this with data???
    def getPicturePath(self, row):
        return str(self._pictures[row][0])


class Backend(QObject):
    textChanged = Signal(str)

    def __init__(self, parent=None):
        QObject.__init__(self, parent)
        self.m_text = ""
        self.pictureModel = PictureModel()
        self.keywordModel = QStringListModel()
        self.pictures = None
        self.keywords = None

    @Property(str, notify=textChanged)
    def text(self):
        return self.m_text

    @text.setter
    def setText(self, text):
        # We want to get notified even if it is the same thing... right?
        #TODO need to handle duplicates somehow...
        #if self.m_text == text:
        #    return
        self.m_text = text
        self.textChanged.emit(self.m_text)

    def processFolder(self, folder):
        folder = folder.strip("file:///") # Remove unnecessary bits
        #TODO get_all_pictures shouldn't overwrite what's in pictures, but add to it.
        self.pictures = get_all_pictures(folder)
        self.updateKeywordModel()
        #TODO keywords model?
        self.pictureModel.setPictureList(self.pictures)

    def updateKeywordModel(self):
        self.keywords = get_keywords(self.pictures)
        print(self.keywords)
        self.keywordModel.setStringList(self.keywords)

    @Slot(int, result=str)
    def getPicUrl(self, index):
        return self.pictureModel.getPicturePath(index)

    @Slot(result=int)
    def numPics(self):
        return self.pictureModel.rowCount(None)

    @Slot()
    def clearPics(self):
        #TODO is deleting the model really the best way to do this?
        del self.pictureModel
        self.pictureModel = PictureModel()

if __name__ == '__main__':
    app = QApplication(sys.argv)
    app.setOrganizationName("McCoolStuff")
    app.setOrganizationDomain("McCoolStuff.com")
    app.setApplicationName("PicturePal")
    engine = QQmlApplicationEngine()

    url = QUrl("SimpleDialog.qml")

    backend = Backend()
    backend.textChanged.connect(lambda text: backend.processFolder(text))

    #Expose a model to the QML code
    engine.rootContext().setContextProperty("pictureModel", backend.pictureModel)
    engine.rootContext().setContextProperty("keywordModel", backend.keywordModel)
    engine.rootContext().setContextProperty("backend", backend)

    engine.load(url)
    win = engine.rootObjects()[0]
    win.show()

    # Run the main Qt loop
    sys.exit(app.exec_())
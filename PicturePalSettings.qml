import Qt.labs.settings 1.0
import QtQuick 2.1

Item {
	id: settings

    // Store folders across restarts
    Settings {
        property alias datastore: settings.datastore
    }
    property string datastore: ""
    // Restore data on bootup.  Run once when app is started.. TODO is this only run once?
    Component.onCompleted: {
        console.log("App started!  Restoring settings...");
        if (datastore) {
            var datamodel = JSON.parse(datastore);
            for (var i = 0; i < datamodel.length; ++i) {
                backend.text = datamodel[i].folder;
                folderModel.append({"folder": datamodel[i].folder});
            }

        }
    }
    // Store data on shutdown
    Component.onDestruction: {
        console.log("App closing!  Saving settings...");
        var datamodel = [];
        for (var i = 0; i < folderModel.count; ++i) datamodel.push(folderModel.get(i));
        datastore = JSON.stringify(datamodel);
    }
}
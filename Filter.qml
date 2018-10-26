import QtQuick 2.1

Item {
    id: component
    property alias model: filterModel

    property QtObject sourceModel: undefined
    property string filter: ""
    property string property: ""

    Connections {
        onFilterChanged: invalidateFilter()
        onPropertyChanged: invalidateFilter()
        onSourceModelChanged: invalidateFilter()
    }

    Component.onCompleted: invalidateFilter()

    ListModel {
        id: filterModel
    }


    // filters out all items of source model that does not match filter
    function invalidateFilter() {
        if (sourceModel === undefined) {
            return
        }

        filterModel.clear();

        if (!isFilteringPropertyOk()) {
            return
        }

        var length = sourceModel.rowCount()
        for (var i = 0; i < length; ++i) {
            var item = sourceModel.data(sourceModel.index(i, 0));
            if (isAcceptedItem(item)) {
                filterModel.append({"name":item})
            }
        }
    }


    // returns true if item is accepted by filter
    function isAcceptedItem(item) {
        // Reject item if it is undefined...
        if (item === undefined) {
            return false
        }

        // Reject item if the filter cannot be found in the item
        if (item.match(this.filter) === null) {
            return false
        }

        // Reject the item if it is the filter in it's entirety (it's already there, no need to suggest)
        if (item === this.filter) {
            return false
        }

        return true
    }

    // checks if it has any sence to process invalidating based on property
    function isFilteringPropertyOk() {
        if(this.property === undefined || this.property === "") {
            return false
        }
        return true
    }
}


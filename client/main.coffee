Session.set 'files', []
Session.set 'selectedEntries', []
Session.set 'currentPath', []
Session.set 'result', []

Template.main.events
    'click .entry' : (event) ->
        currentPath = $(event.currentTarget).data('path')
        files = Session.get 'files'
        selectedEntries = Session.get 'selectedEntries'
        selectedEntry = _.where files, {path: currentPath}
        selectedEntry = selectedEntry[0]

        if selectedEntry.isFile
            isPresent = _.where selectedEntries, {path: selectedEntry.path}
            if isPresent.length is 0
                selectedEntries.push selectedEntry
                $(event.currentTarget).addClass('selected')
            else
                selectedEntries.splice (selectedEntries.indexOf selectedEntry), 1
                $(event.currentTarget).removeClass('selected')
            Session.set 'selectedEntries', selectedEntries
        else
            listDirectory selectedEntry.path
    'click .breadcrumb a' : (event) ->
        clickedPath = $(event.currentTarget).data('path')
        currentPath = Session.get 'currentPath'
        foundPath = _.where currentPath, {path: clickedPath}
        foundPath = foundPath[0]
        pathIndex = _.indexOf currentPath, foundPath
        currentPath.splice pathIndex
        Session.set 'currentPath', currentPath
        listDirectory clickedPath
    'click #showSelectedButton' : () ->
        Session.set 'result', []
        selectedEntries = Session.get 'selectedEntries'
        Session.set 'selectedEntries', []
        if $(':radio:checked').val() is '0'
            options = {long : true}
        else
            options = {download : true}
        _.each selectedEntries, (selectedEntry) ->
            client.makeUrl selectedEntry.path, options, (error, url) ->
                result = Session.get 'result'
                result.push url
                Session.set 'result', result

clientOptions =
    key: "uPZ6Sg+IIYA=|Xuhqd34aPx4xgfmwPiYIHVBAnMEfTLQoZwvFo9PXPg=="
    sandbox: true

client = new Dropbox.Client
    key: "uPZ6Sg+IIYA=|Xuhqd34aPx4xgfmwPiYIHVBAnMEfTLQoZwvFo9PXPg=="
    sandbox: true

client.authDriver new Dropbox.Drivers.Redirect()

client.authenticate (error, client) ->
    if error
        if console?
            console.log 'Authentication Error', error
    Session.set 'credentials',
        token: client.oauth.token
        tokenSecret: client.oauth.tokenSecret
    proceedWithApp()


proceedWithApp = ->
    listDirectory ('/')

listDirectory = (path) ->
    Session.set 'files', []
    Session.set 'selectedEntries', []
    Session.set 'result', []

    client.readdir path, (error, entriesNames, metadata, entries) ->
        if error
            if console?
                console.log 'Error', error
        files = []
        for entry, index in entries
            if entry.hasThumbnail
                entry.thumbnailUrl = client.thumbnailUrl entry.path
            files[index] = entry
        Session.set 'files', files

        if metadata.name is ''
            metadata.name = 'Home'
        currentPath = (Session.get 'currentPath')
        currentPath.push metadata
        Session.set 'currentPath', currentPath

Template.main.entries = ->
    Session.get 'files'

Template.main.currentPath = ->
    Session.get 'currentPath'

Template.main.getThumbnailUrl = (entry) ->
    client.thumbnailUrl entry.path

Template.main.isSelected = (entry) ->
    selectedEntries = Session.get 'selectedEntries'
    isPresent = _.where selectedEntries, {path: entry.path}
    isPresent.length isnt 0

Template.main.result = ->
    Session.get 'result'


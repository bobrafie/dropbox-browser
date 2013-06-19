# dropbox-browser

Dropbox file browser written in [CoffeeScript](http://coffeescript.org) on top of [Meteor](http://meteor.com) using [dropbox-js](http://github.com/dropbox/dropbox-js)



## Features

* Lists files and folders
** Files and folders have different icons
* Image files have thumbnails
* Click folder to navigate into it
* Navigate back up using the breadcrumb navigation
* Click to select/deselect multiple files
* Click the 'Show Selected' button to display a list of links pointing to the files on Dropbox
** Radio buttons allow to choose between preview or direct links

## Limitations

* Forces the user to log into Dropbox when the application is loaded.
* Image files thumbnails are re-fetched every time (I believe it's due to a limitation with dropbox-js)

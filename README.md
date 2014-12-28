listRed
=======

View/edit R list objects in the browser via httpuv

Installation
============

Install the devtools package if necessary (install.packages("devtools")) and run:

devtools::install_github("balcomes/listRed")

Example Usage
=============

go()

Starts the web application and opens your default browser.

sendList(as.list(mtcars))

Converts a list to JSON and sends it to the JSON editor in the browser

new_list <- returnList()

Sends the modified list back to the R console

See the following page for more information on the JSON editor:
https://github.com/josdejong/jsoneditor

# Connect is an awesome library with one of the best extensibility models
# I've ever seen. There all sorts of awesome plugins (middleware) available
# that provide all the basic web server stuff and more.

connect = require 'connect'

# Just get a server instance
server = connect()
# Tell it to use the built-in static middleware serving up static content
# from the _public_ directory.
server.use connect.static('public')

# Start it up
port = 3001
server.listen port

console.log "The static file server using connect is listening at #{port}"

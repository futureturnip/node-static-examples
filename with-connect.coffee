# with connect
connect = require 'connect'

server = connect()
server.use connect.static('public')

port = 3001
server.listen port

console.log "The static file server using connect is listening at #{port}"

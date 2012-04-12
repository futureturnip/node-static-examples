# Hand-crafted

http = require 'http'
fs = require 'fs'

serve_file = (request, response) ->
  console.log "Serving #{request.url}"
  context = { request, response }
  fs.readFile 'public' + request.url, after_file_is_read(context)

after_file_is_read = (context) ->
  (error, data) ->
    console.log "The requested file has been read"
    context =  context extends {error, data}
    respond_with_file(context) or respond_with_error(context)

respond_with_file = (context) ->
  if context.error then return undefined
  console.log "Responding with the file"
  {response, data} = context
  response.writeHead 200, {"Content-Type":"text/html"}
  response.end data
  @

respond_with_error = (context) ->
  if not context.error then return undefined
  console.log "There was an error: #{context.error}"
  respond_with_404(context) or respond_with_500(context)
  @

respond_with_404 = (context) ->
  {request, response, error} = context
  if error?.code isnt 'ENOENT' then return undefined
  response.writeHead 404, { "Content-Type":"text/plain" }
  response.end "404: Can't find the resource at #{request.url}"
  @

respond_with_500 = (context) ->
  {response, error} = context
  response.writeHead 500, { "Content-Type": "text/plain" }
  response.end "500: #{context.error}"

server = http.createServer serve_file
port = 3000
server.listen port

server.listen port
console.log "The hand-crafted static file server is listening on port #{port}"
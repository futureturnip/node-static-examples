# Hand-crafted

http = require 'http'
fs = require 'fs'

# This is the callback that the http server calls for every request.
# It bundles up the request and response into an object that is
# passed throughout.
serve_file = (request, response) ->
  console.log "Serving #{request.url}"
  context = { request, response }
  fs.readFile 'public' + request.url, after_file_is_read(context)

# The `after_file_is_read` function returns the actual function that will
# be used when the asynchronous call to `fs.readFile` is complete. The value
# of `context` is captured in a closure.
after_file_is_read = (context) ->
  (error, data) ->
    console.log "The requested file has been read"

    # using `extends` to add properties on the context at runtime.
    # So cool it made me giggle.
    context =  context extends {error, data}

    # Might be getting a little too fancy here but it read really nice IMO.
    # Still in the experimental stages with CoffeeScript
    respond_with_file(context) or respond_with_error(context)

# `respond_with_file` is used in the blue-sky case. Where the `fs.readFile`
# call was a success.
respond_with_file = (context) ->
  # This check immediately returns undefined if there is an error.
  # This causes the caller to call the `respond_with_error` method.
  if context.error then return undefined
  console.log "Responding with the file"
  {response, data} = context
  response.writeHead 200, {"Content-Type":"text/html"}
  response.end data
  # Just wanted to ensure that I was returning something that was not undefined
  # Note that if I returned `false`, I've made a bug. However, returning @ has
  # the advantage of allowing chaining also.
  @

# This is the start of a rudimentary error handler.
respond_with_error = (context) ->
  if not context.error then return undefined
  console.log "There was an error: #{context.error}"
  respond_with_404(context) or respond_with_500(context)
  @

# Not Found errors
respond_with_404 = (context) ->
  {request, response, error} = context
  # CoffeeScript awesomeness
  if error?.code isnt 'ENOENT' then return undefined
  response.writeHead 404, { "Content-Type":"text/plain" }
  response.end "404: Can't find the resource at #{request.url}"
  @

# All other errors
respond_with_500 = (context) ->
  {response, error} = context
  response.writeHead 500, { "Content-Type": "text/plain" }
  response.end "500: #{context.error}"
  @

# Get the server up and running
server = http.createServer serve_file
port = 3000
server.listen port

server.listen port
console.log "The hand-crafted static file server is listening on port #{port}"
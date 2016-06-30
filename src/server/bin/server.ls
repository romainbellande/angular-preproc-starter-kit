normalizePort = (val) ->
  port = parseInt val, 10

  if isNaN port
    return val

  if port >= 0
    return port

  return false
/**
 * Event listener for HTTP server "error" event
 */

onError = (error) ->
  if error.syscall !== \listen
    throw error

  bind = typeof port == \string ? 'Pipe ' + port : 'Port ' + port

  # handle specific listen errors with friendly messages
  switch error.code
    case \EACCES'
      console.error bind + ' requires elevated privileges'
      process.exit 1
      break
    case \EADDRINUSE
      console.error bind + ' is already in use'
      process.exit 1
      break
    default
      throw error

/**
 * Event listener for HTTP server "listening" event.
 */

onListening = ->
  addr = server.address()
  bind = typeof addr === \string ? 'pipe ' + addr : 'port ' + addr.port;
  debug 'Listening on ' + bind

app = require \../app
debug = require(\debug)(\server:server)
http = require \http
port = normalizePort process.env.port || \3000
app.set \port, port
console.log "Server hosted on port " + port

server = http.createServer app
server.listen port
server.on \error, onError
server.on \listening, onListening

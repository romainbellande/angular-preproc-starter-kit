express = require \express
path = require \path
favicon = require \serve-favicon
cookieParser = require \cookie-parser
bodyParser = require \body-parser
config = require \./config
cors = require \cors
angulatool = require \./vendor/angulatool-server/angulatool-server

# mongoose = require \mongoose

app = express()

app.set \env \development
app.use(express.static(path.join(__dirname, \../client)))
app.use cors()
# development error handler
# will print stacktrace
if app.get \env === \development
  app.use(
    (err, req, res, next) ->
      res.status err.status || 500
      res.render \error, {
        message: err.message,
        error: err
      }
  )

app.use angulatool.Router.create \user do
  name: String
  password: String
# production error handler
# no stacktraces leaked to user
app.use(
  (err, req, res, next) ->
    res.status err.status || 500
    res.render \error', {
      message: err.message
      error: {}
    }
)
module.exports = app

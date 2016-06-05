express = require \express
path = require \path
favicon = require \serve-favicon
cookieParser = require \cookie-parser
bodyParser = require \body-parser
config = require \./config
cors = require \cors
ejs = require \ejs
mongoose = require \mongoose

# index = require \./index
app = express()
app.set \views, path.join(__dirname, \views)
app.set 'view engine', \ejs
# app.set 'view engine', \jade
app.set \env \development
app.use(express.static(\../client))
app.use cors()
app.get \/, (req, res) ->
  res.render \../client/index.html

# app.use \/, index
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

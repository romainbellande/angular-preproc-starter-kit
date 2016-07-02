express = require \express
path = require \path
favicon = require \serve-favicon
cookieParser = require \cookie-parser
bodyParser = require \body-parser
config = require \./config
cors = require \cors
A = require \./vendor/angulatool-server/angulatool-server

app = express()

app.set \env \development
app.use cors!
app.use bodyParser.json!
app.use bodyParser.urlencoded { extended: false }
app.use cookieParser!
app.use express.static path.join __dirname, \../client

new A.Db \angulatool

class InfoBehavior extends A.Behavior
  ->
    super ...
  name: (req, res, next) ~>
    @getParams req, res, next, \name

user = new A.Entity do
  \user
  * name: String
    password: String
  * behaviors:
      * \info
        (req, res, next) ->
          res.send "#{@getName!} is a god"
      * \name
        -> @name ...
        InfoBehavior

app.use user.getRoute!

module.exports = app

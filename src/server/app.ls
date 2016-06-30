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

user = new A.Entity \user do
  name: String
  password: String
app.use user.getRoute!

module.exports = app

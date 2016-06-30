express = require \express
path = require \path
favicon = require \serve-favicon
cookieParser = require \cookie-parser
bodyParser = require \body-parser
config = require \./config
cors = require \cors
angulatool = require \./vendor/angulatool-server/angulatool-server

app = express()

app.set \env \development
app.use(express.static(path.join(__dirname, \../client)))
app.use cors()

user = new angulatool.Entity \user do
  name: String
  password: String
app.use user.getRoute!

module.exports = app

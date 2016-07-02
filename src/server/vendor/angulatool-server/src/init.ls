require! \express
require! \path
favicon = require \serve-favicon
cookieParser = require \cookie-parser
bodyParser = require \body-parser
require! \cors
Db = (require \./database/init).Db
app = express()

app.set \env \development
app.use cors!
app.use bodyParser.json!
app.use bodyParser.urlencoded { extended: false }
app.use cookieParser!
app.use express.static path.join __dirname, \../../../../client
module.exports = (dbName) ->
  new Db dbName
  app

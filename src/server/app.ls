A = (require \./vendor/angulatool-server/angulatool-server)

app = A.init \angulatool

User = require \./entities/user/user
Dog = require \./entities/dog/dog

app.use User.getRoute!
app.use Dog.getRoute!

module.exports = app

A = (require \./vendor/angulatool-server/angulatool-server)

app = A.init \angulatool

Dog = require \./entities/dog/dog
User = require \./entities/user/user

app.use User.getRoute!
app.use Dog.getRoute!

module.exports = app

A = require \../../vendor/angulatool-server/angulatool-server
InfoBehavior = require \../behaviors/infoBehavior
module.exports = new A.Entity \dog do
  dep:
    has_one: \user
  attrs:
    name: String
    race: String
    password: String

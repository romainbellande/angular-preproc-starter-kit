A = require \../../vendor/angulatool-server/angulatool-server
module.exports = new A.Entity \dog do
  dep:
    root: true
    has:
      one:
        * \meal
          child: true
        ...
  attrs:
    name: String
    race: String

A = require \../../vendor/angulatool-server/angulatool-server
InfoBehavior = require \../../behaviors/infoBehavior
module.exports = new A.Entity \user do
  dep:
    has_one:
      \dog
      child: true
  attrs:
    name: String
    password: String
  behaviors:
    * \troll
      (req, res, next) ->
        res.send "#{@getName!} is a god"
    * \name
      -> @name ...
      InfoBehavior
    * \info
      -> @info ...
      InfoBehavior

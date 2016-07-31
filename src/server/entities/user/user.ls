A = require \../../vendor/angulatool-server/angulatool-server
InfoBehavior = require \../../behaviors/infoBehavior
module.exports = new A.Entity \user do
  dep:
    has:
      one:
        * \dog
          child: true
        ...
      many:
        * \dog
          child: true
        ...
  attrs:
    name: String
    password: String
  behaviors:
    uniq:
      * \troll
        (req, res, next) ->
          res.send "#{@getName!} is a god"
      * \name
        -> @name ...
        InfoBehavior
      * \info
        -> @info ...
        InfoBehavior
    all:
      * \test
        (req, res, next) ->
          res.send \test
      ...

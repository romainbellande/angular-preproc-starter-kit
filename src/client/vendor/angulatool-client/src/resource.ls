# TO create a new directive, simply pu the code below

# new angulatool.resource (
#   name: \ResourceService
#   init: true
#   inject: []
#   func: ()->
# )
'use strict'
require! {
  \prelude-ls
}

window import prelude-ls

service = (params) ->
  @name = params.name
  @inject = params.inject ++ '$resource' ++ 'ResourceService'
  @callback = params.callback

  @base = (callback) ->
    (...args) ~>
      for toInjectInThis, j in params.inject
        @[toInjectInThis] = args[j]
      callback ...

  @init = ->
    console.log 'init service'
    (angular.module \app.services).service do
      params.name
      @inject ++ [@base(@callback)]

  @init?!

angulatool.setService service

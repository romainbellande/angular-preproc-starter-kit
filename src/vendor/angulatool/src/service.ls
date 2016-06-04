# TO create a new directive, simply pu the code below

# new angulatool.service (
#   name: \ComponentService
#   inject: []
#   func: ()->
# )

let
  'use strict'
  require! {
    \prelude-ls
  }

  window import prelude-ls

  service = (params) ->
    @name = params.name
    @inject = params.inject
    @callback = params.callback
    if params.isQService?
      @isQService = params.isQService
    if params.isResource?
      @isResource = params.isResource

    @base = (callback) ->
      (...args) ~>
        if @isQService
          args = args ++ [ params.name \ResourceService ]
        else if @isResource
          args = args ++ [\$resource \ResourceService]

        for toInjectInThis, j in params.inject
          @[toInjectInThis] = args[j]
        callback ...

    @init = ->
      category
      if @isResource
        category = \resource
      else
        category = \service

      (angular.module \app. + category + \s)[category] @name , @inject ++ [@base(@callback)]

    @init?!

  angulatool.setService service




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

  service = (...args) ->
    @name = args.0
    @inject = args.1
    @options = args.2
    # @inject = params.inject
    # @callback = params.callback
    if @options?
      if @options.isQService?
        @isQService = @options.isQService
      if @options.isResource?
        @isResource = @options.isResource

    @base = (callback) ->
      (...args) ~>
        args = args |> filter (.0 isnt \$)
        if @isQService
          args = args ++ [ params.name \ResourceService ]
        else if @isResource
          args = args ++ [\$resource \ResourceService]

        for toInjectInThis, j in params.inject
          @[toInjectInThis] = args[j]
        console.log params.callback.test
        callback ...

    @init = ~>
      category
      if @isResource
        category = \resource
      else
        category = \service

      (angular.module \app. + category + \s).service @name , @inject

    @init?!

  angulatool.setService service




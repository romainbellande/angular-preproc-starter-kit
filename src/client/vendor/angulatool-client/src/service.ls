# TO create a new directive, simply pu the code below

# new angulatool.service (
#   name: \ComponentService
#   inject: []
#   func: ()->
# )
'use strict'
require! {
  \prelude-ls
}

window import prelude-ls

service = (...args) ->
  @name = args.0
  @callback = args.1[\callback]
  # @inject = pn
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
        args = args ++ [args.0 \ResourceService]
      else if @isResource
        args = args ++ [\$resource \ResourceService]
      callback ...

  @init = ~>
    category
    if @isResource
      category = \resource
    else
      category = \service

    (angular.module \app. + category + \s).service do
      @name
      angulatool.getArgs(@callback) ++ [@callback]

  @init?!

angulatool.setService service

let
  'user strict'
  new angulatool.service do
    name: \=entities=Resource
    inject: <[ $resource ResourceService ConfigService] ]>
    isResource: true
    callback: ->
      @$resource ConfigService

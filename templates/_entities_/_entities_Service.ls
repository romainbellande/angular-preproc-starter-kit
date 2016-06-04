let
  'user strict'
  new angulatool.service do
    name: \=entities=Service
    inject: <[ $resource ResourceService] ]>
    isQService: true
    callback: ->

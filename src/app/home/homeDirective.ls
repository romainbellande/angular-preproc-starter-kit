let
  'use strict'
  console.log 'test directive'
  new angulatool.directive do

    name: \home

    inject:
      scope: ['$rootScope']
      self: ['$http']

    template: ''

    callback: (scope, elements, attrs) ->
      console.log \HomeDirectiveInit



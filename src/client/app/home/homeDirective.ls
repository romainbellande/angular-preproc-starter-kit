let
  'use strict'
  new angulatool.directive do

    name: \home

    inject:
      scope: ['HomeService']
      self: []

    template: ''

    callback: (scope, elements, attrs) ->



let
  'use strict'
  new angulatool.directive do

    name: \_component_

    inject:
      scope: ['=component=Service']
      self: []

    template: ''

    callback: (scope, elements, attrs) ->



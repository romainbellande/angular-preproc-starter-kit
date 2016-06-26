'use strict'

new angulatool.component \home do
  template: ''
  callback: ($scope, $element, $attrs, HomeService) !->
    console.log HomeService.blabla

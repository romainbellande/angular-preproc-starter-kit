'use strict'

new angulatool.component do
  name: \home
  template: ''
  callback: ($scope, $element, $attrs, HomeService) !->
    console.log HomeService

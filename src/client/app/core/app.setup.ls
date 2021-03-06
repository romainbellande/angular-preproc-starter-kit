"use strict"
angular
  .module \app [
    * \app.controllers
    * \app.directives
    * \app.components
    * \app.services
    * \app.resources
    * \app.constants
    * \ui.router
    * \ui.bootstrap
  ]
  .config ($httpProvider) !->
    $httpProvider.defaults.headers
      ..common = {}
      ..post = {}
      ..post = {}
      ..put = {}
      ..patch = {}
    $httpProvider.defaults.useXDomain = true
    delete! $httpProvider.defaults.headers.common.'X-Requested-With'
  .run ->

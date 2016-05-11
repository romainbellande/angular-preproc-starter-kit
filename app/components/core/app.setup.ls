angular
  .module \app do
    * \ionic
    * \app.controllers
    * \app.directives
    * \app.services
    * \app.resources
    * \app.constants
    * \ui.router
    * \ngStorage
    * \angularCSS
    * \ngCordova
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

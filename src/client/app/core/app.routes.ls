"use strict"
routes = ($stateProvider,$urlRouterProvider) !->
  $urlRouterProvider.otherwise \/
  $stateProvider
    ..state \home,
      * url: \/home
        template: \<home></home>
angular
  .module 'app'
  .config routes

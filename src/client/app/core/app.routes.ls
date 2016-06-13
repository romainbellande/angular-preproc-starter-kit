"use strict"
routes = ($stateProvider,$urlRouterProvider) !->
  $urlRouterProvider.otherwise \/
  $stateProvider
    ..state \home,
      * url: \/test3
        template: \<home></home>
angular
  .module 'app'
  .config routes

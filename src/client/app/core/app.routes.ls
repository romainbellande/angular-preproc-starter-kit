"use strict"
routes = ($stateProvider,$urlRouterProvider) !->
  $urlRouterProvider.otherwise \/
  $stateProvider
    ..state \home,
      * url: \/
        template: \<home></home>
angular
  .module 'app'
  .config routes

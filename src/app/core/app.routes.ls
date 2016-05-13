"use strict"
routes = ($stateProvider,$urlRouterProvider) ->
  $stateProvider
    ..state \home,
      * url: \home
        template: \<home></home>

# 'use strict'
# home = (HomeService) ->
#   directive =
#     link: link
#     restrict: \E
#     template: ''

#   link = (scope, element, attrs) !->
#     scope.HomeService = HomeService
#   directive

# home.$inject = [
#   \HomeService
# ]

# (angular.module \app.directives).directive \home, home
template = ''
angulatool.directive "home" template

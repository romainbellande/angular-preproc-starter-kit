wall = (WallService, UserService, TastingService) ->
  directive =
    link: link
    restrict: \E
    template: ''


  link = (scope, element, attrs) !->
    scope.TastingService = TastingService
    scope.UserService = UserService
    TastingService.getUserTastings (err, res) !->
      TastingService.tastings = res if not err
  directive

wall.$inject =
  * \WallService
  * \UserService
  * \TastingService

(angular.module 'app.directives').directive 'wall', wall

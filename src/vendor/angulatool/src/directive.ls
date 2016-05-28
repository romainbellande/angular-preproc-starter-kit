
window.angulatool.directive: (name, inject, template) ->
  class Directive extends window.Base name, injects
    constructor ->
      (angular.module \app.directives).directive name, @base(template, inject)
      super?!

    @base (template, link) ->
      params =
        link: link
        restrict: \E
        template: template




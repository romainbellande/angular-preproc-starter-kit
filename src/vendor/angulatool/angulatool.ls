let
  window.angulatool
# 'use strict'
# require! {
#   \prelude-ls
# }

# window import prelude-ls

# window.angulatool = ->
#   directive (name, template, callback) ->
#     nameCapitalized = capitalize(name)
#     @func = (...args) ->
#       params =
#         link: link
#         restrict: \E
#         template: template

#       link = (scope, elements, attrs) !->
#         scope[nameCapitalized + "Service"]  = args.0
#         callback?!

#     @func.$inject = [
#       nameCapitalized + \Service
#     ]

#     angular.module \app.directives .directive name, @func

# let
#   'use strict'
#   window.base = (name, injects, func) ->
#     Base
#       @._name: name
#       @._injects: injects
#       @._func: func
#       constructor ->
#         console.log 'test'
#         if not name
#           console.error \N.Base must have a name
#         @.injection?!

#       @.injection = ->
#         for index, inject in @._injects
#           @._func.$inject[index] = inject

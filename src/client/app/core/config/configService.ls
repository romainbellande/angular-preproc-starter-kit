# let
#   'user strict'
#   new angulatool.service do
#     name: \=entities=Service
#     inject: <[ $location] ]>
#     callback: ->
#       /*============================
#       =            VARS            =
#       ============================*/

#       @env = ''
#       @config = YAML.load \app/core/config/config.YAML

#       /*=====  End of VARS  ======*/
#       /*===============================
#       =            METHODS            =
#       ===============================*/

#       @setEnv = (env) ~>
#         if angular?
#           @env = env
#         else if @$location.$$host === \localhost
#           @env = \development
#         else
#           @env = \staging

#       @getEnv = ~> @.env

#       @getApiUrl = ~> @config.env[@env].baseUrl + \/api

#       @getRoute = (routeName) ~> @getApiUrl() + @config.routes[routeName]

#       /*=====  End of METHODS  ======*/
#       /*============================
#       =            INIT            =
#       ============================*/

#       @setEnv 'development'

#       /*=====  End of INIT  ======*/



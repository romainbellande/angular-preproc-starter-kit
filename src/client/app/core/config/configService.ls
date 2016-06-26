'user strict'
new angulatool.service \ConfigService do
  \$location
  callback: ->

    @env = ''
    @config = YAML.load \app/core/config/config.yml

    @setEnv = (env) ~>
      if env?
        @env = env
      else if $location.host() === \127.0.0.1
        @env = \development
      else
        @env = \production

    @getEnv = ~> @env

    @getApiUrl = ~> @config.env[@env].baseUrl + \/api/

    @getBaseUrl = (routeName) ~> @getApiUrl! + @config.routes[routeName]



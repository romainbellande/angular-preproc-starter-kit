let
  'use strict'

  new angulatool.service do
    name: \ResourceService
    inject: []
    callback: ->

      /*===============================
      =            METHODS            =
      ===============================*/

      @base_interception = (response) ->
        result = response.resource
        result.status = response.status
        result

      @createMethod = (array) ->
        if array?
          method = array.method || 'GET'
          isArray = array.isArray || false
          auth = array.auth || false
          interceptor = array.interceptor || true
          params = array.params || undefined
        {
          method: method
          isArray: isArray
          headers:
            if auth
              {
                \Authorization : (requestConfig) ->
                  'Bearer ' + \montoken
                \Content-Type : \application/json
              }
            else
              {
                \Content-Type : \application/json
              }

          interceptor:
            if interceptor
              val =
                response: self.base_interceptor
            else
              val = undefined
          params: params
        }

      @query = (query, callback) ->
        query.$promise.then (success) ->
          if callback?
              callback null, success
        .catch (error) ->
          if callback?
            callback error




      /*=====  End of VARS  ======*/

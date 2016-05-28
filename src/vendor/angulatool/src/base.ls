let
  window.Base: (name, injects) ->
  class Base
    @._name: name
    @._injects: injects
    constructor ->
      if not name
        console.error \N.Base must have a name

(function(){
  angular.module('app', ('ionic', 'app.controllers', 'app.directives', 'app.services', 'app.resources', 'app.constants', 'ui.router', 'ngStorage', 'angularCSS', 'ngCordova')).config(function($httpProvider){
    var x$;
    x$ = $httpProvider.defaults.headers;
    x$.common = {};
    x$.post = {};
    x$.post = {};
    x$.put = {};
    x$.patch = {};
    $httpProvider.defaults.useXDomain = true;
    delete $httpProvider.defaults.headers.common['X-Requested-With'];
  }).run(function(){});
}).call(this);

//# sourceMappingURL=../../maps/components/core/app.setup.js.map

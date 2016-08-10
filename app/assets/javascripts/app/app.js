/*
 * Modules injection
 */
angular.module('app', [
  'templates',
  'ui.router',
  'ngResource',
  'ngMaterial',
  'angulartics',
  'angulartics.google.analytics',
]);

/*
 * Global theme
 */
angular.module('app').config(['$mdThemingProvider',
  function($mdThemingProvider) {
    $mdThemingProvider.theme('default')
      .primaryPalette('blue')
      .accentPalette('teal');
  }
]);

/*
 * Utility methods
 */
var Util = {
  toApi: function(value) {
    return (value || '');
  }
};

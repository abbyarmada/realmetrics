angular.module('app').config(['$stateProvider',
  function($stateProvider) {
    $stateProvider

    /*
     * Sessions - Login
     */
    .state('login', {
      url: '/login',
      parent: 'public',
      templateUrl: 'app/templates/sessions/new.html',
      controller: 'NewSessionController'
    });
  }
]);

angular.module('app').config(['$stateProvider',
  function($stateProvider) {
    $stateProvider

    /*
     * Passwords - New
     */
    .state('forgot_password', {
      url: '/passwords/new',
      parent: 'public',
      templateUrl: 'app/templates/passwords/new.html',
      controller: 'NewPasswordController'
    })

    /*
     * Passwords - Reset
     */
    .state('reset_password', {
      url: '/passwords/new/:token',
      parent: 'public',
      templateUrl: 'app/templates/passwords/edit.html',
      controller: 'EditPasswordController'
    });
  }
]);

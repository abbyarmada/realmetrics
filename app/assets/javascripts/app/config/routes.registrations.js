angular.module('app').config(['$stateProvider',
  function($stateProvider) {
    $stateProvider

    /*
     * Registrations - New
     */
    .state('signup', {
      url: '/signup',
      parent: 'public',
      templateUrl: 'app/templates/registrations/new.html',
      controller: 'NewRegistrationController'
    })

    /*
     * Registrations - Confirm
     */
    .state('confirm', {
      url: '/registrations/confirm/:token',
      parent: 'public',
      templateUrl: 'app/templates/registrations/confirm.html',
      controller: 'ConfirmRegistrationController'
    });
  }
]);

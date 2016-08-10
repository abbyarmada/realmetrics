angular.module('app').config(['$stateProvider',
  function($stateProvider) {
    $stateProvider

    /*
     * Setup
     */
    .state('setup', {
      url: '/setup',
      parent: 'fullscreen',
      templateUrl: 'app/templates/setup/index.html',
      controller: 'SetupController',
      resolve: {
        current_organization: ['NotificationService', 'SessionsService',
          function(NotificationService, SessionsService) {
            return SessionsService.current_organization().$promise.then(
              function(data) {
                return data;
              },
              NotificationService.handleError
            );
          }
        ]
      }
    });
  }
]);

angular.module('app').config(['$stateProvider',
  function($stateProvider) {
    $stateProvider

    /*
     * Layouts - Public areas
     */
    .state('public', {
      views: {
        'layout': {
          templateUrl: 'app/templates/layouts/public.html',
          resolve: {
            current_user: ['$state', 'SessionsService',
              function($state, SessionsService) {
                return SessionsService.current().$promise.then(
                  function() {
                    $state.go('home');
                  },
                  function() {
                    return null;
                  }
                );
              }
            ]
          }
        }
      }
    })

    /*
     * Layouts - Setup
     */
    .state('fullscreen', {
      views: {
        'layout': {
          templateUrl: 'app/templates/layouts/fullscreen.html',
          resolve: {
            current_user: ['NotificationService', 'SessionsService',
              function(NotificationService, SessionsService) {
                return SessionsService.current().$promise.then(
                  function(data) {
                    return data;
                  },
                  NotificationService.handleError
                );
              }
            ]
          }
        }
      }
    })

    /*
     * Layouts - Authenticated areas
     */
    .state('app', {
      views: {
        'layout': {
          templateUrl: 'app/templates/layouts/app.html',
          controller: 'AppController',
          resolve: {
            current_user: ['NotificationService', 'SessionsService',
              function(NotificationService, SessionsService) {
                return SessionsService.current().$promise.then(
                  function(data) {
                    return data;
                  },
                  NotificationService.handleError
                );
              }
            ],
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
        }
      }
    });
  }
]);

angular.module('app').config(['$stateProvider',
  function($stateProvider) {
    $stateProvider

    /*
     * Plans - List
     */
    .state('plans', {
      url: '/plans',
      parent: 'app',
      templateUrl: 'app/templates/plans/index.html',
      controller: 'PlansController',
      resolve: {
        plans: ['NotificationService', 'PlansService',
          function(NotificationService, PlansService) {
            return PlansService.query().$promise.then(
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

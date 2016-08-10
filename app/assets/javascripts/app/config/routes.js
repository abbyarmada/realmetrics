angular.module('app').config(['$stateProvider', '$locationProvider', '$urlRouterProvider',
  function($stateProvider, $locationProvider, $urlRouterProvider) {
    $locationProvider.html5Mode(true);

    /*
     * Home
     */
    $stateProvider.state('home', {
      url: '/home',
      parent: 'app',
      templateUrl: 'app/templates/home/index.html',
      controller: 'HomeController',
      resolve: {
        revenues: ['NotificationService', 'ReportsService',
          function(NotificationService, ReportsService) {
            return ReportsService.revenues().$promise.then(
              function(data) {
                return data;
              },
              NotificationService.handleError
            );
          }
        ],
        customers: ['NotificationService', 'ReportsService',
          function(NotificationService, ReportsService) {
            return ReportsService.customers().$promise.then(
              function(data) {
                return data;
              },
              NotificationService.handleError
            );
          }
        ]
      }
    });

    $urlRouterProvider.otherwise('home');
  }
]);

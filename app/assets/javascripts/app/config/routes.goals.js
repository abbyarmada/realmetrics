angular.module('app').config(['$stateProvider', '$locationProvider', '$urlRouterProvider',
  function($stateProvider, $locationProvider, $urlRouterProvider) {
    /*
     * Goals - List
     */
    $stateProvider.state('goals', {
      url: '/goals',
      parent: 'app',
      templateUrl: 'app/templates/goals/index.html',
      controller: 'GoalsController',
      resolve: {
        gross_revenue_goals: ['NotificationService', '$stateParams', 'GoalsService',
          function(NotificationService, $stateParams, GoalsService) {
            return GoalsService.query({
              metric: 'gross_revenue'
            }).$promise.then(
              function(data) {
                return data;
              },
              NotificationService.handleError
            );
          }
        ],
        customers_count_goals: ['NotificationService', '$stateParams', 'GoalsService',
          function(NotificationService, $stateParams, GoalsService) {
            return GoalsService.query({
              metric: 'customers_count'
            }).$promise.then(
              function(data) {
                return data;
              },
              NotificationService.handleError
            );
          }
        ]
      }
    })

    /*
     * Goals - New
     */
    .state('goals.set_goals', {
      url: '/:metric/new',
      params: {
        sidepanel: true
      },
      views: {
        'sidepanel@app': {
          templateUrl: 'app/templates/goals/new.html',
          controller: 'GoalDetailsController',
          resolve: {
            goals: ['NotificationService', '$stateParams', 'GoalsService',
              function(NotificationService, $stateParams, GoalsService) {
                return GoalsService.query({
                  metric: $stateParams.metric
                }).$promise.then(
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
     * Goals - Edit
     */
    .state('goals.edit_goals', {
      url: '/:metric/edit',
      params: {
        sidepanel: true
      },
      views: {
        'sidepanel@app': {
          templateUrl: 'app/templates/goals/edit.html',
          controller: 'GoalDetailsController',
          resolve: {
            goals: ['NotificationService', '$stateParams', 'GoalsService',
              function(NotificationService, $stateParams, GoalsService) {
                return GoalsService.query({
                  metric: $stateParams.metric
                }).$promise.then(
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

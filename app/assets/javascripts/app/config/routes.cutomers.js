angular.module('app').config(['$stateProvider',
  function($stateProvider) {
    $stateProvider

    /*
     * Customers - List
     */
    .state('customers', {
      url: '/customers',
      parent: 'app',
      templateUrl: 'app/templates/customers/index.html',
      controller: 'CustomersController',
      resolve: {
        customers: ['NotificationService', 'CustomersService',
          function(NotificationService, CustomersService) {
            return CustomersService.query().$promise.then(
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
     * Customers - Show
     */
    .state('customers.show', {
      url: '/customers/:id',
      parent: 'app',
      templateUrl: 'app/templates/customers/show.html',
      controller: 'CustomerDetailsController',
      resolve: {
        customer: ['NotificationService', '$stateParams', 'CustomersService',
          function(NotificationService, $stateParams, CustomersService) {
            return CustomersService.show({
              id: $stateParams.id
            }).$promise.then(
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

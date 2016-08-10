angular.module('app').controller('CustomersController', ['NotificationService', '$scope', 'customers',
  function(NotificationService, $scope, customers) {
    /*
     * Initialiazer
     */
    (function() {
      $scope.customers = customers;
    })();
  }
]);

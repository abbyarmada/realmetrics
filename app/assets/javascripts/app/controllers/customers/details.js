angular.module('app').controller('CustomerDetailsController', ['NotificationService', '$scope', 'customer',
  function(NotificationService, $scope, customer) {
    /*
     * Initialiazer
     */
    (function() {
      $scope.customer = customer;
    })();
  }
]);
